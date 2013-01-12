module Hippocampome

  class MorphPropertyPatcher
    # This class iterates over all Types and finds the complement of the
    # set of their positive properties-- i.e. it creates a negative property for
    # each part and parcel for which the type does not have that part in that
    # parcel.  It then associates the Type with those properties.
    #
    # 121109
    # Originally implemented as a patch for the morphology search functionality

    # - 'method' refers to the method name in class Type of models.rb,
    # for retrieving morph properties of a type using Sequel associations
    # - 'subject' refers to the name in the database for this morph part in
    # the subject field of the Property table

    MorphPart = Struct.new(:method, :subject)
    name_pairs = [
      ["axon", "axons"],
      ["dendrite", "dendrites"],
      ["soma", "somata"]
    ]

    @morph_parts = name_pairs.map { |pair| MorphPart.new(*pair) }

    class << self
      attr_accessor :morph_parts
    end

    def patch
      Type.each do |type|
        self.class.morph_parts.each do |morph_part|
          OneTypeMorphPropertyPatcher.new(type, morph_part).patch
        end
      end
    end

  end

end
