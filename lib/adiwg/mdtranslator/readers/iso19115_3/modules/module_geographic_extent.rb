# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module GeographicExtent
               @@geoExtent = 'gex:geographicElement'
               def self.process_geographic_extent(xExExtent, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hGeoExt = intMetadataClass.newGeographicExtent

                  # :description str

                  # :containsData bool
                  # :identifier: hash
                  # :boundingBox: hash
                  # :geographicElements hash
                  # :nativeGeoJson array
                  # :computedBbox bash
               end

               def self.unpack(xExExtent, hResponseObj)
                  xGeoExtents = xExExtent.xpath(@@geoExtent)
                  xGeoExtents.map { |e| process_geographic_extent(e, hResponseObj) }
               end
            end
         end
      end
   end
end
