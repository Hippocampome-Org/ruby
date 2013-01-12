module Hippocampome

  class OneTypeMorphPropertyPatcher

    include CSVPort::SequelLoader

    def initialize(type, morph_part)
      @type = type
      @morph_part = morph_part
    end

    def patch
      get_parcels
      get_pos_parcels
      get_neg_parcels
      get_pos_subregions
      get_neg_subregions
      patch_pos_subregions
      patch_neg_parcels
      patch_neg_subregions
    end

    def get_parcels
      morph_property_predicates = ['in', 'not in']
      properties = Property.filter(predicate: morph_property_predicates).all
      objects = properties.map { |property| property.object }.uniq
      @parcels = objects.select { |o| o.include?(':') }  # take only the parcels
    end

    def get_pos_parcels
      method_str = @morph_part.method + '_properties'
      pos_properties = @type.send(method_str)
      objects = pos_properties.map { |p| p.object }
      @pos_parcels = objects.select{ |o| o.include?(':') }
    end

    def get_neg_parcels
      @neg_parcels = @parcels - @pos_parcels
    end

    def get_pos_subregions
       subregions = @pos_parcels.map { |p| p.split(':').first }
       @pos_subregions = subregions.uniq
       @pos_subregions << 'hippocampal formation' if @pos_subregions.any?
    end

    def get_neg_subregions
      @neg_subregions = ['DG', 'CA3', 'CA2', 'CA1', 'SUB', 'EC', 'hippocampal formation'] - @pos_subregions
    end

    def patch_pos_subregions
      properties = @pos_subregions.map { |sub| create_property('in', sub) }
      properties.each { |p| load_property(p) }
    end
      
    def patch_neg_parcels
      properties = @neg_parcels.map { |parcel| create_property('not in', parcel) }
      properties.each { |p| load_property(p) }
    end

    def patch_neg_subregions
      properties = @neg_subregions.map { |sub| create_property('not in', sub) }
      properties.each { |p| load_property(p) }
    end

    def create_property(predicate, object)
      values = {
        subject: @morph_part.subject,
        predicate: predicate,
        object: object
      }
      Property.new(values)
    end

    def load_property(property)
      load_model(property)
      link(DUMMY_EVIDENCE, property, @type)
    end

  end

end
