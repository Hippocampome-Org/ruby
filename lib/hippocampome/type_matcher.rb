require 'set'
require 'highline'

module Hippocampome

  class TypeMatcher

    def initialize(str, original_id, marker)
      @str = str
      @subregion, @name = str.split(':')
      @original_id = original_id
      @marker = marker
    end

    def process
      #binding.pry
      parse_name
      filter_by_subregion
      filter_by_local_ad_pattern
      #binding.pry
      filter_by_evidence_link
      #binding.pry
      match_type
      export
    end

    def parse_name
      @local_ad_pattern, @name = @name.split(' ', 2)
      @local_ad_pattern.delete!('p')  # this is not used consistently
    end

    def filter_by_subregion
      @types = Type.filter(subregion: @subregion).all
    end

    def filter_by_local_ad_pattern
      @types.select! do |type|
        #binding.pry if @local_ad_pattern == "3000"
        local_ad_pattern = type.name.slice(/^\w+.*?([\d]+)/, 1)
        local_ad_pattern == @local_ad_pattern
      end
    end

    def filter_by_evidence_link  # check if cells are in fact linked to this evidence
      @types.select! do |type|
        type.Fragment.map{ |fragment| fragment.original_id }.include?(@original_id.to_i)
      end
    end

    def check_for_remaining_types
      raise CSVPort::InvalidRecordError.new(type: :unmatchable_type, content: @str) if @types.empty?
    end

    def check_if_unmatchable_name
      unmatchable_names = [ 'pp ii', 'bc', 'IS-1', 'Bi-Ivy']
      raise CSVPort::InvalidRecordError.new(type: :unmatchable_type, content: @str) if unmatchable_names.include?(@name)
    end

    def match_type
      if @types.length == 1
        @type = @types.first
      elsif $builder.helper_data_hash[:nickname_mapping].data[@original_id] and $builder.helper_data_hash[:nickname_mapping].data[@original_id][@name]
        @type = Type[$builder.helper_data_hash[:nickname_mapping].data[@original_id][@name]]
      else
        #binding.pry
        check_for_remaining_types
        check_if_unmatchable_name
        select_type
      end
    end

    def select_type
      @type = HighLine.new.choose do |menu|
        menu.choices(*@types)
        menu.choice('')
        menu.prompt = "Match #{@local_ad_pattern} #{@name} for marker #{@marker}"
      end
      raise CSVPort::InvalidRecordError.new(type: :unmatchable_type, content: @str) if (not @type.is_a? Type)
      log_name_mapping
    end

    def log_name_mapping
      $builder.helper_data_hash[:nickname_mapping].data[@original_id] = {} if not $builder.helper_data_hash[:nickname_mapping].data[@original_id]
      $builder.helper_data_hash[:nickname_mapping].data[@original_id][@name] = @type.id
    end

    def export
      @type.id
    end

  end

end
