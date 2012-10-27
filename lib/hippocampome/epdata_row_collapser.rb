module Hippocampome

  class EpdataRowCollapser

    class << self
      attr_accessor :collapsing_fields
    end
    
    @collapsing_fields = [
      :Vrest,
      :Rin,
      :tm,
      :Vthresh,
      :fast_AHP,
      :AP_ampl,
      :AP_width,
      :max_fr,
      :slow_AHP,
      :sag_ratio,
    ]

    def initialize(records)
      @records = records
      @collapsing_fields = self.class.collapsing_fields
    end

    def process
      @records = (0...@records.length).map do |i|
        if @records[i].rows
          num_rows = @records[i].rows.strip.to_i
          hash = @records[i].fields.select { |field, value| not @collapsing_fields.include?(field) }
          hash.delete(:rows)
          hash[:row_number] = i
          @collapsing_fields.each do |field|
            hash[field] = (i...i+num_rows).map { |x| @records[x].fields[field] }
          end
          CSVPort::Record.new(hash)
        else
          nil
        end
      end
    end

  end

end


