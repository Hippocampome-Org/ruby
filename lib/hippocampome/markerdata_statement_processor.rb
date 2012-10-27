module Hippocampome

  class MarkerdataStatementProcessor

    include CSVPort::RecordProcessor

    attr_accessor :str
    attr_accessor :expression
    attr_accessor :protocol
    attr_accessor :animal
    attr_accessor :ref_id

    class << self
      attr_accessor :marker_code
    end

    @marker_code = {
      :first =>  {
        '0' =>  ['unknown'],
        '1' =>  ['positive'],
        '2' =>  ['negative'],
        '3' =>  ['weak_positive'],
        '4' =>  ['positive', 'negative'],
        '5' =>  ['positive', 'negative']
      },
      :second =>  {
        '0' =>  ['immunohistochemistry'],
        '1' =>  ['mRNA'],
        '2' =>  ['immunohistochemistry', 'mRNA'],
        '3' =>  ['unknown'],
        '4' =>  ['promoter_expression_construct'],
        '?' =>  ['unknown'],
      },
      :third =>  {
        '0' =>  ['mouse'],
        '1' =>  ['rat'],
        '2' =>  ['mouse', 'rat'],
        '3' =>  ['unspecified_rodent'],
        '?' =>  ['unknown'],
      }
    }
    
    def initialize(record)
      @record = record
    end

    def process
      unpack_fields
      @unvetted = Processors.unvetted?(@statement)
      validate_string
      @coded_data, @ref_id = @statement.split('.')
      @ref_id = @ref_id.delete('?').to_i
      #validate_ref_id
      resolve_coded_data
      validate_expression_protocol_animal if not @unknown
      export_record
    end

    def validate_string
      tests = [] << @statement.match(/^[\d]+\.\d+\?*$/) 
      tests << (not @statement.empty?)
      raise CSVPort::InvalidRecordError.new(type: :badly_formatted_field, value: @statement) unless tests.all?
    end

    #def validate_ref_id  # this happens at load-time
      #if not (@ref_id == 0 or Fragment[{original_id: @ref_id}])
        #CSVPort::InvalidRecordError.new(:type => :missing_fragment_reference, value: @statement).log
      #end
    #end

    def validate_expression_protocol_animal
      if not [@expression, @protocol, @animal].all?
        raise CSVPort::InvalidRecordError.new(type: :badly_formatted_field, value: @statement)
      end
    end

    def resolve_coded_data
      first, second, third = @coded_data.split('')
      @expression = self.class.marker_code[:first][first]
      if first == '0'
        @unknown = true
      else
        @unknown = false
        @protocol = self.class.marker_code[:second][second]
        @animal = self.class.marker_code[:third][third]
      end
      remove_instance_variable("@coded_data")
    end

  end

end
