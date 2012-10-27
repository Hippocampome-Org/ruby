module Hippocampome

  class HcMainRowLoader

    include CSVPort::SequelLoader

    PropertyEvidenceListPair = Struct.new(:property, :evidence_list)

    def initialize(record)
      @record = record
    end

    def load
      get_type
      get_properties_with_evidence
      @properties_with_evidence.each do |pair|
        load_property_with_evidence(pair)
      end
    end

    def load_property_with_evidence
      property = load_model(pair.property)
      evidence_list = pair.evidence_list.each do |evidence|
        link(evidence, property, @type)
      end
    end

    def get_type
      values = {
        id: @record.type_id
      }
      @type = Type.new(values)
    end

    def get_properties_with_evidence
      @record.property_ref_id_list.map do |pair|
        property = get_property(pair.property)
        evidence_list = ref_id_list.map do |ref_id|
          get_evidence(ref_id)
        end
        @properties_with_evidence = PropertyEvidenceList.new(property, evidence_list)
      end
    end

    def get_property(property_values)
      property = Property.new(property_values)
    end

    def get_evidence(ref_id)
      fragment = get_fragment
      fragment = match(fragment)
      evidence = fragment.evidence.first  # all fragments have an associated evidence
    end

    def get_fragment(ref_id)
      values = {
        original_id: ref_id
      }
      fragment = Fragment.new(values)
    end

  end

end
