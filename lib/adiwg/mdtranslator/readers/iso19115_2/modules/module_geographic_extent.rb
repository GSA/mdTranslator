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

                  # :boundingBox (optional)
                  # <xs:sequence minOccurs="0"><xs:element ref="gmd:EX_GeographicBoundingBox"/></xs:sequence>
                  hGeoExt[:boundingBox] = BoundingBox.unpack(xGeoElem, hResponseObj)

                  # :identifier (optional)
                  # <xs:sequence minOccurs="0"><xs:element ref="gmd:EX_GeographicDescription"/></xs:sequence>
                  hGeoExt[:identifier] = GeographicDescription.unpack(xGeoElem, hResponseObj)

                  # :containsData (optional)
                  # <xs:element name="extentTypeCode" type="gco:Boolean_PropertyType" minOccurs="0"/>
                  xExtTypeCode = xGeoElem.xpath(@@extTypeCodeXPath)[0]
                  hGeoExt[:containsData] = xExtTypeCode.nil? ? nil : xExtTypeCode.text

                  # dcat_us_spatial writer try to find a point in :geographicElement with :type and :coordinate
                  # we are not going to process geographicElement now -- TODO

                  hGeoExt
               end
            end
         end
      end
   end
end
