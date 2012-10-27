module Hippocampome

  class HcMainRowProcessor

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

    def initialize(record)
      @record = record
      misc_fields = [:type_id, :axon_dendrite, :soma_location, :subregion]
      @axon_dendrite_fields = record.reject { |field, value| misc_fields.include?(field) or value.nil? }
    end

    def process
      @type_id = Processors.clean_id_number(@record.type_id)
      record_list = @axon_dendrite_fields.map do |parcel, ref_id_list|
        unvetted = Processors.unvetted?(ref_id_list)
        ref_id_list = ref_id_list.delete('"').strip
        pos_neg = (ref_id_list[0] == '-' ? 'negative' : 'positive')
        ref_id_list.delete!('-')
        ref_id_list.gsub!('.', ',')  # temporary hack
        ref_id_list = ref_id_list.split(/\s*,\s*/)
        records = ref_id_list.map do |ref_id|
          hash = {
            unvetted: unvetted,
            pos_neg: pos_neg,
            parcel: parcel,
            axon_dendrite_soma: @record.axon_dendrite,
            type_id: @type_id,
            original_id: ref_id
          }
          CSVPort::Record.new(hash)
        end
      end
      record_list += process_soma_location if @record.soma_location
      record_list.flatten
    end

    #def initialize(record)
    #misc_fields = [:type_id, :axon_dendrite, :soma_location, :subregion]
    #@record = record
    #@axon_dendrite_fields = record.reject { |field, value| misc_fields.include?(field) }
    #@axon_dendrite = record.axon_dendrite
    #@soma_location = record.soma_location
    #end

    #def process
    #process_axon_dendrite_fields
    #process_soma_location
    #@morph_fields = @axon_dendrite_fields + @soma_location
    #end

    #def process_axon_dendrite_fields
    #@axon_dendrite_fields.reject!{ |k,v| v.nil? }
    #@axon_dendrite_fields.map! do |parcel, ref_ids|
    #ref_id_list = ref_ids.split(/,\s*/)
    #predicate = (ref_id_list.first.include?('-') ? 'not in' : 'in')
    #ad_property = get_property(parcel, predicate, @axon_dendrite)
    #PropertyRefIdListPair.new(ad_property, ref_id_list)
    #end
    #end

    def process_soma_location
      unvetted = Processors.unvetted?(@record.soma_location)
      layer_ref_strs = @record.soma_location.split(/\s*\/\s*/)
      layer_ref_id_list_pairs = layer_ref_strs.map do |str|
        full_layer_name, ref_id_list = parse_layer_ref_str(str)
        parcel = convert_full_layer_name(full_layer_name)
        records = ref_id_list.map do |ref_id|
          hash = {
            unvetted: unvetted,
            pos_neg: 'positive',
              parcel: parcel,
              axon_dendrite_soma: 'somata',
              type_id: @type_id,
              original_id: ref_id
          }
          CSVPort::Record.new(hash)
        end
      end
    end

    #def get_property_ref_id_list
    #list = @morph_fields.map do |parcel, ref_id_list|
    ##$column = parcel
    #property = get_ad_property(parcel, predicate)
    #{property: property, ref_id_list: ref_id_list}
    #end
    #end

    #def get_property(parcel, predicate, subject)
    #values = {
    #subject: @row.axon_dendrite,
    #predicate: predicate,
    #object: parcel
    #}
    #end

    def parse_layer_ref_str(str)
      ref_ids = str.slice!(/\(.*\)/)
      if ref_ids
        ref_ids.delete!('()')
        ref_ids = ref_ids.split(/,\s*/)
        ref_ids.map!{|ref_id| ref_id.to_i}
      else
        ref_ids = []
      end
      full_layer_name = str.strip
      return full_layer_name, ref_ids
    end

    def convert_full_layer_name(full_layer_name)
      #binding.pry
      match_name = "%s:%s" % [@record.subregion, full_layer_name]
      if abbrev = $builder.helper_data_hash[:name_mapping].data[match_name]
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
      $builder.helper_data_hash[:name_mapping].data[match_name] = abbrev
      return abbrev
    end

  end

end
