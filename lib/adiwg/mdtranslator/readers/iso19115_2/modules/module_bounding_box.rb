# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
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
                  xWest = xBbox.xpath(@@westXPath)

                  if xWest.empty?
                     msg = 'WARNING: ISO19115-2 reader: element \'gmd:EX_GeographicBoundingBox\' '\
                        'is missing in gmd:EX_GeographicBoundingBox'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                  else
                     hBbox[:westLongitude] = xWest[0].text.to_f
                  end

                  # :eastLongitude (required)
                  # <xs:element name="eastBoundLongitude" type="gco:Decimal_PropertyType"/>
                  xEast = xBbox.xpath(@@eastXPath)

                  if xEast.empty?
                     msg = 'WARNING: ISO19115-2 reader: element \'gmd:eastBoundLongitude\' '\
                        'is missing in gmd:EX_GeographicBoundingBox'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                  else
                     hBbox[:eastLongitude] = xEast[0].text.to_f
                  end

                  # :northLatitude (required)
                  # <xs:element name="southBoundLatitude" type="gco:Decimal_PropertyType"/>
                  xNorth = xBbox.xpath(@@northXPath)

                  if xNorth.empty?
                     msg = 'WARNING: ISO19115-2 reader: element \'gmd:northBoundLongitude\' '\
                        'is missing in gmd:EX_GeographicBoundingBox'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                  else
                     hBbox[:northLatitude] = xNorth[0].text.to_f
                  end

                  # :southLatitude (required)
                  # <xs:element name="northBoundLatitude" type="gco:Decimal_PropertyType"/>
                  xSouth = xBbox.xpath(@@southXPath)

                  if xSouth.empty?
                     msg = 'WARNING: ISO19115-2 reader: element \'gmd:southBoundLongitude\' '\
                        'is missing in gmd:EX_GeographicBoundingBox'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                  else
                     hBbox[:southLatitude] = xSouth[0].text.to_f
                  end

                  hBbox
               end
            end
         end
      end
   end
end
