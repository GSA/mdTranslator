# frozen_string_literal: true

require 'nokogiri'
require_relative 'version'
require_relative 'modules/module_iso19115_3'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            CODELISTVALUE = 'codeListValue'
            def self.readFile(file, hResponseObj) # rubocop:disable Naming/MethodName
               # add Iso19115_3 reader version
               hResponseObj[:readerVersionUsed] = ADIWG::Mdtranslator::Readers::Iso191153::VERSION

               # receive XML file
               if file.nil? || file == ''
                  hResponseObj[:readerStructureMessages] << 'ERROR: XML file is missing'
                  hResponseObj[:readerStructurePass] = false
                  return {}
               end

               # file must be well formed XML
               begin
                  xDoc = Nokogiri::XML(file, &:strict)
               rescue Nokogiri::XML::SyntaxError => e
                  hResponseObj[:readerStructureMessages] << 'ERROR: XML file is not well formed'
                  hResponseObj[:readerStructureMessages] << e.to_s
                  hResponseObj[:readerStructurePass] = false
                  return {}
               end

               # file must contain an ISO 19115-3 <mdb:MD_Metadata> tag
               xMetadata = xDoc.xpath('mdb:MD_Metadata')
               if xMetadata.empty?
                  msg = 'ERROR: ISO 19115-3 file did not contain a <mdb:MD_Metadata> tag'
                  hResponseObj[:readerValidationMessages] << msg
                  hResponseObj[:readerValidationPass] = false
                  return {}
               end

               # load Iso19115_3 file into internal object
               Iso191153.unpack(xMetadata[0], hResponseObj)
            end
         end
      end
   end
end
