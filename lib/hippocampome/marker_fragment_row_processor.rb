require '/Users/seanmackesey/Desktop/biblimatch/lib/biblimatch'

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
      if page
        values = {
          pmid_isbn: @pmid_isbn,
          page: page
        }
        @first_page = Biblimatch::Matcher.new(values, :hippocampome, source_database: :hippocampome).match[:first_page]
      else
        @first_page = nil
      end
    rescue Biblimatch::NoMatchError
      raise CSVPort::InvalidRecordError.new(type: :missing_article, pmid_isbn: @pmid_isbn)
    rescue StandardError => e
      binding.pry
    end

  end
end
