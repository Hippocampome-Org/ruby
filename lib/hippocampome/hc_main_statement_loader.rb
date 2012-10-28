module Hippocampome

  class HcMainStatementLoader

    include CSVPort::SequelLoader

    def initialize(record)
      @record = record
    end

    def load
      get_vet_data
      get_type
      get_property
      get_fragment
      get_evidence
      load_property
      link_evidence_to_property_to_type
    end

    def get_property
      values = {
        subject: @record.axon_dendrite_soma,
        predicate: (@record.pos_neg == 'positive' ? 'in' : 'not in'),
        object: @record.parcel
      }
      @property = Property.new(values)
    end

    def get_type
      values = {
        id: @record.type_id
      }
      @type = Type.new(values)
    end

    def get_evidence
      fragment = match(@fragment)
      raise CSVPort::InvalidRecordError.new(:type => :missing_fragment_reference, value: @record.original_id) if not fragment
      @evidence = fragment.Evidence.first  # all fragments have an associated evidence
    end

    def get_fragment
      values = {
        original_id: @record.original_id
      }
      @fragment = Fragment.new(values)
    end

    def load_property
      @property = load_model(@property)
    end

    def link_evidence_to_property_to_type
      link(@evidence, @property, @type, @vet_data)
    end

    def get_vet_data
      @vet_data = {unvetted: @record.unvetted}
    end

  end
end
