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
      non_epdata = [:type_id, :ref_id, :notes, :row_number]
      @epdata_fields = @record.fields.reject do |field, value|
        non_epdata.include?(field) 
      end
      @epdata_fields.merge!(@epdata_fields) do |field, old_array, new_array|  # filters number of cells
        #binding.pry
        old_array.reject { |cell| cell.nil? or cell.match(/^\s*X_@/) }
      end
    end

    def process
      type_id = Processors.clean_id_number(@record.type_id)
      record_list = @epdata_fields.map do |ep_property_name, array|
        array.map do |statement|
          hash = {
            ep_property_name: ep_property_name,
            type_id: type_id,
            unit: self.class.unit_hash[ep_property_name],
            statement: statement,
          }
          CSVPort::Record.new(hash)
        end
      end
      record_list.flatten
    end

        #statement = process_epdata_field(statement)

        #if not statement
          #return nil
        #else
          #object = (statement == :no_data ? 'unknown' : '[-inf, +inf]')
          #property = create_property(ep_property_name, object)
          #OpenStruct.new(statement.update( {property: property, type_id: @record.unique_id} ))
        #end
      #end
      #records.compact
    #end

    #def process_statement(statement)
      #if statement.nil? or statement.match(/\{[.…]+\}/)
        #return nil
      #elsif statement.include?('$')
        #return :no_data
      #elsif not statement.include?('{')
        #return nil
      #else
        #return EpdataStatementProcessor.new(statement).process(statement)
      #end
    #end

    #def create_property(property_name)
      #{
        #subject: property_name,
        #predicate: 'is between',
        #object: (@unknown ? 'unknown' : '[-inf, +inf]')
      #}
    #end

  end

end
