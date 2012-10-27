require 'bio'
require 'csv'

module Hippocampome

  class MedlineRecord < Bio::MEDLINE

    ### Providing the data in the form and with method names I like
    
    def initialize
      super
      # add to the mani hash
      @pubmed[:authors] = authors
      @pubmed[:pmid_isbn] = pmid_isbn
      @pubmed[:publication] = publication
      @pubmed[:volume] = volume
      @pubmed[:first_page] = first_page
      @pubmed[:last_page] = last_page
      @pubmed[:title] = title
    end

    def authors
      au.gsub("\n", ", ")
    end

    def pmid_isbn
      pmid
    end

    def publication
      pt
    end

    def volume
      vi
    end

    def first_page
      parse_pages.first
    end

    def last_page
      parse_pages.last
    end

    def parse_pages
      pg =~ /(\d+)-(\d+)/ 
      if $1 and $2
        diff = $1.size - $2.size
        first_page, last_page = $1, $2
        last_page = first_page[0...diff] + last_page if diff > 0  # get full end page
        return first_page, last_page
      else
        return pg
      end
    end

    def export_for_article_csv
      csv_fields = [:authors, :pmid_isbn, :first_page, :last_page, :title, :year, :publication, :volume]
      @fields.select { |field| csv_fields.include?(field) }
    end

  end

end
