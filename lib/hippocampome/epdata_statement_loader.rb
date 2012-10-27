module Hippocampome

  class EpdataStatementLoader

    include CSVPort::SequelLoader

    def initialize(record)
      @record = record
    end

    def load
      get_vet_data
      get_property
      load_property
      get_type
      if not @record.unknown
        get_article
        get_fragment
        get_fragment_evidence
        get_epdata
        get_epdata_evidence
        load_fragment
        load_fragment_evidence
        link_fragment_to_fragment_evidence
        link_article_to_fragment_evidence
        load_epdata
        load_epdata_evidence
        link_epdata_to_epdata_evidence
        link_epdata_evidence_to_fragment_evidence
        link_epdata_evidence_to_property_to_type
      else
        link_dummy_evidence_to_property_to_type
      end
    end

    def get_fragment
      values = {
        quote: @record.table_figure_quote
      }
      matching_fragment = FragmentMatcher.new(@record.pmid_isbn, values, return_model: true).match
      if matching_fragment
        @fragment = matching_fragment
      else
        @fragment = Fragment.new(values)
      end
    end

    def get_fragment_evidence
      evidence = @fragment.Evidence
      @fragment_evidence = (evidence.any? ? evidence.first : Evidence.new)
    end

    def get_epdata
      values = {
        raw: @record.raw,
        value1: @record.value1,
        value2: @record.value2,
        error: @record.error,
        std_sem: @record.std_sem,
        n: @record.n,
        istim: @record.istim,
        time: @record.time
      }
      @epdata = Epdata.new(values)
    end

    def get_epdata_evidence
      @epdata_evidence = Evidence.new
    end

    def load_fragment
      @fragment = load_model(@fragment)
    end

    def load_fragment_evidence
      @fragment_evidence = load_model(@fragment_evidence)
    end

    def link_fragment_to_fragment_evidence
      link(@fragment_evidence, @fragment)
    end
    
    def link_article_to_fragment_evidence
      link(@article, @fragment_evidence)
    end

    def load_epdata
      @epdata = load_model(@epdata)
    end

    def load_epdata_evidence
      @epdata_evidence = load_model(@epdata_evidence)
    end

    def link_epdata_to_epdata_evidence
      link(@epdata, @epdata_evidence)
    end

    def link_epdata_evidence_to_fragment_evidence
      link(@epdata_evidence, @fragment_evidence, type: 'interpretation')
    end

    def get_article
      values = {
        pmid_isbn: @record.pmid_isbn
      }
      @article = Article.new(values)
    end

    def get_type
      values = {
        id: @record.type_id
      }
      @type = Type.new(values)
    end

    def get_property
      @property = Property.new(@record.property)
    end

    def load_property
      load_model(@property)
    end

    def link_dummy_evidence_to_property_to_type
      link(DUMMY_EVIDENCE, @property, @type, @vet_data)
    end

    def link_epdata_evidence_to_property_to_type
      link(@epdata_evidence, @property, @type, @vet_data)
    end

    def get_vet_data
      @vet_data = {unvetted: @record.unvetted}
    end

  end

end
