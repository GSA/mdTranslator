require 'nokogiri'
require_relative 'version'
require_relative 'modules/module_iso19115_3'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso19115_3

            def self.readFile(file, hResponseObj)

               # add ISO 19115_3 reader version
               hResponseObj[:readerVersionUsed] = ADIWG::Mdtranslator::Readers::Iso19115_3::VERSION

               # receive XML file
               if file.nil? || file == ''
                  hResponseObj[:readerStructureMessages] << 'ERROR: XML file is missing'
                  hResponseObj[:readerStructurePass] = false
                  return {}
               end

               # file must be well formed XML
               begin
                  xDoc = Nokogiri::XML(file) { |form| form.strict }
               rescue Nokogiri::XML::SyntaxError => err
                  hResponseObj[:readerStructureMessages] << 'ERROR: XML file is not well formed'
                  hResponseObj[:readerStructureMessages] << err.to_s
                  hResponseObj[:readerStructurePass] = false
                  return {}
               end

               return Iso19115_3.unpack(xDoc, hResponseObj)
               
            end
         end
      end
   end
end