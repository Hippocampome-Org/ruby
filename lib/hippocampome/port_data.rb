# encoding: UTF-8

module Hippocampome

  PORT_DATA = {

    type: {
      id: :type,
      processors: [
        "Hippocampome::TypeRowLoader"
      ],
        field_mapping: {
        'subregion'=>:subregion,
        'full_name'=>:name, 
        'excit_inhib'=>:excit_inhib,
        'short_name'=>:nickname,
        'abbreviation'=>:abbreviation,
        'soma_locs'=>:soma_locs,
        'id'=>:id, 
        'position'=>:position,
        'status'=>:status,
        'p'=>:p,
        'DG'=>:DG,
        'CA3'=>:CA3,
        'CA2'=>:CA2,
        'CA1'=>:CA1,
        'SUB'=>:SUB,
        'EC'=>:EC
      }, 
      required_fields: [:subregion, :name, :id, :status]
    },


    article: {
      id: :article,
      processors: [ 
        "Hippocampome::TypeMappingProcessor",
        "Hippocampome::ArticleRowLoader"
      ],
        field_mapping: {
        'title'=>:title,
        'authors'=>:authors,
        'publication'=>:publication, 
        'volume'=>:volume,
        'issue'=>:issue,
        'pmid_isbn'=>:pmid_isbn,
        'pmcid'=>:pmcid,
        'nihmsid'=>:nihmsid,
        'doi' => :doi,
        'open_access'=>:open_access,
        'first_page'=>:first_page,
        'last_page'=>:last_page, 
        'year'=>:year,
        'type_mapping'=>:type_mapping,
        'packet'=>:packet,
        'citation_count' => :citation_count,
      },
      required_fields: [:title, :authors, :pmid_isbn, :year]
    },


    morph_fragment: {
      id: :morph_fragment,
      processors: [
        "Hippocampome::MorphFragmentRowProcessor",
        "Hippocampome::MorphFragmentRowLoader"
      ],
        field_mapping: {
        "ReferenceID" => :original_id,
        #"CellType" => :cell_type,
        "Material Used" => :quote,
        #:interpretation => :interpretation,
        "Location in reference" => :page_location,
        "PMID/ISBN" => :pmid_isbn,
      },
      required_fields: [
        :original_id,
        :quote,
        :page_location,
        :pmid_isbn
      ],
        tests: [
          {
            name: "fragment id valid",
            field: :original_id,
            test: lambda { @record.original_id.match(/^\d+/) },
            error_data: lambda {
              {
                type: :missing_type_reference,
                value: @record.original_id
              }
            }
          }
      ]
    }, 


    marker_fragment: {
      id: :marker_fragment,
      processors: [
        "Hippocampome::MarkerFragmentRowProcessor",
        "Hippocampome::MarkerFragmentRowLoader"
      ],
        field_mapping: {
        "PMID/ISBN" => :pmid_isbn,
        "Reference ID" => :original_id,
        "Material used" => :data_quote,
        "Location in reference" => :data_page_location,
        "Protocol Reference" => :protocol_quote,
        "Protocol location in reference" => :protocol_page_location,
        "Species Reference" => :species_quote,
        "Species location in reference" => :species_page_location
      },
      required_fields: [
        :original_id,
        :data_quote,
        :data_page_location,
        :pmid_isbn
      ],
      row_transform: 2,
      prepare_headers: lambda {
        @headers = @rows.shift
        @headers[7], @headers[9] = "Protocol location in reference", "Species location in reference"  # change the duplicate field names ("Location in reference")
      },
      tests: [
          {
            name: "fragment id valid",
            field: :original_id,
            test: lambda { @record.original_id.match(/^\d+/) },
            error_data: lambda {
              {
                type: :missing_type_reference,
                value: @record.original_id
              }
            }
          }
      ]
    },


    packet_notes: {
      id: :packet_notes,
      processors: [
        "Hippocampome::PacketNotesRowLoader"
      ],
      field_mapping: {
        "unique ID" => :type_id,
        "Notes file" => :filename
      },
      required_fields: [
        :type_id,
        :filename
      ],
      auxilary_data_path: 'packet_notes'
    },


    figure: {
      id: :figure,
      processors: [
        "Hippocampome::FigureRowLoader"
      ],
        field_mapping: {
        #"Authors" => :authors,
        #"Title" => :title,
        #"Journal/Book" => :publication,
        #"Year" => :year,
        'PMID/ISBN' => :pmid_isbn,
        'Page' => :page,
        'Cell Identifier' => :type_id,
        'Name of file containing figure' => :filename,
        'Quote reference id' => :ref_id,
        'Figure/Table' => :figure_table,
        'Representative?' => :priority
      },
      required_fields: [
        :pmid_isbn,
        :type_id,
        :filename,
        :figure_table
      ],
        tests: [
          {
            name: "type reference integrity",
            field: :type_id,
            test: lambda {
              type_ids = @record.type_id.split(/, /)
              type_ids.map { |type_id| Type[type_id] }.all?
            },
            error_data: lambda {
              {
                type: :missing_type_reference,
                value: @record.type_id
              }
            }
          },
      ]
    },


    markerdata: {
      id: :markerdata,
      processors: [
        "Hippocampome::MarkerdataRowProcessor",
        "Hippocampome::MarkerdataStatementProcessor",
        "Hippocampome::MarkerdataStatementLoader",
      ],
        field_mapping: {
        "Hippocampome 0.8 Cell ID" => 'type_id',
        'CB' => 'CB',
        'CR' => 'CR',
        'CCK' => 'CCK',
        'nNOS' => 'nNOS',
        'NPY' => 'NPY',
        'PV' => 'PV',
        'SOM' => 'SOM',
        'VIP' => 'VIP',
        'CB1' => 'CB1',
        'ENK' => 'ENK',
        'GABAa \alpha' => 'Gaba-a-alpha',
        'Mus2R' => 'Mus2R',
        'sub P rec'  => 'Sub P',
        'vGluT3' => 'vGluT3',
        'CoupTF II' => 'CoupTF II',
        '5HT-3' => '5HT-3',
        'RLN' => 'RLN',
        'a-act2' => 'alpha-actinin-2',
        'ChAT' => 'ChAT',
        'DYN' => 'DYN',
        'EAAT3' => 'EAAT3',
        'GlyT2' => 'GlyT2',
        'mGluR1a' => 'mGluR1a',
        'mGluR7a' => 'mGluR7a',
        'mGluR8a' => 'mGluR8a',
        'MOR' => 'MOR',
        'NKB' => 'NKB',
        'NK1' => 'NK1',
        'PPTA' => 'PPTA',
        'PPTB' => 'PPTB',
        'vAChT' => 'vAChT',
        'VIAAT' => 'VIAAT',
        'vGluT2' => 'vGluT2',
        'AChE' => 'AChE',
        'GAT-1' => 'GAT-1',
        'mGluR2/3' => 'mGluR2/3',
        'CGRP' => 'CGRP',
      },
      required_fields: [
        'type_id'
      ],
      row_transform: 5,
      prepare_headers: lambda {
        @rows = @rows.drop(2)
        marker_header_start_index = 16
        #binding.pry
        headers_part_two = @rows.first[marker_header_start_index..-1]
        @rows = @rows.drop(1)
        headers_part_one = @rows.first[0...marker_header_start_index]
        @headers = headers_part_one + headers_part_two
        @rows = @rows.drop(1)
        #binding.pry
      },
      tests: [
      {
          name: "type reference integrity",
          field: :type_id,
          test: lambda { 
            type_id = Processors.clean_id_number(@record.type_id)
            Type[type_id]
          },
          error_data: lambda {
            {
              type: :missing_type_reference,
              value: @record.type_id
            }
          }
        },
        #{
          #name: "original id format",
          #field: :original_id,
          #test: lambda { @record.original_id.match(/^\d+$/) },
          #error_data: lambda {
            #{
              #type: :badly_formatted_field,
              #value: @record[:original_id]
            #}
          #}
        #},
        #{
          #name: "original id reference integrity",
          #field: :original_id,
          #test: lambda { Fragment[{original_id: @record[:original_id]}] },
          #error_data: lambda {
            #{
              #type: :missing_fragment_reference,
              #bad_reference: @record[:original_id]
            #}
          #}
        #}

      ]

    },


    epdata: {
      id: :epdata,
      collapser: "Hippocampome::EpdataRowCollapser",
      processors: [
        "Hippocampome::EpdataRowProcessor",
        "Hippocampome::EpdataRecordValidator",
        "Hippocampome::EpdataStatementProcessor",
        "Hippocampome::EpdataStatementLoader",
      ],
        field_mapping: {
        "Unique ID (* -EP Suppl)" => :type_id,
        "Rows" => :rows,
        "Vrest (mV)" => :Vrest,
        "Rin (MW)" => :Rin,
        "tm (ms)" => :tm,
        "Vthresh (mV)" => :Vthresh,
        "Fast AHP (mV)" => :fast_AHP,
        "AP ampl (mV)" => :AP_ampl,
        "AP width (ms)" => :AP_width,
        "Max F R (Hz @pA@time)" => :max_fr,
        "Slow AHP {mV@pA@ms}" => :slow_AHP,
        "Sag ratio {@pA}" => :sag_ratio,
        "Linking PMID" => :linking_pmid,
        #"V-I resp" => :VI_resp,
        #"Fr adapt" => :Fr_adapt,
        #"I/V char" => :IV_char,
        #"Ref ID: (citation)" => :ref_id,
        #"Notes" => :notes
      },
      required_fields: [],
      row_transform: 6,
      prepare_headers: lambda {
        @rows = @rows.drop(4)
        @headers = @rows.shift
      },
      tests: [
        {
          name: "type id valid",
          field: :type_id,
          test: lambda { @record.type_id and @record.type_id.match(/\s*\*?\d-?\d+\*?\s*/) },
          error_data: {
            type: :empty_row,
          }
        },
        {
          name: "type reference integrity",
          field: :type_id,
          test: lambda { 
            type_id = Processors.clean_id_number(@record.type_id)
            Type[type_id] },
          error_data: lambda {
            {
              type: :missing_type_reference,
              value: @record.type_id
            }
          }
        },
      ]
    },


    hc_main: {
      id: :hc_main,
      processors: [
        "Hippocampome::HcMainRowProcessor",
        "Hippocampome::HcMainStatementLoader"
      ],
        field_mapping: {
        "unique ID" => :type_id,
        'Neurites \ Layer ID->' => :axon_dendrite,
        "Soma location" => :soma_location,
        "Subregion" => :subregion,
        'DG:SMo' => 'DG:SMo',
        'DG:SMi' => 'DG:SMi',
        'DG:SG' => 'DG:SG',
        'DG:H' => 'DG:H' ,
        'CA3:SLM' => 'CA3:SLM',
        'CA3:SR' => 'CA3:SR',
        'CA3:SL' => 'CA3:SL',
        'CA3:SP' => 'CA3:SP',
        'CA3:SO' => 'CA3:SO',
        'CA2:SLM' => 'CA2:SLM',
        'CA2:SR' => 'CA2:SR',
        'CA2:SP' => 'CA2:SP',
        'CA2:SO' => 'CA2:SO',
        'CA1:SLM' => 'CA1:SLM',
        'CA1:SR' => 'CA1:SR',
        'CA1:SP' => 'CA1:SP',
        'CA1:SO' => 'CA1:SO',
        'SUB:SM' => 'SUB:SM',
        'SUB:SP' => 'SUB:SP',
        'SUB:PL' => 'SUB:PL',
        'EC:I' => 'EC:I',
        'EC:II' => 'EC:II',
        'EC:III' => 'EC:III',
        'EC:IV' => 'EC:IV',
        'EC:V' => 'EC:V',
        'EC:VI' => 'EC:VI' 
      },
      required_fields: [
        :type_id
      ],
      row_transform: 9,
      prepare_headers: lambda {
        subregions = ['DG']*4 + ['CA3']*5 + ['CA2']*4 + ['CA1']*4 + ['SUB']*3 + ['EC']*6
        @rows = @rows.drop(6)
        layers = @rows.first[24..-1]
        headers_part_two = subregions.zip(layers).map { |sub, layer| sub + ':' + layer }
        @rows.shift
        headers_part_one = @rows.first[0..23]
        @rows.shift
        @headers = headers_part_one + headers_part_two
      },
      tests: [
        {
          name: "type reference integrity",
          field: :type_id,
          test: lambda { 
            type_id = Processors.clean_id_number(@record.type_id)
            Type[type_id]
          },
          error_data: lambda {
            {
              type: :missing_type_reference,
              value: @record.type_id
            }
          }
        },
      ]
    },

    marker_evidence_links: {
      id: :marker_evidence_links,
      processors: [
        "Hippocampome::MarkerEvidenceLinkRowProcessor",
        "Hippocampome::MarkerEvidenceLinkStatementProcessor",
        "Hippocampome::MarkerEvidenceLinkLoader",
      ],
        field_mapping: {
        "Reference ID" => :original_id,
        "Notes/Interpretations" => :interpretation,
      },
      required_fields: [
        :original_id,
        :interpretation
      ],
      row_transform: 2,
      prepare_headers: lambda {
        @headers = @rows.shift
        @headers[7], @headers[9] = "Protocol location in reference", "Species location in reference"  # change the duplicate field names ("Location in reference")
      },
      tests: [
          {
            name: "fragment id valid",
            field: :original_id,
            test: lambda { @record.original_id.match(/^\d+/) },
            error_data: lambda {
              {
                type: :missing_fragment_reference,
                value: @record.original_id
              }
            }
          }
      ]
    },

    marker_evidence_links: {
      id: :marker_evidence_links,
      processors: [
        "Hippocampome::MarkerEvidenceLinkRowProcessor",
        "Hippocampome::MarkerEvidenceLinkStatementProcessor",
        "Hippocampome::MarkerEvidenceLinkStatementLoader",
      ],
        field_mapping: {
        "Reference ID" => :original_id,
        "Notes/Interpretations" => :interpretation,
      },
      required_fields: [
        :original_id,
        :interpretation
      ],
      row_transform: 2,
      prepare_headers: lambda {
        @headers = @rows.shift
        @headers[7], @headers[9] = "Protocol location in reference", "Species location in reference"  # change the duplicate field names ("Location in reference")
      },
      tests: [
          {
            name: "fragment id valid",
            field: :original_id,
            test: lambda { @record.original_id.match(/^\d+/) },
            error_data: lambda {
              {
                type: :missing_fragment_reference,
                value: @record.original_id
              }
            }
          }
      ]
    },

    known_connections: {
      id: :known_connections,
      processors: [
        "Hippocampome::KnownConnectionsRowProcessor",
        "Hippocampome::KnownConnectionsRowLoader",
      ],
      field_mapping: {
        "Source class identity" => :Type1_id,
        "Target class identity" => :Type2_id,
        "Target layer" => :connection_location,
        "Connection?" => :connection_status,
      },
      required_fields: [:Type1_id, :Type2_id, :connection_location, :connection_status],
      row_transform: 2,
    }

  }

end
