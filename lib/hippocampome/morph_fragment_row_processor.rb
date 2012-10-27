module Hippocampome

  class MorphFragmentRowProcessor

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
      page = Processors.extract_page_number(@page_location)
      @first_page = (page == "unspecified" ? ArticleMatcher.new(@pmid_isbn, page).match.first_page : nil)
    end

  end
end
