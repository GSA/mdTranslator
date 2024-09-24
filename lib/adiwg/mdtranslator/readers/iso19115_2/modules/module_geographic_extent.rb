# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_bounding_box'
require_relative 'module_geographic_desc'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module GeographicExtent
               @@extTypeCodeXPath = './/gmd:extentTypeCode//gco:Boolean'
               def self.unpack(xGeoElem, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hGeoExt = intMetadataClass.newGeographicExtent

                  # :boundingBox
                  hGeoExt[:boundingBox] = BoundingBox.unpack(xGeoElem, hResponseObj)

                  # :identifier
                  hGeoExt[:identifier] = GeographicDescription.unpack(xGeoElem, hResponseObj)

                  # :containsData
                  xExtTypeCode = xGeoElem.xpath(@@extTypeCodeXPath)[0]
                  hGeoExt[:containsData] = xExtTypeCode.nil? ? nil : xExtTypeCode.text

                  hGeoExt
               end
            end
         end
      end
   end
end
