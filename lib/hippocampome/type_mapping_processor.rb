module Hippocampome

  class TypeMappingProcessor

    include CSVPort::RecordProcessor

    attr_accessor :type_id
    attr_accessor :type_nickname
    attr_accessor :synonyms

    TypeMappingStatement = Struct.new(:type_id, :type_nickname, :synonyms)

    def initialize(record)
      @record = record
    end

    def process
      if @record.type_mapping
        unpack_fields
        lines = @type_mapping.split(/\s*###\s*/)
        @type_mapping = lines.map { |line| parse_line(line) }
        export_record
      else
        return @record
      end
    end

    def parse_line(line)
      type_id, type_nickname, synonyms = line.split(': ')
      synonyms = synonyms.split(/\s*,\s*/)
      TypeMappingStatement.new(type_id, type_nickname, synonyms)
    end

  end

end
