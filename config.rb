
require 'csv_port'
require 'json'
#require 'pry'

DB_NAME = "hippocampome"
DB_USERNAME = "root"
DB_PASSWORD = "orgslice"
DB_ENCODING = "utf8"

PORTING_LIBRARY = {
  filename: "hippocampome",
  module_name: "Hippocampome"
}

SOURCE_DATA = [
  #{
    #filename: 'type.csv',
    #target: :type,
  #},
  #{
    #filename: 'article.csv',
    #target: :article
  #},
  #{
    #filename: 'morph_fragment.csv',
    #target: :morph_fragment
  #}, 
  #{
    #filename: 'marker_fragment.csv',
    #target: :marker_fragment
  #},
  #{
    #filename: 'packet_notes.csv',
    #target: :packet_notes
  #},
  #{
    #filename: 'figure.csv',
    #target: :figure
  #},
  #{
    #filename: 'markerdata.csv',
    #target: :markerdata
  #},
  {
    filename: 'epdata.csv',
    target: :epdata
  },
  #{
    #filename: 'hc_main.csv',
    #target: :hc_main
  #},
]

HELPER_DATA = [
  'name_mapping.json', 'nickname_mapping.json', 'skip_table.json'
]

ERROR_DATA = [
  'error_log.json'
]

DATA_DIRECTORY = File.expand_path("../data", "__FILE__")
EXTERNAL_SOURCE_DATA_DIRECTORY = "/Users/seanmackesey/google_drive/hc/data"
SOURCE_DATA_DIRECTORY = File.expand_path('source', DATA_DIRECTORY)
HELPER_DATA_DIRECTORY = File.expand_path('helper', DATA_DIRECTORY)
ERROR_DATA_DIRECTORY = DATA_DIRECTORY
