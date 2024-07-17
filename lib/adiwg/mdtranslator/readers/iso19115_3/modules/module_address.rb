# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Address
               @@addressXPath = 'cit:address'
               @@ciAddressXPath = 'cit:CI_Address'
               @@deliveryPntXPath = 'cit:deliveryPoint//gco:CharacterString'
               @@cityXPath = 'cit:city//gco:CharacterString'
               @@adminAreaXPath = 'cit:administrativeArea//gco:CharacterString'
               @@postalXPath = 'cit:postalCode//gco:CharacterString'
               @@countryXPath = 'cit:country//gco:CharacterString'
               @@emailXPath = 'cit:electronicMailAddress//gco:CharacterString'
               def self.unpack(xContact, _hResponseObj) # rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
                  intMetadataClass = InternalMetadata.new

                  addresses = []
                  emails = []
                  xAddresses = xContact.xpath(@@addressXPath)

                  xAddresses.each do |xaddress|
                     # physical address
                     hAddress = intMetadataClass.newAddress

                     xCiAddress = xaddress.xpath(@@ciAddressXPath)[0]
                     return xCiAddress if xCiAddress.nil?

                     # address - address type (not used by ISO 19115-3)
                     # address - description (not used by ISO 19115-3)

                     # :deliveryPoints
                     hAddress[:deliveryPoints] = xCiAddress.xpath(@@deliveryPntXPath).map(&:text).compact

                     # :city
                     xCity = xCiAddress.xpath(@@cityXPath)
                     hAddress[:city] = xCity.empty? ? nil : xCity[0].text

                     # :adminArea
                     xAdminArea = xCiAddress.xpath(@@adminAreaXPath)
                     hAddress[:adminArea] = xAdminArea.empty? ? nil : xAdminArea[0].text

                     # :postalCode
                     xPostalCode = xCiAddress.xpath(@@postalXPath)
                     hAddress[:postalCode] = xPostalCode.empty? ? nil : xPostalCode[0].text

                     # :country
                     xCountry = xCiAddress.xpath(@@countryXPath)
                     hAddress[:country] = xCountry.empty? ? nil : xCountry[0].text

                     addresses << hAddress

                     # email addresses
                     emails += xCiAddress.xpath(@@emailXPath).map(&:text).compact
                  end

                  [addresses, emails]
               end
            end
         end
      end
   end
end
