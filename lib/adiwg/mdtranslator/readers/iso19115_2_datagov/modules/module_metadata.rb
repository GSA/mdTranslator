# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_resource_info'
require_relative 'module_metadata_info'
require_relative 'module_distribution'
require_relative 'module_aggregation_info'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152datagov
            module Metadata
               @@identificationInfoXPath = 'gmd:identificationInfo'
               @@dataIdentificationXPath = 'gmd:MD_DataIdentification'
               @@distributionInfoXPath = 'gmd:distributionInfo'
               @@aggregationInfoXPath = 'gmd:identificationInfo//gmd:MD_DataIdentification//gmd:aggregationInfo'
               def self.unpack(xMetadata, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  intMetadata = intMetadataClass.newMetadata

                  # :metadataInfo

                  # <xs:element name="identificationInfo"
                  # type="gmd:MD_Identification_PropertyType" maxOccurs="unbounded"/>
                  # TODO: what happens when >1 are present?
                  xIdentificationInfo = xMetadata.xpath(@@identificationInfoXPath)[0]
                  if xIdentificationInfo.nil?
                     msg = "ERROR: ISO19115-2 reader: element \'#{@@identificationInfoXPath}\'" \
                     " is missing in #{xMetadata.name}"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return intMetadata
                  end

                  # <xs:element name="MD_DataIdentification" type="gmd:MD_DataIdentification_Type"
                  # substitutionGroup="gmd:AbstractMD_Identification"/>
                  xDataIdentification = xIdentificationInfo.xpath(@@dataIdentificationXPath)[0]
                  if xDataIdentification.nil?
                     msg = "ERROR: ISO19115-2 reader: element \'#{@@dataIdentificationXPath}\' " \
                     "is missing in #{xIdentificationInfo.name}"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return intMetadata
                  end

                  intMetadata[:resourceInfo] = ResourceInformation.unpack(xDataIdentification, hResponseObj)

                  # :associatedResources (optional)
                  # <xs:element name="aggregationInfo" type="gmd:MD_AggregateInformation_PropertyType" minOccurs="0" maxOccurs="unbounded"/>
                  xAbstractIdentification = xDataIdentification.xpath(@@aggregationInfoXPath)
                  intMetadata[:associatedResources] = xAbstractIdentification.map do |a|
                     AggregateInformation.unpack(a, hResponseObj)
                  end

                  intMetadata[:metadataInfo] = MetadataInformation.unpack(xMetadata, hResponseObj)

                  # :associatedResources (optional)
                  # <xs:element name="aggregationInfo" type="gmd:MD_AggregateInformation_PropertyType"
                  # minOccurs="0" maxOccurs="unbounded"/>
                  xAggregationInfos = xMetadata.xpath(@@aggregationInfoXPath)
                  intMetadata[:associatedResources] = xAggregationInfos.map do |a|
                     AggregationInformation.unpack(a, hResponseObj)
                  end
                  intMetadata[:associatedResources] = intMetadata[:associatedResources].compact

                  # :distributorInfo
                  # <xs:element name="distributionInfo" type="gmd:MD_Distribution_PropertyType" minOccurs="0"/>
                  # TODO: for Distribution, the spec expects a hash, but the DCAT writer expects an array
                  xDistributionInfo = xMetadata.xpath(@@distributionInfoXPath)[0]
                  unless xDistributionInfo.nil?
                     intMetadata[:distributorInfo] = [Distribution.unpack(xDistributionInfo, hResponseObj)]
                  end

                  # TODO: (not required by dcatus writer)
                  # :associatedResources
                  # :additionalDocuments
                  # :lineageInfo
                  # :additionalDocuments
                  # :funding
                  # :dataQuality
                  intMetadata
               end
            end
         end
      end
   end
end
