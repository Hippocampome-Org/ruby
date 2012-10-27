module Hippocampome

  class MarkerdataRowProcessor

    include CSVPort::RecordProcessor

    def initialize(record)
      @record = record
      @marker_fields = @record.fields.reject{|k,v| k == 'type_id' or v.nil?}
    end

    def process
      type_id = Processors.clean_id_number(@record.fields["type_id"])
      record_list = @marker_fields.map do |marker, statement_list|
        unvetted = Processors.unvetted?(statement_list)
        statement_list.gsub!(/[^\d\.\s;\?]/, '')
        statement_list = statement_list.split(/\s*;\s*/)
        records = statement_list.map do |statement|
          hash = {
            unvetted: unvetted,
            marker: marker,
            type_id: type_id,
            statement: statement
          }
          CSVPort::Record.new(hash)
        end
      end
      record_list.flatten
    end

  end
end
