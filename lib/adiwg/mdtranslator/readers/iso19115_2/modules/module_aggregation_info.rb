# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_citation'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module AggregationInformation
               @@mdAggregationInfoXPath = 'gmd:MD_AggregateInformation'
               @@aggDatasetNameXPath = 'gmd:aggregateDataSetName'
               def self.unpack(xAggregrationInfo, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hAggInfo = intMetadataClass.newAssociatedResource

                  xMDAggregationInfo = xAggregrationInfo.xpath(@@mdAggregationInfoXPath)[0]

                  return nil if xMDAggregationInfo.nil?

                  # :resourceCitation (optional)
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
