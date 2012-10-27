module Hippocampome

  class MorphFragmentRowLoader

    include CSVPort::SequelLoader

    def initialize(record)
      @record = record
    end

    def load
      get_fragment
      get_article
      get_evidence
      load_fragment
      load_evidence
      link_evidence_to_fragment
      link_article_to_evidence
    rescue Sequel::DatabaseError => e
      #binding.pry
      mysql2_exception = e.wrapped_exception
      if mysql2_exception.error_number == 1062  # duplicate primary key error
        raise DuplicateFragmentError.new("Fragment #{fragment.id} already present!", fragment)
      end
    end

    def load_fragment
      @fragment = load_model(@fragment)
    end

    def load_evidence
      @evidence = load_model(@evidence)
    end

    def link_evidence_to_fragment
      link(@evidence, @fragment)
    end

    def link_article_to_evidence
      link(@article, @evidence)
      #binding.pry
    end

    def get_fragment
      values = @record.fields.select do |f,v|
        Fragment.columns.include?(f)
      end
      values[:type] = 'data'
      @fragment = Fragment.new(values)
    end

    def get_article
      values = {
        pmid_isbn: @record.pmid_isbn,
      }
      values[:first_page] = @record.first_page if @record.first_page
      @article = Article.new(values)
    end

    def get_evidence
      @evidence = Evidence.new
    end

  end

end
