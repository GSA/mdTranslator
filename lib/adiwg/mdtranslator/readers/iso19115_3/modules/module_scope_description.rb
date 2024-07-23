# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module ScopeDescription
               @@scopeDescXPath = 'mcc:MD_ScopeDescription'
               @@attrsXPath = 'mcc:attributes//gco:CharacterString'
               @@featsXPath = 'mcc:features//gco:CharacterString'
               @@datasetXPath = 'mcc:dataset//gco:CharacterString'
               @@otherXPath = 'mcc:other//gco:CharacterString'
               def self.unpack(xLevelDesc, _hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hScopeDesc = intMetadataClass.newScopeDescription

                  xScopeDesc = xLevelDesc.xpath(@@scopeDescXPath)

                  # these scope description types not implemented -----------------------------
                  # featureInstances (not supported in mdJson)
                  # attributeInstances (not supported in mdJson)

                  # :dataset
                  xDataset = xScopeDesc.xpath(@@datasetXPath)[0]
                  hScopeDesc[:dataset] = xDataset.nil? ? nil : xDataset.text

                  # :attributes
                  xAttrs = xScopeDesc.xpath(@@attrsXPath)[0]
                  hScopeDesc[:attributes] = xAttrs.nil? ? nil : xAttrs.text

                  # :features
                  xFeats = xScopeDesc.xpath(@@featsXPath)[0]
                  hScopeDesc[:features] = xFeats.nil? ? nil : xFeats.text

                  # :other
                  xOther = xScopeDesc.xpath(@@otherXPath)[0]
                  hScopeDesc[:other] = xOther.nil? ? nil : xOther.text

                  hScopeDesc
               end
            end
         end
      end
   end
end
