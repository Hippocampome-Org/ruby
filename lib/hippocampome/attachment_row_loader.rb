module Hippocampome

  class AttachmentRowLoader

   include CSVPort::SequelLoader

    def initialize(record)
      @record = record
    end

    def load
      get_attachment
      load_attachment
    end

   def get_attachment
      values = {
        cell_id: @record.type_id,
        original_id: @record.ref_id,
        name: @record.filename.gsub(/pdf$/, "jpg"),
        type: @record.figure_table
      }
      @attachment = Attachment.new(values)
      end
    

    def load_attachment
      load_model(@attachment)
    end
    
  end
end

