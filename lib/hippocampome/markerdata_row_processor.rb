module Hippocampome

  class MarkerdataRowProcessor

    include CSVPort::RecordProcessor

    @conflict_code = {
      '1' => "subtypes",
      '2' => "conflicting data",
      '3' => "species differences",
    }

    class << self
      attr_accessor :conflict_code
    end

    def initialize(record)
      @record = record
      @marker_fields = @record.fields.reject{|k,v| k == 'type_id' or v.nil?}
    end

    def process
      type_id = Processors.clean_id_number(@record.fields["type_id"])
      record_list = @marker_fields.map do |marker, statement_list|
        unvetted = Processors.unvetted?(statement_list)
        conflict_note = extract_conflict_note(statement_list)
        statement_list.gsub!(/[^\d\.\s;\?\[\]]/, '')
        statement_list = statement_list.split(/\s*;\s*/)
        statement_list.reject! { |statement| statement.include?('[') }  # ignore bracketed entries
        statement_list = merge_any_duplicates(statement_list)
        records = statement_list.map do |statement|
          hash = {
            unvetted: unvetted,
            conflict_note: conflict_note,
            marker: marker,
            type_id: type_id,
            statement: statement
          }
          CSVPort::Record.new(hash)
        end
      end
      record_list.flatten
    end

    def extract_conflict_note(statement_list)
      statement_list.strip!
      code = statement_list.slice!(/^\{(\d)\}/, 1)
      statement_list.delete!('{}')
      code ? self.class.conflict_code[code] : nil
    end

    def merge_any_duplicates(statement_list)  # if two statements have the same ref_id and a pos and neg exp, merge them to one
      ref_ids = statement_list.map { |s| get_statement_ref_id(s) }.uniq
      ref_ids.each do |ref_id|
        statements = statement_list.select { |s| get_statement_ref_id(s) == ref_id }
        if statements.length > 1
          statement_list -= statements
          statement_list << merge_statements(statements)
        end
      end
      statement_list
    end

    def merge_statements(statements)  # assumes statements have the same ref id
      expressions = statements.map { |statement| get_statement_code(statement)[0] }
      code = get_statement_code(statements.first)
      if expressions.include?('1') and expressions.include?('2')
        code[0] = '4'
      else
        code[0] = expressions.first
      end
      ref_id = get_statement_ref_id(statements.first)
      #code[0] = '4'  # we are assuming the second two digits do not change, i.e. same animal/protocol for same ref_id
      code + '.' + ref_id
    end

    def get_statement_code(statement)
      statement.split('.').first
    end

    def get_statement_ref_id(statement)
      statement.split('.').last
    end

  end
end
