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
      clean_all_page_locations
      extract_page_number
      export_record
    end

    def clean_pmid_isbn
      @pmid_isbn = Processors.clean_id_number(@pmid_isbn)
    end

    def clean_all_page_locations
      @data_page_location = clean_page_location(@data_page_location) if @data_page_location
      @animal_page_location = clean_page_location(@animal_page_location) if @animal_page_location
      @protocol_page_location = clean_page_location(@protocol_page_location) if @protocol_page_location
    end

    def clean_page_location(page_location)
      Processors.clean_page_location(page_location)
    end

    def extract_page_number
      #binding.pry
      page = Processors.extract_page_number(@data_page_location)
      if page
        values = {
          pmid_isbn: @pmid_isbn,
          page: page
        }
        @first_page = Biblimatch::Matcher.new(values, :hippocampome, source_database: :hippocampome, output_database: :hippocampome).match[:first_page]
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
