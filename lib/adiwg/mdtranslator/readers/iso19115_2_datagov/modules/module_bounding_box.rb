# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152datagov
            module BoundingBox
               @@bbXPath = 'gmd:EX_GeographicBoundingBox'
               @@westXPath = 'gmd:westBoundLongitude/gco:Decimal'
               @@eastXPath = 'gmd:eastBoundLongitude/gco:Decimal'
               @@northXPath = 'gmd:northBoundLatitude/gco:Decimal'
               @@southXPath = 'gmd:southBoundLatitude/gco:Decimal'
               def self.unpack(xGeoElem, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hBbox = intMetadataClass.newBoundingBox

                  xBbox = xGeoElem.xpath(@@bbXPath)
                  return nil if xBbox.empty?

                  # :westLongitude (required)
                  # <xs:element name="westBoundLongitude" type="gco:Decimal_PropertyType"/>
                  # :eastLongitude (required)
                  # <xs:element name="eastBoundLongitude" type="gco:Decimal_PropertyType"/>
                  # :northLatitude (required)
                  # <xs:element name="southBoundLatitude" type="gco:Decimal_PropertyType"/>
                  # :southLatitude (required)
                  # <xs:element name="northBoundLatitude" type="gco:Decimal_PropertyType"/>
                  bounding_elements = {
                     westLongitude: { xpath: @@westXPath, message: 'gmd:westBoundLongitude' },
                     eastLongitude: { xpath: @@eastXPath, message: 'gmd:eastBoundLongitude' },
                     northLatitude: { xpath: @@northXPath, message: 'gmd:northBoundLatitude' },
                     southLatitude: { xpath: @@southXPath, message: 'gmd:southBoundLatitude' }
                  }

                  bounding_elements.each do |key, info|
                     element = xBbox.xpath(info[:xpath])
                     if element.empty?
                        msg = "WARNING: ISO19115-2 reader: element '#{info[:message]}' " \
                         'is missing in gmd:EX_GeographicBoundingBox'
                        hResponseObj[:readerExecutionMessages] << msg
                        hResponseObj[:readerExecutionPass] = false
                     else
                        hBbox[key] = element[0].text.to_f
                     end
                  end

                  hBbox
               end
            end
         end
      end
   end
end
