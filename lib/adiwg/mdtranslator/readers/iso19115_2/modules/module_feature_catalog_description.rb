# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_citation'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module FeatureCatalogDescription
               @@featCatalogDescXPath = 'gmd:MD_FeatureCatalogueDescription'
               @@includedWithDatasetXPath = 'gmd:includedWithDataset//gco:Boolean'
               @@featCatalogCitationXPath = 'gmd:featureCatalogueCitation'
               def self.unpack(xContentInfo, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hDataDictionary = intMetadataClass.newDataDictionary

                  xFeatCatalog = xContentInfo.xpath(@@featCatalogDescXPath)[0]
                  return nil if xFeatCatalog.nil?

                  # includedWithDataset (required)
                  # <xs:element name="includedWithDataset" type="gco:Boolean_PropertyType"/>
                  xIncludedWithDataset = xFeatCatalog.xpath(@@includedWithDatasetXPath)[0]
                  if xIncludedWithDataset.nil?
                     msg = "WARNING: ISO19115-2 reader: element '#{xFeatCatalog.name}' " \
                        "is missing #{@@includedWithDatasetXPath}"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end
                  hDataDictionary[:includedWithDataset] = xIncludedWithDataset.text != 'false'

                  # citation (required)
                  # <xs:element name="featureCatalogueCitation" type="gmd:CI_Citation_PropertyType"
                  # maxOccurs="unbounded"/>
                  # the internal object is a hash not array. TODO revisit
                  xFeatCatalogCitation = xFeatCatalog.xpath(@@featCatalogCitationXPath)[0]
                  if xFeatCatalogCitation.nil?
                     msg = "WARNING: ISO19115-2 reader: element '#{@@featCatalogCitationXPath}' " \
                        "is missing #{xFeatCatalog.name}"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  hDataDictionary[:citation] = Citation.unpack(xFeatCatalogCitation, hResponseObj)

                  hDataDictionary
               end
            end
         end
      end
   end
end
