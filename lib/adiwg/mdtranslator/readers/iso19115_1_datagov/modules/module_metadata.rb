# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_data_identification'
require_relative 'module_metadata_info'
require_relative 'module_distribution'
require_relative 'module_aggregation_info'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191151datagov
        module Metadata
          @@identificationInfoXPath = 'gmd:identificationInfo'
          @@distributionInfoXPath = 'gmd:distributionInfo'
          @@aggregationInfoXPath = 'gmd:identificationInfo//gmd:MD_DataIdentification//gmd:aggregationInfo'
          def self.unpack(xMetadata, hResponseObj)
            intMetadataClass = InternalMetadata.new
            intMetadata = intMetadataClass.newMetadata

            # :metadataInfo (required)
            # <xs:element name="identificationInfo"
            # type="gmd:MD_Identification_PropertyType" maxOccurs="unbounded"/>
            # TODO: what happens when >1 are present?
            xIdentificationInfo = xMetadata.xpath(@@identificationInfoXPath)[0]
            # TODO: what if the 0th one is no good and 1th is?
            if xIdentificationInfo.nil?
              msg = "WARNING: ISO19115-1 reader: element \'#{@@identificationInfoXPath}\'" \
              " is missing in #{xMetadata.name}"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else
              # resourceInfo is a hash but appears as an array in the data
              xDataId = xIdentificationInfo.xpath('gmd:MD_DataIdentification')[0]

              if xDataId.nil? && !AdiwgUtils.valid_nil_reason(xIdentificationInfo, hResponseObj)
                msg = "WARNING: ISO19115-1 reader: element \'#{xIdentificationInfo.name}\' "\
                 "is missing valid nil reason within \'#{xMetadata.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end
              hDataId = DataIdentification.unpack(xIdentificationInfo, hResponseObj)
              intMetadata[:resourceInfo] = hDataId unless hDataId.nil?
            end

            # :associatedResources (optional)
            # <xs:element name="aggregationInfo" type="gmd:MD_AggregateInformation_PropertyType"
            #   minOccurs="0" maxOccurs="unbounded"/>
            # TODO: grabs the first 0th one.
            xAbstractIdentification = xMetadata.xpath(@@aggregationInfoXPath)
            intMetadata[:associatedResources] = xAbstractIdentification.map do |a|
              AggregationInformation.unpack(a, hResponseObj)
            end.compact

            intMetadata[:metadataInfo] = MetadataInformation.unpack(xMetadata, hResponseObj)

            # :associatedResources (optional)
            # <xs:element name="aggregationInfo" type="gmd:MD_AggregateInformation_PropertyType"
            # minOccurs="0" maxOccurs="unbounded"/>
            xAggregationInfos = xMetadata.xpath(@@aggregationInfoXPath)
            intMetadata[:associatedResources] = xAggregationInfos.map do |a|
              AggregationInformation.unpack(a, hResponseObj)
            end.compact

            # :distributorInfo (optional)
            # <xs:element name="distributionInfo" type="gmd:MD_Distribution_PropertyType" minOccurs="0"/>
            # TODO: for Distribution, the spec expects a hash, but the DCAT writer expects an array
            xDistributionInfo = xMetadata.xpath(@@distributionInfoXPath)[0]
            unless xDistributionInfo.nil?
              intMetadata[:distributorInfo] = [Distribution.unpack(xDistributionInfo, hResponseObj)].compact
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
