module Hippocampome

  class KnownConnectionsRowLoader

    include CSVPort::SequelLoader

    def initialize(record)
      @record = record
    end

    def load
      get_type_type_rel
      load_type_type_rel
    end

    def get_type_type_rel  # this is a direct load
      @type_type_rel = TypeTypeRel.new(@record.fields)
    end

    def load_type_type_rel
      load_model(@type_type_rel)
    end

  end

end
