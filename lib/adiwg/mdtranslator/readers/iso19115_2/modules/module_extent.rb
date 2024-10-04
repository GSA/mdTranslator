# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_geographic_extent'
require_relative 'module_temporal_extent'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module Extent
               @@exExtentXPath = 'gmd:EX_Extent'
               @@geoElemXPath = 'gmd:geographicElement'
               @@temporalElemXPath = 'gmd:temporalElement'
               def self.unpack(xExtent, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hExtent = intMetadataClass.newExtent

                  xExExtent = xExtent.xpath(@@exExtentXPath)[0]
                  return nil if xExExtent.nil?

                  # :geographicExtents (optional)
                  # <xs:element name="geographicElement" type="gmd:EX_GeographicExtent_PropertyType" minOccurs="0" maxOccurs="unbounded"/>
                  xGeoElems = xExExtent.xpath(@@geoElemXPath)
                  unless xGeoElems.empty?
                     hExtent[:geographicExtents] = xGeoElems.map { |g| GeographicExtent.unpack(g, hResponseObj) }.compact
                  end
                 
                  # :temporalExtents (optional)
                  # <xs:element name="temporalElement" type="gmd:EX_TemporalExtent_PropertyType" minOccurs="0" maxOccurs="unbounded"/>
                  xTemporalElems = xExExtent.xpath(@@temporalElemXPath)
                  unless xTemporalElems.empty?
                     hExtent[:temporalExtents] = xTemporalElems.map { |t| TemporalExtent.unpack(t, hResponseObj) }.compact
                  end

                  hExtent
               end
            end
         end
      end
   end
end
