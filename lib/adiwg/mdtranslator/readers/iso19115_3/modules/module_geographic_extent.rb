# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_bounding_box'
require_relative 'module_geographic_desc'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module GeographicExtent
               @@extTypeCodeXPath = './/gex:extentTypeCode//gco:Boolean'
               @@extGeoIdXPath = 'gex:EX_GeographicDescription//gex:geographicIdentifier'
               @@geoBPXPath = 'gex:EX_BoundingPolygon' # TODO
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

                  # TODO: skipping these for now...
                  # :description str  (this doesn't exist for geographic extents)

                  # :geographicElements hash (there's no internal object for these elements...)
                  # this populates gex:EX_BoundingPolygon

                  # :nativeGeoJson array
                  # :computedBbox bash

                  hGeoExt
               end
            end
         end
      end
   end
end
