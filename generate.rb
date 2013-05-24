require 'zipruby'
require 'pp'
require 'json'
require 'active_support/core_ext/string'

zipfile = "/Users/steve/Box Documents/Methods Stethoscope/RCS_Dashboard_Data_Files.zip"

manifest = {}

Zip::Archive.open(zipfile) do |ar|
  ar.each do |f|
    next unless f.name =~ /\.txt$/
    path_elems = f.name.split('/')
    name_elems = path_elems.last.gsub(/\.txt$/, '').split('_')

    ccg = name_elems[0].gsub("+"," ").titleize
    ccg.gsub!("Nhs","NHS")
    ccg.gsub!("Ccg","CCG")

    report_type = path_elems[0]

    report_name = name_elems[1].gsub("+"," ").titleize
    report_name.gsub!("Ent","ENT")

    manifest[ccg] ||= {}
    manifest[ccg][report_type] ||= {}
    manifest[ccg][report_type][report_name] = f.name
  end
end

puts manifest.to_json
