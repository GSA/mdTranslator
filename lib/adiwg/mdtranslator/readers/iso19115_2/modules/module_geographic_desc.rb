# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module GeographicDescription
               @@geoDescXPath = 'gmd:EX_GeographicDescription'
               @@geoIdXPath = 'gmd:geographicIdentifier'
               def self.unpack(xGeoElem, hResponseObj)

                  # :EX_GeographicDescription (optional)
                  # <xs:sequence minOccurs="0"> <xs:element ref="gmd:EX_GeographicDescription"/></xs:sequence>
                  xGeoDesc = xGeoElem.xpath(@@geoDescXPath)[0]
                  return if xGeoDesc.nil?

                  # :geographicIdentifier (required)
                  # <xs:element name="geographicIdentifier" type="gmd:MD_Identifier_PropertyType"/>
                  xGeoId = xGeoDesc.xpath(@@geoIdXPath)[0]
                  if xGeoId.nil?
                     msg = 'WARNING: ISO19115-2 reader: element \'gmd:geographicIdentifier\''\
                     'is missing in gmd:geographicElement'
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
