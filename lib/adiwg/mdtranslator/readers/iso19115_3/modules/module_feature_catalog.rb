# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_citation'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module FeatureCatalog
               @@featCatalogDescXPath = 'mrc:MD_FeatureCatalogueDescription'
               @@includedWithDatasetXPath = 'mrc:includedWithDataset//gco:Boolean'
               @@featCatalogCitationXPath = 'mrc:featureCatalogueCitation'
               def self.unpack(xContentInfo, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hDataDict = intMetadataClass.newDataDictionary

                  xFeatCatalogDesc = xContentInfo.xpath(@@featCatalogDescXPath)[0]

                  return hDataDict if xFeatCatalogDesc.nil?

                  # dcatus describeby and describebytype only needs these...

                  # :includedWithDataset (optional)
                  # <element minOccurs="0" name="includedWithDataset" type="gco:Boolean_PropertyType">
                  xIncludedWithDataset = xFeatCatalogDesc.xpath(@@includedWithDatasetXPath)[0]
                  unless xIncludedWithDataset.nil?
                     hDataDict[:includedWithDataset] = xIncludedWithDataset.text.downcase == 'true'
                  end

                  # :citation (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="featureCatalogueCitation"
                  # type="mcc:Abstract_Citation_PropertyType">
                  # the internal object expects only 1 citation but the schema allows for many. only doing 1
                  xFeatCatalogCitation = xFeatCatalogDesc.xpath(@@featCatalogCitationXPath)[0]
                  hDataDict[:citation] =
                     xFeatCatalogCitation.nil? ? nil : Citation.unpack(xFeatCatalogCitation, hResponseObj)

                  hDataDict
               end
            end
         end
      end
   end
end
