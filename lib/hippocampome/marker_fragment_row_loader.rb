module Hippocampome

  class MarkerFragmentRowLoader

    include CSVPort::SequelLoader

    def initialize(record)
      @record = record
      @fragment_types = ["data", "protocol", "animal"]
    end

    def load
      get_fragments_and_evidence
      get_article
      load_and_link_fragments_and_evidence  # and link article to evidence
    rescue Sequel::DatabaseError => e
      #binding.pry
      mysql2_exception = e.wrapped_exception
      if mysql2_exception.error_number == 1062  # duplicate primary key error
        raise DuplicateFragmentError.new("Fragment #{fragment.id} already present!", fragment)
      end
    rescue StandardError => e
      binding.pry
    end

    def load_and_link_fragments_and_evidence
      @fragment_types.each do |fragment_type|
        fragment = load_fragment(fragment_type)
        evidence = load_evidence(fragment_type)
        link(evidence, fragment)
        link(@article, evidence)
      end
    rescue => e
      binding.pry
    end

    def load_fragment(fragment_type)
      ivar = "@#{fragment_type}_fragment"
      fragment = instance_variable_get(ivar)
      fragment = load_model(fragment)
      instance_variable_set(ivar,fragment)
    end

    def load_evidence(fragment_type)
      ivar = "@#{fragment_type}_evidence"
      evidence = instance_variable_get(ivar)
      evidence = load_model(evidence)
      instance_variable_set(ivar,evidence)
    end

    def get_fragments_and_evidence
      @fragment_types.each do |fragment_type|
        get_fragment(fragment_type)
        get_evidence(fragment_type)
      end
    end

    def get_fragment(fragment_type)
      values = {
        original_id: @record.original_id,
        quote: @record.fields["#{fragment_type}_quote".to_sym],
        page_location: @record.fields["#{fragment_type}_page_location".to_sym],
        type: fragment_type
      }
      instance_variable_set("@#{fragment_type}_fragment", Fragment.new(values))
    rescue StandardError => e 
      binding.pry
    end

    def get_evidence(fragment_type)
      instance_variable_set("@#{fragment_type}_evidence", Evidence.new)
    end

    def get_article
      values = {
        pmid_isbn: @record.pmid_isbn,
      }
      values[:first_page] = @record.first_page if @record.first_page
      @article = Article.new(values)
    end

  end

end
