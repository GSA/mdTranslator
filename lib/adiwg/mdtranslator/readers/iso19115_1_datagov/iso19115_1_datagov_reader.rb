# frozen_string_literal: true

require 'nokogiri'
require_relative 'version'
require_relative 'modules/module_iso19115_1'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191151datagov
        @@rootXPath = 'gmd:MD_Metadata'
        def self.readFile(file, hResponseObj) # rubocop:disable Naming/MethodName
          # add Iso19115_1 reader version
          hResponseObj[:readerVersionUsed] = ADIWG::Mdtranslator::Readers::Iso191151datagov::VERSION

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

          # file must contain an ISO 19115-1 <gmd:MD_Metadata> tag
          xMetadata = xDoc.xpath(@@rootXPath)
          if xMetadata.nil?
            msg = "ERROR: ISO 19115-1 file did not contain a #{@@rootXPath} tag"
            hResponseObj[:readerValidationMessages] << msg
            hResponseObj[:readerValidationPass] = false
            return {}
          end

          # load Iso19115_1 file into internal object
          Iso191151datagov.unpack(xMetadata, hResponseObj)
        end
      end
    end
  end
end
