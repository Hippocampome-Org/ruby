module Hippocampome

  class EpdataRowProcessor

    include CSVPort::RecordProcessor

    class << self
      attr_accessor :unit_hash
    end

    @unit_hash = {
      Vrest: 'mV',
      Rin: 'mOm',
      tm: 'ms',
      Vthresh: 'mV',
      fast_AHP: 'mV',
      AP_ampl: 'mV',
      AP_width: 'ms',
      max_fr: 'Hz',
      slow_AHP: 'mV',
      sag_ratio: ''
    }

    EpPropertyStatementTypeTriple = Struct.new(:ep_property, :statement, :type)

    def initialize(record)
      @record = record
      non_epdata = [:type_id, :ref_id, :notes, :row_number, :linking_pmid]
      @epdata_fields = @record.fields.reject do |field, value|
        non_epdata.include?(field) 
      end
      @epdata_fields.merge!(@epdata_fields) do |field, old_array, new_array|  # filters number of cells
        #binding.pry
        old_array.reject { |cell| cell.nil? or cell.match(/^\s*X_@/) }
      end
    end

    def process
      @type_id = Processors.clean_id_number(@record.type_id)
      record_list = @epdata_fields.map do |ep_property_name, statement_list|
        if unknown?(statement_list)  # all unknowns
          [] << create_statement_record(ep_property_name, "$UNKNOWN")  # replace with unknown code
        else
          statement_list.reject! { |statement| not_found?(statement) }
          statement_list.map { |statement| create_statement_record(ep_property_name, statement) }
        end
      end
      record_list.flatten
    end

    def unknown?(statement_list)  # only if all statements are not found
      not_found_tests = statement_list.map { |sl| not_found?(sl) }
      not_found_tests.all? ? true : false
    end

    def not_found?(statement)
      statement.match(/^\s*\$/) ? true : false
    end

    def create_statement_record(ep_property_name, statement)
      values = {
        ep_property_name: ep_property_name,
        type_id: @type_id,
        linking_pmid: @record.fields[:linking_pmid],
        unit: self.class.unit_hash[ep_property_name],
        statement: statement,
      }
      CSVPort::Record.new(values)
    end

  end

end
