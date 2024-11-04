# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_citation'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191152datagov
        module FeatureCatalogDescription
          @@featCatalogDescXPath = 'gmd:MD_FeatureCatalogueDescription'
          @@includedWithDatasetXPath = 'gmd:includedWithDataset'
          @@featCatalogCitationXPath = 'gmd:featureCatalogueCitation'
          def self.unpack(xContentInfo, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hDataDictionary = intMetadataClass.newDataDictionary

            # MD_FeatureCatalogueDescrption (optional)
            # <xs:sequence minOccurs="0">
            #   <xs:element ref="gmd:MD_FeatureCatalogueDescription"/>
            # </xs:sequence>
            xFeatCatalog = xContentInfo.xpath(@@featCatalogDescXPath)[0]
            return nil if xFeatCatalog.nil?

            # includedWithDataset (required)
            # <xs:element name="includedWithDataset" type="gco:Boolean_PropertyType"/>
            xIncludedWithDataset = xFeatCatalog.xpath(@@includedWithDatasetXPath)[0]
            if xIncludedWithDataset.nil?
              msg = "WARNING: ISO19115-2 reader: element '#{xFeatCatalog.name}' " \
            "is missing #{@@includedWithDatasetXPath}"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else

              # all booleans are optional
              # <xs:sequence minOccurs="0">
              #   <xs:element ref="gco:Boolean"/>
              # </xs:sequence>
              xBool = xIncludedWithDataset.xpath('gco:Boolean')[0]

              if xBool.nil? && !AdiwgUtils.valid_nil_reason(xIncludedWithDataset, hResponseObj)
                msg = "WARNING: ISO19115-2 reader: element \'#{xIncludedWithDataset.name}\' "\
                 "is missing valid nil reason within \'#{xFeatCatalog.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end

              hDataDictionary[:includedWithDataset] = xBool.text != 'false' unless xBool.nil?
            end

            # citation (required)
            # <xs:element name="featureCatalogueCitation" type="gmd:CI_Citation_PropertyType"
            # maxOccurs="unbounded"/>
            # the internal object is a hash not array. TODO revisit
            xFeatCatalogCitation = xFeatCatalog.xpath(@@featCatalogCitationXPath)[0]
            if xFeatCatalogCitation.nil?
              msg = "WARNING: ISO19115-2 reader: element '#{@@featCatalogCitationXPath}' " \
              "is missing #{xFeatCatalog.name}"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else

              # requirement comments are in citation module
              xCit = xFeatCatalogCitation.xpath('gmd:CI_Citation')[0]

              if xCit.nil? && !AdiwgUtils.valid_nil_reason(xFeatCatalogCitation, hResponseObj)
                msg = "WARNING: ISO19115-2 reader: element \'#{xFeatCatalogCitation.name}\' "\
                 "is missing valid nil reason within \'#{xFeatCatalog.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end

              hCitation = Citation.unpack(xFeatCatalogCitation, hResponseObj)
              hDataDictionary[:citation] = hCitation unless hCitation.nil?
            end

            hDataDictionary
          end
        end
      end
    end
  end
end
