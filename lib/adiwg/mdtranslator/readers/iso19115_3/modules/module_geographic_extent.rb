# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_identification'
require_relative 'module_bounding_box'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module GeographicExtent
               @@geoElemXPath = './/gex:geographicElement'
               @@extTypeCodeXPath = './/gex:extentTypeCode//gco:Boolean'
               @@extGeoIdXPath = './/gex:geographicIdentifier'

               @@geoBBXPath = 'gex:EX_GeographicBoundingBox'
               @@geoDescXPath = 'gex:EX_GeographicDescription'
               # TODO: gex:EX_BoundingPolygon

               def self.process_geo_extent(xGeoElem, hGeoExt, hResponseObj)
                  # determine what kind of element we're in...
                  xGeoElemType = xGeoElem.children.select { |child| child.instance_of? Nokogiri::XML::Element }[0]

                  # :identifier
                  if xGeoElemType.name == 'EX_GeographicDescription'
                     xGeoId = xGeoElem.xpath(@@extGeoIdXPath)

                     if xGeoId.empty?
                        msg = 'WARNING: ISO19115-3 reader: element \'gex:geographicIdentifier\''\
                        'is missing in gex:geographicElement'
                        hResponseObj[:readerExecutionMessages] << msg
                        hResponseObj[:readerExecutionPass] = false
                     else
                        hIdentifier = Identification.unpack(xGeoId[0], hResponseObj)
                        hGeoExt[:identifier] = hIdentifier.empty? ? {} : hIdentifier[0]
                     end
                  end

                  return unless xGeoElemType.name == 'EX_GeographicBoundingBox'

                  # :boundingBox
                  hGeoExt[:boundingBox] = BoundingBox.unpack(xGeoElem, hResponseObj)

                  # :containsData
                  # TODO: this value is in bb geo element but may exist in any geo elem child?
                  xExtTypeCode = xGeoElem.xpath(@@extTypeCodeXPath)
                  hGeoExt[:containsData] = xExtTypeCode.empty? ? nil : xExtTypeCode[0].text

                  # TODO: skipping these for now...
                  # :description str  (this doesn't exist for geographic extents)
                  # :geographicElements hash (there's no internal object for these elements...)
                  # :nativeGeoJson array
                  # :computedBbox bash
               end

               def self.unpack(xExtent, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hGeoExt = intMetadataClass.newGeographicExtent

                  xGeoElems = xExtent.xpath(@@geoElemXPath)
                  xGeoElems.each do |xgeoelem|
                     process_geo_extent(xgeoelem, hGeoExt, hResponseObj)
                  end
                  hGeoExt
               end
            end
         end
      end
   end
end
