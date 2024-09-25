# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_geographic_extent'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module Extent
               @@exExtentXPath = 'gmd:EX_Extent'
               @@descXPath = 'gmd:description//gco:CharacterString'
               @@geoElemXPath = 'gmd:geographicElement'
               def self.unpack(xExtent, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hExtent = intMetadataClass.newExtent

                  xExExtent = xExtent.xpath(@@exExtentXPath)[0]
                  return nil if xExExtent.nil?

                  # :description (optional)
                  # <xs:element name="description" type="gco:CharacterString_PropertyType" minOccurs="0"/>
                  xDesc = xExExtent.xpath(@@descXPath)[0]
                  hExtent[:description] = xDesc.nil? ? nil : xDesc.text

                  # :geographicExtents (optional)
                  # <xs:element name="geographicElement" type="gmd:EX_GeographicExtent_PropertyType" minOccurs="0" maxOccurs="unbounded"/>
                  xGeoElems = xExExtent.xpath(@@geoElemXPath)
                  unless xGeoElems.nil?
                     hExtent[:geographicExtents] = xGeoElems.map { |g| GeographicExtent.unpack(g, hResponseObj) }
                  end

                  hExtent
               end
            end
         end
      end
   end
end
