module Hippocampome

  class KnownConnectionsRowProcessor

    def initialize(record)
      @record = record
    end

    def process
      connection_status = (@record.fields[:connection_status].to_i == 1 ? 'positive' : 'negative' )
      layers = @record.connection_location.split(/\s*,\s*/)
      record_list = layers.map do |layer|
        values = {
          Type1_id: @record.fields[:Type1_id],
          Type2_id: @record.fields[:Type2_id],
          connection_status: connection_status,
          connection_location: layer,
        }
        CSVPort::Record.new(values)
      end
      record_list
    end

  end
end
