module Hippocampome

  module Processors

    #class << self
      #attr_accessor :clean_id_number
      #attr_accessor :extract_page_number
    #end

    def self.clean_id_number(str)
      str.gsub(/\D/, '').strip.to_i
    end

    def self.extract_page_number(str)
      page = str.match(/\d+/)
      page = (page ? page[0] : nil)
      return page
    end

    def self.unvetted?(str)
      str.slice!(/^~/) ? true : false
    end

    def self.clean_page_location(str)
      str = str.gsub(/\bbot\b/, "bottom")
      str = str.gsub(/\bbotto\b/, "bottom")
      str = str.gsub(/\bmid\b/, "middle")
      str = str.gsub(/\bpg?\b/, 'page')
      str.gsub(/\bpg?\b/, 'page')
    end

  end

end
