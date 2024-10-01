# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_citation'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module AggregateInformation
               @@aggregateInfoXpath = 'gmd:MD_AggregateInformation'
               @@initiativeTypeXpath = 'gmd:initiativeType//gmd:DS_InitiativeTypeCode'
               @@aggregateDataSetNameXpath = 'gmd:aggregateDataSetName'
               def self.unpack(xAggregateInformation, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hAssociatedResources = intMetadataClass.newAssociatedResource
                  xaggregateInfos = xAggregateInformation.xpath(@@aggregateInfoXpath)[0]
                  return hAssociatedResources if xaggregateInfos.nil?

                  # initiativeType (optional)
                  # <xs:element name="initiativeType" type="gmd:DS_InitiativeTypeCode_PropertyType" minOccurs="0"/>
                  xInitiativeType = xaggregateInfos.xpath(@@initiativeTypeXpath)[0]
                  hAssociatedResources[:initiativeType] = xInitiativeType.nil? ? nil : xInitiativeType.attr('codeListValue')

                  # aggregateDataSetName (optional)
                  # <xs:element name="aggregateDataSetName" type="gmd:CI_Citation_PropertyType" minOccurs="0"/>
                  xAggregateDataSetName = xaggregateInfos.xpath(@@aggregateDataSetNameXpath)[0]
                  hAssociatedResources[:resourceCitation] = Citation.unpack(xAggregateDataSetName, hResponseObj)

                  hAssociatedResources
               end
            end
         end
      end
   end
end
