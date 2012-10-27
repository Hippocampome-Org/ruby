#encoding: utf-8

module Hippocampome

  class EpdataStatementProcessor

    include CSVPort::RecordProcessor

    # Group numbering:
    # 1:pmid | 2:table_figure_quote | 3:number | 4:don't use | 5:n | 6:at

    pmid = /\d+/
    table_figure_quote = /.+/
    #number = /[\d±\s\.\-]+\d/
    number = /[\d±\s\.\-]+\d/
    #number = /[\d±\s\.\-,]+\d/  # current hack
    #number = /^-?\d+\.?\d+(\s*[±\-]?\s*-?\d+\.?\d+)?/
    n = /\d+/
    at = /[@\-\d\.]+/
    #@regex = /(#{pmid})\s*\{(#{table_figure_quote});\s*(#{number})\s*(\((#{n})\))?\}/
    @regex = /(#{pmid})\s*\{(#{table_figure_quote});\s*\[?(#{number})\]?\s*(\((#{n})\))?\s*(#{at})?\}/
    #@regex = /(#{pmid})\s*\{(#{table_figure_quote});\s*\[?(#{number})\]?\s*(#{at})?\s*(\((#{n})\))?\s*(#{at})?\}/  # current hack

    class << self
      attr_accessor :regex
    end

    attr_accessor :string
    attr_accessor :pmid
    attr_accessor :table_figure_quote
    attr_accessor :value1
    attr_accessor :value2
    attr_accessor :sem
    attr_accessor :error
    attr_accessor :n
    attr_accessor :istim
    attr_accessor :time
    attr_accessor :unique_id
    attr_accessor :unvetted

    def initialize(record)
      @record = record
    end

    def process
      unpack_fields
      @unvetted = Processors.unvetted?(@statement)
      @raw = @statement.dup  # we are going to digest the statement
      $field = @record.ep_property_name
      clean_statement
      check_if_unknown
      #check_if_not_yet_extracted
      #return nil if @not_yet_extracted
      if not @unknown
        binding.pry if @statement == "17185334_@"
        parse_statement
        validate_pmid_isbn
        parse_number
        remove_alphabetic_chars_from_values
        validate_values
        parse_at if @at
      end
      create_property
      #binding.pry
      export_record
    end

    #def process_statement
      #binding.pry
        #parse_statement
        #validate_pmid_isbn
        #parse_number
        #remove_alphabetic_chars_from_values
        #validate_values
        #parse_at if @at
    #rescue InvalidRecordError => e
      #raw_pmid = /^@_\d+$/
      #misc = /^X_@$/
      #if not @raw.match(raw_pmid) and (not @raw.match(misc))
        #e.log
      #else
        #raise e
      #end
    #end

    def clean_statement
      @statement = @statement.gsub('−', '-').gsub(' ', ' ').gsub('ą', 'q').delete("\r_").strip  # replace bad negative signs and spaces ('THIN SPACE!!!')
    end

    def check_if_unknown
      @unknown = (@statement.match(/^\s*\$/) ? true : false)
    end

    #def check_if_not_yet_extracted
      #binding.pry #if @statement.match(/19965717_@/)
      #@not_yet_extracted = ((@statement.match(/^@_\d*/) or @statement.match(/^\d+\s*_@/)) or @statement.match(/^\d+\s*$/))
    #end

    def parse_statement
      #binding.pry if @statement.include?('(16)')
      extract_pmid_isbn
      remove_whitespace
      #binding.pry
      remove_braces
      remove_whitespace
      #binding.pry
      extract_n_and_sem  # in rightside parens
      remove_whitespace
      #binding.pry
      extract_at
      remove_whitespace
      #binding.pry
      extract_table_figure_quote_and_number
      #binding.pry
    #rescue StandardError => e
      #binding.pry
    end

    def extract_pmid_isbn
      @pmid_isbn = @statement.slice!(/^[\d\-]{5,}/)
      raise CSVPort::InvalidRecordError.new(:type => :badly_formatted_field, raw_content: @raw, type_id: @record[:unique_id]) unless @pmid_isbn
      @pmid_isbn.delete!('-')
    end

    def remove_braces
      raise CSVPort::InvalidRecordError.new(:type => :badly_formatted_field, raw_content: @raw, type_id: @record[:unique_id]) unless @statement.match(/\{.*\}/)
      @statement.delete!('{}')
    end
                        
    def remove_whitespace
      @statement.strip!
    end

    def extract_n_and_sem
      rightside_parens = @statement.slice!(/;.*(\(.*?\))$/, 1)
      if rightside_parens
        @sem = rightside_parens.match(/SE/)
        @n = rightside_parens.gsub(/[\(\)A-Za-z]/, '').strip
      end
    end

    def extract_at
      @at = @statement.slice!(/@[@\-\d\.]+$/)
    end

    def extract_table_figure_quote_and_number
      @table_figure_quote, @number = @statement.split(';')
      @table_figure_quote.strip!
      @number.strip!
    end

    #def parse_statement
      #match = @statement.match(self.class.regex) 
      #raise CSVPort::InvalidRecordError.new(:type => :badly_formatted_field, raw_content: @statement) unless match
      #@pmid_isbn, @table_figure_quote, @number, @n, @at = *match.values_at(1,2,3,5,6)
    #end

    def validate_pmid_isbn
      if not Article[{pmid_isbn: @pmid_isbn}]
        binding.pry
        raise CSVPort::InvalidRecordError.new(:type => :missing_article_reference, pmid: @pmid_isbn, type_id: @record[:unique_id])
      end
    end

    def parse_number
      if number_is_range?  # is range, not negative
        #binding.pry
        delete_braces_from_range
        @number.strip!
        extract_range_values
        @error = nil
        @std_sem = "N/A"
      else  # is one number possibly with std
        extract_value_and_error
        @value2 = nil
        @std_sem = (@sem ? "sem" : "std")  # temporarily assign this for everything
      end
    end

    def delete_braces_from_range
      @number.delete!('[]')
    end


    def extract_range_values
      @value1, @value2 = @number.split(/\s*[,-]\s*/)
      @value1.strip!
      @value2.strip!
    end

    def extract_value_and_error
      @value1, @error = @number.split(/\s*[q±]\s*/)
      @value1.strip!
      @error.strip! if @error
    end

    def validate_values
      [@value1, @value2].compact.each do |value|
        raise CSVPort::InvalidRecordError.new(:type => :badly_formatted_field, raw_content: @raw) if (value.count('.') or value.include?('('))> 1  # check for formatting error
      end
    end

    def number_is_range?
      @number.include?('[')
      #stripped_number = @number.gsub(/\s*±\s*/, '').strip
      #@stripped_number.match(/\d+\s*[\-]\s*\d+/)
      #stripped_number.match(/\d+\s*[\-,]\s*\d+/)  # current hack
    end

    def parse_at
      @istim, @time = *@at.scan(/@-?[X\d]+/).map{|m| m.delete('@')}
      @istim = "unknown" if @istim == "X"
      @time = "unknown" if @time == "X"
    end

    def create_property
      @property = {
        subject: @ep_property_name,
        predicate: 'is between',
        object: (@unknown ? 'unknown' : '[-inf, +inf]')
      }
      remove_instance_variable("@ep_property_name")
    end

    def remove_alphabetic_chars_from_values
      [@value1, @value2].compact.each do |value|
        value.gsub!(/[a-zA-Z\s]/, '')
      end
    end

  end

end
