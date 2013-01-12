module Hippocampome

  class MarkerEvidenceLinkStatementProcessor

    include CSVPort::RecordProcessor

    def initialize(record)
      @record = record
    end

    def process
      unpack_fields
      remove_brackets
      remove_m
      extract_type_id
      extract_pmid
      export
    end

    def remove_brackets
      @statement.delete!('[]')
    end

    def remove_m
      @statement.slice!(/^m:/i)
    end

    def extract_type_id
      @type_id = @statement.slice!(/^\d-?\d+:/)
      extract_type_name
      if @type_id
        @type_id.delete!('-:')
      else 
        match_type_name_to_id if @type_name
      end
    end

    def extract_type_name
      @type_name = @statement.slice!(/^(\w+:.*?):/, 1)
      @type_name = nil if not (@type_name and @type_name.match(/\d{3,}/))
      if @type_name
        @statement.slice!(/^:/)
        extract_marker
      end
    end

    def extract_marker
      @marker = @statement.slice!(/^.*?:/)
    end

    def extract_pmid
      pmid = @statement.slice!(/PMID\s*\d+/)
      if not pmid
        pmid = @statement.slice!(/\d{6,}/)
        pmid = nil if (pmid and pmid.match(/[0-3]{6,}/)) # EC proj pattern
      end
      @pmid = pmid.gsub(/\D/, '') if pmid
    end

    def match_type_name_to_id
      @type_id = TypeMatcher.new(@type_name, @original_id, @marker).process
    end

    def export
      if @pmid and @type_id
        values = {
          type_id: @type_id,
          pmid_isbn: @pmid,
          original_id: @original_id,
          marker: @marker
        }
        CSVPort::Record.new(values)
      else
        nil
      end
    end

  end

end
