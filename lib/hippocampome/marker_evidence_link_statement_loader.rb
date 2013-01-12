module Hippocampome

  class MarkerEvidenceLinkStatementLoader

    include CSVPort::SequelLoader

    def initialize(record)
      @record = record
    end

    def load
      #binding.pry
      get_type
      get_fragment
      get_evidence
      get_article
      update_eptr_records if @evidence
    end

    def get_type
      @type = Type[@record.type_id]
    end

    def get_fragment
      @fragment = Fragment[original_id: @record.original_id, type: 'data']
      raise CSVPort::InvalidRecordError.new(type: :missing_fragment_error) if @fragment.nil?
    end

    def get_evidence
      fragment_evidence = @fragment.Evidence.first
      @evidence = fragment_evidence.UpperEvidence.first  # markerdata evidence
    end


    def get_article
      @article = Article[pmid_isbn: @record.pmid_isbn]
    end

    # Note that this dose not distinguish Property.  It assumes that all links that use same Evidence and same Type have same linking Article.  Not ideal, temp hack
    def update_eptr_records  # EvidencePropertyTypeRel
      ds = EvidencePropertyTypeRel.where(Type_id: @type.id, Evidence: @evidence)
      #binding.pry
      ds.update(Article_id: @article.id)
    rescue StandardError => e
      binding.pry
    end

  end

end
