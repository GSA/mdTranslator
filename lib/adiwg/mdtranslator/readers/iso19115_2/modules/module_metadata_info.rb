require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_maintenance'
require_relative 'module_locale'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module MetadataInformation
               @@fileIdentifierXPath = 'gmd:fileIdentifier//gco:CharacterString'
               @@parentIdentifierXPath = 'gmd:parentIdentifier//gco:CharacterString'
               @@maintenanceXPath = 'gmd:metadataMaintenance'
               @@localeXPath = 'gmd:locale'

               def self.unpack(xMetadata, hResponseObj)

                  # instance classes needed in script
                  intMetadataClass = InternalMetadata.new
                  hMetadataInfo = intMetadataClass.newMetadataInfo

                  # <xs:element name="fileIdentifier" type="gco:CharacterString_PropertyType" minOccurs="0"/>
                  fileIdentifier = xMetadata.xpath(@@fileIdentifierXPath)[0]
                  hMetadataInfo[:metadataIdentifier][:identifier] = fileIdentifier.text unless fileIdentifier.nil?

                  # <xs:element name="parentIdentifier" type="gco:CharacterString_PropertyType" minOccurs="0"/>
                  parentIdentifier = xMetadata.xpath(@@parentIdentifierXPath)[0]
                  hMetadataInfo[:parentMetadata][:identifier] = [{"identifier":parentIdentifier.text}] unless parentIdentifier.nil?

                  # <xs:element name="metadataMaintenance" type="gmd:MD_MaintenanceInformation_PropertyType" minOccurs="0"/>
                  xMaintenance = xMetadata.xpath(@@maintenanceXPath)[0]
                  hMetadataInfo[:metadataMaintenance] = Maintenance.unpack(xMaintenance, hResponseObj) unless xMaintenance.nil?

                  # :locale (optional)
                  # <xs:element name="language" type="gco:CharacterString_PropertyType" minOccurs="0"/>
                  xLocale = xMetadata.xpath(@@localeXPath)
                  hMetadataInfo[:defaultMetadataLocale] = Locale.unpack(xLocale, hResponseObj) unless xLocale.nil?

                  return hMetadataInfo

               end

            end

         end
      end
   end
end
