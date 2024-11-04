# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_citation'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191152datagov
        module AggregationInformation
          @@mdAggregationInfoXPath = 'gmd:MD_AggregateInformation'
          @@initiativeTypeXpath = 'gmd:initiativeType//gmd:DS_InitiativeTypeCode'
          @@aggDatasetNameXPath = 'gmd:aggregateDataSetName'
          def self.unpack(xAggregrationInfo, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hAggInfo = intMetadataClass.newAssociatedResource

            # MD_AggregateInformation (optional)
            # <xs:sequence minOccurs="0">
            #    <xs:element ref="gmd:MD_AggregateInformation"/>
            # </xs:sequence>
            xMDAggregationInfo = xAggregrationInfo.xpath(@@mdAggregationInfoXPath)[0]
            return nil if xMDAggregationInfo.nil?

            # initiativeType (optional)
            # <xs:element name="initiativeType" type="gmd:DS_InitiativeTypeCode_PropertyType" minOccurs="0"/>
            xInitiativeType = xMDAggregationInfo.xpath(@@initiativeTypeXpath)[0]
            hAggInfo[:initiativeType] = xInitiativeType.attr('codeListValue') unless xInitiativeType.nil?

            # aggregateDataSetName (optional)
            # <xs:element name="aggregateDataSetName" type="gmd:CI_Citation_PropertyType" minOccurs="0"/>
            xAggDatasetName = xMDAggregationInfo.xpath(@@aggDatasetNameXPath)[0]
            unless xAggDatasetName.nil?
              hAggInfo[:resourceCitation] =
                Citation.unpack(xAggDatasetName, hResponseObj)
            end

            hAggInfo
          end
        end
      end
    end
  end
end
