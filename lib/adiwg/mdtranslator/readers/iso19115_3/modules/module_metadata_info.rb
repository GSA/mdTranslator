# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_identification'
require_relative 'module_citation'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module MetadataInformation
               def self.unpack(xMetadata, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hMetadataInfo = intMetadataClass.newMetadataInfo

                  # :metadataIdentifier
                  hMetadataInfo[:metadataIdentifier] = Identification.unpack(xMetadata, hResponseObj)

                  # :parentMetadata
                  hMetadataInfo[:parentMetadata] = Citation.unpack(xMetadata, hResponseObj)

                  # :defaultMetadataLocale TODO
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
