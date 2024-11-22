# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require 'adiwg/mdtranslator/internal/module_utils'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191151datagov
        module BoundingBox
          @@bbXPath = 'gmd:EX_GeographicBoundingBox'
          @@westXPath = 'gmd:westBoundLongitude'
          @@eastXPath = 'gmd:eastBoundLongitude'
          @@northXPath = 'gmd:northBoundLatitude'
          @@southXPath = 'gmd:southBoundLatitude'
          def self.unpack(xGeoElem, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hBbox = intMetadataClass.newBoundingBox

            # all extensions of gmd:AbstractEX_GeographicExtent_Type are optional
            # within EX_GeographicExtent_PropertyType
            # xs:sequence minOccurs="0">
            #   <xs:element ref="gmd:AbstractEX_GeographicExtent"/>
            # </xs:sequence>
            xBbox = xGeoElem.xpath(@@bbXPath)[0]
            return nil if xBbox.nil?

            # :westLongitude (required)
            # <xs:element name="westBoundLongitude" type="gco:Decimal_PropertyType"/>
            # :eastLongitude (required)
            # <xs:element name="eastBoundLongitude" type="gco:Decimal_PropertyType"/>
            # :northLatitude (required)
            # <xs:element name="southBoundLatitude" type="gco:Decimal_PropertyType"/>
            # :southLatitude (required)
            # <xs:element name="northBoundLatitude" type="gco:Decimal_PropertyType"/>
            boundingElements = {
              westLongitude: { xpath: @@westXPath, message: 'gmd:westBoundLongitude' },
              eastLongitude: { xpath: @@eastXPath, message: 'gmd:eastBoundLongitude' },
              northLatitude: { xpath: @@northXPath, message: 'gmd:northBoundLatitude' },
              southLatitude: { xpath: @@southXPath, message: 'gmd:southBoundLatitude' }
            }

            boundingElements.each do |key, info|
              element = xBbox.xpath(info[:xpath])[0]

              if element.nil?
                msg = "WARNING: ISO19115-1 reader: element '#{info[:message]}' " \
                 'is missing in gmd:EX_GeographicBoundingBox'
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              else
                # all gco:Decimal are optional
                # <xs:sequence minOccurs="0">
                # <xs:element ref="gco:Decimal"/>
                # </xs:sequence>
                xDec = element.xpath('gco:Decimal')[0]

                if xDec.nil? && !AdiwgUtils.valid_nil_reason(element, hResponseObj)
                  msg = "WARNING: ISO19115-1 reader: element \'#{element.name}\' "\
                   "is missing valid nil reason within \'#{xBbox.name}\'"
                  hResponseObj[:readerValidationMessages] << msg
                  hResponseObj[:readerValidationPass] = false
                end

                hBbox[key] = xDec.text.to_f unless xDec.nil?
              end
            end

            hBbox
          end
        end
      end
    end
  end
end
