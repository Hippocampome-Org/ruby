require 'readline'

module Hippocampome

  class ArticleMatcher

    def initialize(pmid_isbn, page=nil)
      @pmid_isbn = pmid_isbn
      @page = page
    end

    def match
      if @pmid_isbn.to_s.length >= 13  # is an ISBN
        article = match_chapter
        # if the article could not be matched to a chapter, match it to the whole book (this is the entry with nil for first_page)
        article = Article.filter(pmid_isbn: @pmid_isbn, first_page: nil).first if not article
        #article = fetch_from_google_books if not article
      else
        article = Article.first(pmid_isbn: @pmid_isbn)
        raise CSVPort::InvalidRecordError.new(type: :missing_article_error, pmid_isbn: @pmid_isbn) if not article
      end
      article
    end

    def match_chapter
      chapters = Article.filter(pmid_isbn: @pmid_isbn).all.reject{ |article| article.first_page == nil }  # ignore the whole book entry
      chapters.sort!{|c| c[:first_page]}
      chapters.each do |c|
        return c if @page.to_i > c[:first_page]  # correct chapter will be the first one with a lower start page
      end
      return nil
    end

    def fetch_from_pubmed
      medline_record = PubmedFetcher.new(@article.values).fetch
      #binding.pry
      #article = update_article_data(medline_record)
    end


    def fetch_from_google_books
    end

    def create_article_from_google_books_record
    end

    def update_article_data(medline_record)
      article_row = medline_record.to_article_csv_row
      choice = Readline.readline("Update article csv and database (y/n)? ")
      if choice == 'y'
        medline_record.add_to_article_csv
        article = ArticleCSVRowMatcher.new(article_row).load
      end
      return article
    end

    #def create_article_from_medline_record(medline_record)
      #values = {}
      #Article.columns.each do |c|
        #ivar = "@#{c}"
        #if medline_record.instance_variable_defined?(ivar)
          #values[c] = medline_record.instance_variable_get(ivar)
        #end
        #values[:pmid_isbn] = medline_record.pmid
      #end
      #Article.new(values)
    #end



  end

end
