require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module MetadataInformation
               @@fileIdentifierXPath = 'gmd:fileIdentifier//gco:CharacterString'
               @@parentIdentifierXPath = 'gmd:parentIdentifier//gco:CharacterString'
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

                  return hMetadataInfo

               end

            end

         end
      end
   end
end
