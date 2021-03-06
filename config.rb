require 'csv_port'
require 'json'
require 'pry'

DB_NAME = "hippocampome"
DB_USERNAME = "hdb"
DB_PASSWORD = ""
DB_ENCODING = "utf8"

PORTING_LIBRARY = {
  filename: "hippocampome",
  module_name: "Hippocampome"
}

SOURCE_DATA = [
  {
    filename: 'type.csv',
    target: :type,
  },
  {
    filename: 'article.csv',
    target: :article
  },
{
   filename: 'morph_fragment.csv',
   target: :morph_fragment
 },
 {
   filename: 'marker_fragment.csv',
   target: :marker_fragment
 },
 {
   filename: 'packet_notes.csv',
   target: :packet_notes
 },
  {
   filename: 'attachment_morph.csv',
   target: :figure
 },
  {
   filename: 'attachment_morph.csv',
   target: :attachment_morph
 },
   {
   filename: 'attachment_marker.csv',
   target: :attachment_marker
 },
   {
   filename: 'attachment_ephys.csv',
   target: :attachment_ephys
 },
 {
   filename: 'markerdata.csv',
   target: :markerdata
 },
  {
    filename: 'epdata.csv',
    target: :epdata
  },
  {
    filename: 'hc_main.csv',
    target: :hc_main
  },
  {
   filename: 'marker_fragment.csv',
   target: :marker_evidence_links
 },
 {
   filename: 'known_connections.csv',
   target: :known_connections
 },
]

HELPER_DATA = [
  'name_mapping.json', 'nickname_mapping.json', 'skip_table.json'
]

ERROR_DATA = [
  'error_log.json'
]

DATA_DIRECTORY = File.expand_path("../data", "__FILE__")
EXTERNAL_SOURCE_DATA_DIRECTORY = "/Users/djh/wd/portal/dat/csv"
SOURCE_DATA_DIRECTORY = File.expand_path('source', DATA_DIRECTORY)
HELPER_DATA_DIRECTORY = File.expand_path('helper', DATA_DIRECTORY)
ERROR_DATA_DIRECTORY = DATA_DIRECTORY
HIPPOCAMPOME_DIRECTORY = File.expand_path('..', __FILE__)
