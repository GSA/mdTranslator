# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_resource_info'
require_relative 'module_metadata_info'
require_relative 'module_distribution'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Metadata
               @@distributionInfoXPath = 'mdb:distributionInfo'
               def self.unpack(xMetadata, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  intMetadata = intMetadataClass.newMetadata

                  # :metadataInfo TODO
                  intMetadata[:metadataInfo] = MetadataInformation.unpack(xMetadata, hResponseObj)
                  # intMetadata[:metadataInfo][:metadataMaintenance] = {}
                  # intMetadata[:metadataInfo][:metadataMaintenance][:frequency] = 'hourly'
                  # intMetadata[:metadataInfo][:metadataIdentifier] = {}
                  # intMetadata[:metadataInfo][:metadataIdentifier][:identifier] = nil

                  # :resourceInfo TODO

                  intMetadata[:resourceInfo] = ResourceInformation.unpack(xMetadata, hResponseObj)

                  # intMetadata[:resourceInfo] = {:citation => {}, :pointOfContacts => {}}
                  # intMetadata[:resourceInfo][:citation][:dates] = []
                  # intMetadata[:resourceInfo][:pointOfContacts] = [{'parties':[{'contactId': 'test'}]}]
                  # intMetadata[:resourceInfo][:citation][:identifiers] = {}
                  # intMetadata[:resourceInfo][:citation][:onlineResources] = {}

                  # intMetadata[:resourceInfo][:keywords] = []
                  # intMetadata[:resourceInfo][:citation][:responsibleParties] = [{'parties':[{'contactId': 'test'}]}]

                  # :distributorInfo (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="distributionInfo"
                  # type="mcc:Abstract_Distribution_PropertyType"/>
                  xDistInfos = xMetadata.xpath(@@distributionInfoXPath)
                  intMetadata[:distributorInfo] = xDistInfos.map { |d| Distribution.unpack(d, hResponseObj) }

                  # :lineageInfo TODO
                  # :associatedResources TODO
                  # :additionalDocuments TODO
                  # :funding TODO
                  # :dataQuality TODO

                  intMetadata
               end
            end
         end
      end
   end
end
