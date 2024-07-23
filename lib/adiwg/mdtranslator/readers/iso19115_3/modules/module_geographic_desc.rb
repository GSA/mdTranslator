# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_identification'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module GeographicDescription
               @@geoDescXPath = 'gex:EX_GeographicDescription'
               @@geoIdXPath = 'gex:geographicIdentifier'
               def self.unpack(xGeoElem, hResponseObj)
                  xGeoDesc = xGeoElem.xpath(@@geoDescXPath)[0]
                  return if xGeoDesc.nil?

                  xGeoId = xGeoDesc.xpath(@@geoIdXPath)[0]
                  if xGeoId.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'gex:geographicIdentifier\''\
                     'is missing in gex:geographicElement'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                  else
                     hIdentifier = Identification.unpack(xGeoId, hResponseObj)
                     hIdentifier.empty? ? {} : hIdentifier[0]
                  end
               end
            end
         end
      end
   end
end
