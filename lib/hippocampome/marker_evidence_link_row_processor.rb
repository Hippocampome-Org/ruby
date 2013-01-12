module Hippocampome

  class MarkerEvidenceLinkRowProcessor

    include CSVPort::RecordProcessor

    def initialize(record)
      @record = record
    end

    def process
      return nil if not @record.fields[:interpretation]
      interpretations = @record.fields[:interpretation].scan(/\[.*?\]/)
      record_list = interpretations.map do |interpretation|
        hash = {
          original_id: @record.original_id,
          statement: interpretation
        }   
        CSVPort::Record.new(hash)
      end
      record_list.flatten
    end

  end

end
