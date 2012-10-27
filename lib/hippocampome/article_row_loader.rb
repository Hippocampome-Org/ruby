module Hippocampome

  class ArticleRowLoader

    # takes a hash with these fields:
    # authors
    # title
    # year
    # publication
    # type_mapping
    #
    include CSVPort::SequelLoader

    TypeSynonymListPair = Struct.new(:type, :synonyms)

    def initialize(record) 
      @record = record
    end

    def load
      get_article
      get_authors
      load_article
      load_authors  # and link article to authors
      link_article_to_authors
      if @record.type_mapping
        get_type_mapping_models
        load_type_mapping  # load synonyms, link synonyms to types and article
      end
      return @article
    end

    def load_article
      @article = load_model(@article)
    end

    def load_authors
      @authors = @authors.map do |author|
        load_model(author)
      end
    end

    def link_article_to_authors
      @authors.each_with_index do |author, i|
        link(@article, author, author_pos: i)
      end
    end

    def load_type_mapping
      @type_mapping = @type_mapping.map do |pair|
        pair.synonyms.each do |synonym|
          load_model(synonym)
          link(@article, synonym)
          link(synonym, pair.type)
        end
      end
    end

    def get_article
      values = @record.fields.select do |f, v|
        DB[:Article].columns.include?(f)
      end
      @article = Article.new(values)
    end

    def get_authors
      @authors = @record.authors.split(', ').map do |au|
        values = {name: au}
        Author.new(values)
      end
    end

    def get_type_mapping_models
      @type_mapping = @record.type_mapping.map do |statement|
        get_type_mapping_statement_models(statement)
      end
      @type_mapping.reject! { |pair| pair.type.nil? }  # get rid of unmatched types
    end

    def get_type_mapping_statement_models(statement)
      type = Type[statement.type_id]
      synonyms = statement.synonyms.map { |syn| Synonym.new({name: syn}) }
      return TypeSynonymListPair.new(type, synonyms)
    end

  end

end
