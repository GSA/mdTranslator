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
               # TODO: look more into mdb:identificationInfo
               # TODO: look more into mri:MD_DataIdentification
               # mdb:identificationInfo (required)
               # <element maxOccurs="unbounded" name="identificationInfo"
               # type="mcc:Abstract_ResourceDescription_PropertyType"/>
               # newMetadata expects 1 resourceInfo and yet ^ can occur >1

               @@distributionInfoXPath = 'mdb:distributionInfo'
               @@identificationInfoXPath = 'mdb:identificationInfo'
               @@dataIdentificationXPath = 'mri:MD_DataIdentification'
               @@associatedResourceXPath = 'mri:associatedResource'
               @@additionalDocXPath = 'mri:additionalDocumentation'
               def self.unpack(xMetadata, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  intMetadata = intMetadataClass.newMetadata

                  # :metadataInfo TODO
                  intMetadata[:metadataInfo] = MetadataInformation.unpack(xMetadata, hResponseObj)
                  # intMetadata[:metadataInfo][:metadataMaintenance] = {}
                  # intMetadata[:metadataInfo][:metadataMaintenance][:frequency] = 'hourly'
                  # intMetadata[:metadataInfo][:metadataIdentifier] = {}
                  # intMetadata[:metadataInfo][:metadataIdentifier][:identifier] = nil

                  # TODO: what happens when >1 are present?
                  xIdentificationInfo = xMetadata.xpath(@@identificationInfoXPath)[0]
                  if xIdentificationInfo.nil?
                     msg = 'ERROR: ISO19115-3 reader: element \'mdb:identificationInfo\' is missing in mdb:MD_Metadata'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return intMetadata
                  end

                  # MD Data Identifier (required)
                  # <element name="MD_DataIdentification" substitutionGroup="mri:AbstractMD_Identification"
                  # type="mri:MD_DataIdentification_Type">
                  xDataIdentification = xIdentificationInfo.xpath(@@dataIdentificationXPath)[0]
                  if xDataIdentification.nil?
                     msg = 'ERROR: ISO19115-3 reader: element \'mri:MD_DataIdentification\' ' \
                     'is missing in mdb:identificationInfo'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return intMetadata
                  end

                  intMetadata[:resourceInfo] = ResourceInformation.unpack(xDataIdentification, hResponseObj)

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
                  xAssociatedResources = xDataIdentification.xpath(@@associatedResourceXPath)
                  intMetadata[:associatedResources] = xAssociatedResources.map do |a|
                     AssociatedResource.unpack(a, hResponseObj)
                  end

                  # :additionalDocuments (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="additionalDocumentation"
                  # type="mcc:Abstract_Citation_PropertyType"/>
                  xAdditionalDocs = xDataIdentification.xpath(@@additionalDocXPath)
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
