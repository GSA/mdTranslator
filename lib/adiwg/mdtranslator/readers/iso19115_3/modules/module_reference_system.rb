# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_identification'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module ReferenceSystem
               @@vertRefSysPath = 'gex:verticalCRSId//mrs:MD_ReferenceSystem'
               @@refSysCodeXPath = 'mrs:referenceSystemType//mrs:MD_ReferenceSystemTypeCode'
               @@refSysIdXPath = './/gmd:referenceSystemIdentifier'
               def self.unpack(xVertExtent, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hSRS = intMetadataClass.newSpatialReferenceSystem

                  codeListValue = ADIWG::Mdtranslator::Readers::Iso191153::CODELISTVALUE

                  xMDRefSys = xVertExtent.xpath(@@vertRefSysPath)[0]
                  xRefSysCode = xMDRefSys.xpath(@@refSysCodeXPath)

                  # :systemType
                  hSRS[:systemType] = xRefSysCode.empty? ? nil : xRefSysCode[0].attr(codeListValue)

                  # :systemIdentifier
                  xRefSysId = xMDRefSys.xpath(@@refSysIdXPath)[0]

                  # TODO: update Identification to work without grabbing the first element
                  hSRS[:systemIdentifier] = Identification.unpack(xRefSysId, hResponseObj)[0]

                  # TODO: systemWKT nil

                  # :systemParameterSet
                  # "reference system parameter sets not implemented in ISO 19115-3"

                  hSRS
               end
            end
         end
      end
   end
end
