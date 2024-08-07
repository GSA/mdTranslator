# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_resource_info'
require_relative 'module_metadata_info'
require_relative 'module_distribution'
require_relative 'module_associated_resource'
require_relative 'module_additional_document'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Metadata
               @@distributionInfoXPath = 'mdb:distributionInfo'
               @@associatedResourceXPath = 'mdb:identificationInfo//mri:MD_DataIdentification//mri:associatedResource'
               @@additionalDocXPath = 'mdb:identificationInfo//mri:MD_DataIdentification//mri:additionalDocumentation'
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

                  # :associatedResources (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="associatedResource"
                  # type="mri:MD_AssociatedResource_PropertyType"/>
                  xAssociatedResources = xMetadata.xpath(@@associatedResourceXPath)
                  intMetadata[:associatedResources] = xAssociatedResources.map do |a|
                     AssociatedResource.unpack(a, hResponseObj)
                  end

                  # :additionalDocuments (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="additionalDocumentation"
                  # type="mcc:Abstract_Citation_PropertyType"/>
                  xAdditionalDocs = xMetadata.xpath(@@additionalDocXPath)
                  intMetadata[:additionalDocuments] = xAdditionalDocs.map do |a|
                     AdditionalDocument.unpack(a, hResponseObj)
                  end

                  # :lineageInfo TODO
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
