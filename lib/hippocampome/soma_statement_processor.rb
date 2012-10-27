module Hippocampome

  class SomaStatementProcessor

    class << self
      attr_accessor :official_layers
    end

    @official_layers = [
      'DG:SMo', 'DG:SMi', 'DG:SG', 'DG:H',
      'CA3:SLM', 'CA3:SR', 'CA3:SL', 'CA3:SP', 'CA3:SO',
      'CA2:SLM', 'CA2:SR', 'CA2:SP', 'CA2:SO',
      'CA1:SLM', 'CA1:SR', 'CA1:SP', 'CA1:SO',
      'SUB:SM', 'SUB:SP', 'SUB:PL',
      'EC:I', 'EC:II', 'EC:III', 'EC:IV', 'EC:V', 'EC:VI' 
    ]       

    LayerRefIdListPair = Struct.new(:layer, :ref_id_list)

    def initialize(statement)
      @statement = statement
    end

    def process
      layer_ref_strs = @statement.split(/\s*\/\s*/)
      layer_ref_id_list_pairs = layer_ref_strs.map do |str|
        full_layer_name, ref_ids = parse_layer_ref_str(str)
        layer_abbreviation = convert_full_layer_name(full_layer_name)
        LayerRefIdListPair.new(layer_abbreviation, ref_ids)
      end
    end

    def parse_layer_ref_str(str)
      ref_ids = str.slice!(/\(.*\)/)
      if ref_ids
        ref_ids.delete!('()')
        ref_ids = ref_ids.split(/,\s*/)
        ref_ids.map!{|ref_id| ref_id.to_i}
      else
        ref_ids = []
        en
        full_layer_name = str.strip
        return full_layer_name, ref_ids
      end
    end

    def convert_full_layer_name(full_layer_name)
      match_name = "%s:%s" % [@subregion, full_layer_name]
      if abbrev = HELPER_HASH[:name_mapping][match_name.to_sym]
        return abbrev
      else
        resolve_layer_name(match_name)
      end
    end

    def resolve_layer_name(match_name)
      opts = self.class.official_layers.map.with_index{|e,i| "%d) %s" % [i,e]}
      opts.each_slice(5) do |s|
        s = s.map { |e| e[0...25].ljust(25) }
        puts s.join(' ')
      end
      puts "Trying to match: #{match_name}"
      print 'Choose: '
      choice = STDIN.gets.to_i
      abbrev = SomaStatementMatcher.official_layers[choice]
      HELPER_HASH[:name_mapping][match_name.to_sym] = abbrev
      return abbrev
    end

  end

end

