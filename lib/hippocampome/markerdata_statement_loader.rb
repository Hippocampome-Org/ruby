module Hippocampome

  class MarkerdataStatementLoader

    include CSVPort::SequelLoader

    def initialize(record)
      @record = record
    end

    def load
      get_vet_data
      get_type
      get_properties
      load_properties
      if has_fragment?
        get_fragment
        get_fragment_evidence
        get_markerdata
        get_markerdata_evidence
        load_markerdata
        load_markerdata_evidence
        link_markerdata_to_markerdata_evidence
        link_markerdata_evidence_to_fragment_evidence
        link_markerdata_evidence_to_property_to_type
      else
        link_dummy_evidence_to_property_to_type
      end
    end

    def has_fragment?
      if not Fragment[{original_id: @record.ref_id}]
        CSVPort::InvalidRecordError.new(:type => :missing_fragment_reference, :loaded_anyway => :yes).log
        return false
      else
        return true
      end
    end

    def get_type
      values = {
        id: @record.type_id
      }
      @type = Type.new(values)
    end

    def get_properties
     @properties = @record.expression.map do |expression|
       values = {
        subject: @record.marker,
        predicate: 'has expression',
        object: expression
      }
      Property.new(values)
     end
    end

    def get_fragment
      values = {
        original_id: @record.ref_id
      }
      @fragment = Fragment.new(values)
    end

    def get_fragment_evidence
        @fragment_evidence = match(@fragment).Evidence.first
    end

    def get_markerdata
      values = {
        expression: @record.expression,
        animal: @record.animal,
        protocol: @record.protocol
      }
      @markerdata = Markerdata.new(values)
    end

    def get_markerdata_evidence
      @markerdata_evidence = Evidence.new
    end

    def load_properties
      @properties.map! { |property| load_model(property) }
    end

    def load_markerdata
      load_model(@markerdata)
    end

    def load_markerdata_evidence
      load_model(@markerdata_evidence)
    end

    def link_markerdata_to_markerdata_evidence
      link(@markerdata_evidence, @markerdata)
    end

    def link_markerdata_evidence_to_fragment_evidence
      link(@markerdata_evidence, @fragment_evidence, type: 'interpretation')
    end

    def link_markerdata_evidence_to_property_to_type
      @properties.each do |property|
        link(@markerdata_evidence, property, @type, @vet_data)
      end
    end

    def link_dummy_evidence_to_property_to_type
      #binding.pry if $row == 21
      @properties.each do |property|
        link(DUMMY_EVIDENCE, property, @type, @vet_data)
      end
    end

    #def validate
      #$column = 'type_id'
      #raise HippoDataError.new(:missing_type_reference, type_id: @type_id) if not Type[@type_id]
    #end

    def get_vet_data
      @vet_data = {unvetted: @record.unvetted}
    end

  end

end
