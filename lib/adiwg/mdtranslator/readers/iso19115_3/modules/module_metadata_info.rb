# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_identification'
require_relative 'module_citation'
require_relative 'module_locale'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module MetadataInformation
               @@mdParentXpath = 'mdb:parentMetadata'
               @@mdIdentifier = 'mdb:metadataIdentifier'

               def self.unpack(xMetadata, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hMetadataInfo = intMetadataClass.newMetadataInfo

                  xMetadataInfo = xMetadata.xpath(@@mdIdentifier)

                  # :metadataIdentifier (required)
                  if xMetadataInfo.empty?
                     msg = 'ERROR: ISO19115-3 reader: element \'mcc:MD_Identifier\' is missing in metadata identifier'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionePass] = false

                     return xMetadataInfo
                  end

                  hMetadataInfo[:metadataIdentifier] = Identification.unpack(xMetadataInfo[0], hResponseObj)

                  # :parentMetadata (optional)
                  xMdParent = xMetadata.xpath(@mdParentXpath)
                  if xMdParent.empty?
                     msg = 'WARNING: ISO19115-3 reader: element \'mdb:parentMetadata\' '\
                     'is missing in metadata identifier'
                     hResponseObj[:readerExecutionMessages] << msg
                  end

                  hMetadataInfo[:parentMetadata] = Citation.unpack(xMdParent, hResponseObj)

                  # :defaultMetadataLocale
                  hMetadataInfo[:defaultMetadataLocale] = Locale.unpack(xMetadata, hResponseObj)

                  # :otherMetadataLocales TODO
                  # :metadataContacts TODO
                  # :metadataDates TODO
                  # :metadataLinkages TODO
                  # :metadataConstraints TODO
                  # :metadataMaintenance TODO
                  # :alternateMetadataReferences TODO
                  # :metadataStatus TODO
                  # :extensions TODO

                  hMetadataInfo
               end
            end
         end
      end
   end
end
