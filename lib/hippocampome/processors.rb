module Hippocampome

  module Processors

    class << self
      attr_accessor :clean_id_number
      attr_accessor :extract_page_number
    end

    def self.clean_id_number(str)
      str.gsub(/\D/, '').strip
    end

    def self.extract_page_number(str)
      page = str.match(/\d+/)
      page = (page ? page[0] : nil)
      return page
    end

    def self.unvetted?(str)
      str.slice!(/^~/) ? true : false
    end

  end
end
