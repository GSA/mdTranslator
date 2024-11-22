# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_bounding_box'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191151datagov
        module GeographicExtent
          @@extTypeCodeXPath = './/gmd:extentTypeCode//gco:Boolean'
          def self.unpack(xGeoElem, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hGeoExt = intMetadataClass.newGeographicExtent

            # :boundingBox (optional)
            # <xs:sequence minOccurs="0"><xs:element ref="gmd:EX_GeographicBoundingBox"/></xs:sequence>
            hGeoExt[:boundingBox] = BoundingBox.unpack(xGeoElem, hResponseObj)

            # :containsData (optional)
            # <xs:element name="extentTypeCode" type="gco:Boolean_PropertyType" minOccurs="0"/>
            xExtTypeCode = xGeoElem.xpath(@@extTypeCodeXPath)[0]
            hGeoExt[:containsData] = xExtTypeCode.text unless xExtTypeCode.nil?

            # NOTE: In cases without a boundingBox, the dcat_us_spatial writer checks for a 'point' type
            # within :geographicElement, geographicElement processing is not yet implemented -- TODO

            hGeoExt
          end
        end
      end
    end
  end
end
