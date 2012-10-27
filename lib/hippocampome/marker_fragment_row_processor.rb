module Hippocampome

  class MarkerFragmentRowProcessor

    include CSVPort::RecordProcessor

    def initialize(record)
      @record = record
    end

    def process
      unpack_fields
      clean_pmid_isbn
      extract_page_number
      export_record
    end

    def clean_pmid_isbn
      @pmid_isbn = Processors.clean_id_number(@pmid_isbn)
    end

    def extract_page_number
      #binding.pry
      page = Processors.extract_page_number(@data_page_location)
      @first_page = (page.nil? ? nil: ArticleMatcher.new(@pmid_isbn, page).match.first_page)
    end

  end
end
