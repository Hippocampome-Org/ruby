module Hippocampome

  class PacketNotesRowLoader

    include CSVPort::SequelLoader

    def initialize(record, opts={})
      @record = record
      @auxilary_data_path = (opts[:auxilary_data_path] or nil)
    end

    def load
      get_note_content
      get_type
      load_type
    end

    def get_note_content
      path = File.expand_path(@record.filename, @auxilary_data_path)
      @note_content = File.read(path)
    end

    def get_type
      values = {
        id: @record.type_id,
        notes: @note_content
      }
      @type = Type.new(values)
    end

    def load_type
      load_model(@type, match_on: :id)
    end

  end

end
