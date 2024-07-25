# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_identification'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module ReferenceSystem
               @@vertRefSysPath = 'mrs:MD_ReferenceSystem'
               @@refSysCodeXPath = 'mrs:referenceSystemType//mrs:MD_ReferenceSystemTypeCode'
               @@refSysIdXPath = 'mcc:referenceSystemIdentifier'
               def self.unpack(vertCRSId, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hSRS = intMetadataClass.newSpatialReferenceSystem

                  codeListValue = ADIWG::Mdtranslator::Readers::Iso191153::CODELISTVALUE

                  return nil if vertCRSId.attr('gco:nilReason') == 'inapplicable'

                  xMDRefSys = vertCRSId.xpath(@@vertRefSysPath)[0]

                  # :systemType
                  xRefSysCode = xMDRefSys.xpath(@@refSysCodeXPath)[0]
                  hSRS[:systemType] = xRefSysCode.nil? ? nil : xRefSysCode.attr(codeListValue)

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
