# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_identification'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module BoundingBox
               @@bbXPath = 'gex:EX_GeographicBoundingBox'
               @@westXPath = 'gex:westBoundLongitude/gco:Decimal'
               @@eastXPath = 'gex:eastBoundLongitude/gco:Decimal'
               @@northXPath = 'gex:northBoundLatitude/gco:Decimal'
               @@southXPath = 'gex:southBoundLatitude/gco:Decimal'
               def self.unpack(xGeoElem, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hBbox = intMetadataClass.newBoundingBox

                  # TODO: to_f method defaults to 0.0 if the value can't be converted.
                  # should communicate this to the end user.

                  xBbox = xGeoElem.xpath(@@bbXPath)
                  return nil if xBbox.empty?

                  # :westLongitude (required)
                  xWest = xBbox.xpath(@@westXPath)

                  if xWest.empty?
                     msg = 'WARNING: ISO19115-3 reader: element \'gex:EX_GeographicBoundingBox\' '\
                        'is missing in gex:EX_GeographicBoundingBox'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                  else
                     hBbox[:westLongitude] = xWest[0].text.to_f
                  end

                  # :eastLongitude (required)
                  xEast = xBbox.xpath(@@eastXPath)

                  if xEast.empty?
                     msg = 'WARNING: ISO19115-3 reader: element \'gex:eastBoundLongitude\' '\
                        'is missing in gex:EX_GeographicBoundingBox'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                  else
                     hBbox[:eastLongitude] = xEast[0].text.to_f
                  end

                  # :northLatitude (required)
                  xNorth = xBbox.xpath(@@northXPath)

                  if xNorth.empty?
                     msg = 'WARNING: ISO19115-3 reader: element \'gex:northBoundLongitude\' '\
                        'is missing in gex:EX_GeographicBoundingBox'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                  else
                     hBbox[:northLatitude] = xNorth[0].text.to_f
                  end

                  # :southLatitude (required)
                  xSouth = xBbox.xpath(@@southXPath)

                  if xSouth.empty?
                     msg = 'WARNING: ISO19115-3 reader: element \'gex:southBoundLongitude\' '\
                        'is missing in gex:EX_GeographicBoundingBox'
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
