require 'sinatra'
require 'adiwg-mdtranslator'
require 'json'

get '/' do
  erb :index
end

get '/simple_output' do
  input_file = File.read('data/mytest_fgdc.xml')
  metadata = ADIWG::Mdtranslator.translate(file: input_file, reader: 'fgdc', writer: 'mdJson')
  output_file = JSON.pretty_generate(JSON.parse(metadata[:writerOutput]))
  "<pre>#{output_file}</pre>"
end

post '/process_file' do
  file = params[:file][:tempfile]
  results = process_file(file)
  content_type :json
  results.to_json
end

def process_file(input_file)
  metadata = ADIWG::Mdtranslator.translate(file: input_file, reader: 'fgdc', writer: 'mdJson')
  output_file = JSON.parse(metadata[:writerOutput])
end