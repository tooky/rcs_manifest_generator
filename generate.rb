require 'sinatra'
require 'haml'
require 'zipruby'
require 'json'
require 'active_support/core_ext/string'

get "/" do
  haml :upload
end

post "/" do
  zipfile = params['myfile'][:tempfile].path

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

  attachment "manifest.json"
  content_type :json
  manifest.to_json
end
