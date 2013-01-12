module Hippocampome

  class TypeRowLoader

    include CSVPort::SequelLoader

    def initialize(record)
      @record = record
    end

    def load
      get_type
      load_type
    end

    def load_type
      load_model(@type)
    end

    def get_type
      values = @record.fields.select do |f,v|
        DB[:Type].columns.include?(f)
      end
      values[:subregion] = get_subregion
      @type = Type.new(values)
    end

    def get_subregion
      subregion = @record.name.match(/^\w+/)[0]
      subregion.gsub(/LEC|MEC/, 'EC')
    end

  end

end
