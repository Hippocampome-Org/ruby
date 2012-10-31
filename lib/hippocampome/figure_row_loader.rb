module Hippocampome

  class FigureRowLoader

    include CSVPort::SequelLoader

    def initialize(record)
      @record = record
    end

    def load
      get_fragments
      get_types
      load_fragments
      get_evidence  # can only be done after loading fragment
      load_evidence
      link_evidence_to_fragments
      link_fragments_to_types
    end

    def load_fragments
      @fragments.map! { |fragment| load_model(fragment, :match_on => [:original_id]) }
    end

    def link_fragments_to_types
      priority = @record.priority
      @fragments.each do |fragment|
        @types.each do |type|
          link(fragment, type, priority: priority)  # there are the same number of evidence and fragments
        end
      end
    end

    def load_evidence
      @evidence.map! { |evidence| load_model(evidence) }
    end

    def link_evidence_to_fragments
      (0...@evidence.length).each do |i|
        link(@evidence[i], @fragments[i])  # there are the same number of evidence and fragments
      end
    end

    def get_fragments
      common_values = {
        attachment: @record.filename.gsub(/pdf$/, "jpg"),
        attachment_type: @record.figure_table
      }
      if @record.ref_id
        fragments_values = @record.ref_id.split(/,\s*/).map do |ref_id|
          values = {original_id: ref_id}.merge(common_values)
        end
      else
        fragments_values = [common_values]
      end
      @fragments = fragments_values.map{ |values| Fragment.new(values) }
    end

    def get_evidence
      @evidence = @fragments.map do |fragment|
        evidence = fragment.Evidence
        evidence =  (evidence.any? ? evidence.first : Evidence.new)
      end
    end

    def get_types
      ids = @record.type_id.split(/,\s*/)
      @types = ids.map do |id|
        values = {
          id: id
        }
        type = Type.new(values)
      end
    end

  end

end
