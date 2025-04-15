# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_maintenance'
require_relative 'module_locale'
require_relative 'module_responsibility'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191152datagov
        module MetadataInformation
          @@fileIdentifierXPath = 'gmd:fileIdentifier//gco:CharacterString'
          @@parentIdentifierXPath = 'gmd:parentIdentifier//gco:CharacterString'
          @@maintenanceXPath = 'gmd:metadataMaintenance'
          @@localeXPath = 'gmd:locale'
          @@contactXPath = 'gmd:contact'
          def self.unpack(xMetadata, hResponseObj)
            # instance classes needed in script
            intMetadataClass = InternalMetadata.new
            hMetadataInfo = intMetadataClass.newMetadataInfo

            # file identifier (optional)
            # <xs:element name="fileIdentifier" type="gco:CharacterString_PropertyType" minOccurs="0"/>
            fileIdentifier = xMetadata.xpath(@@fileIdentifierXPath)[0]
            hMetadataInfo[:metadataIdentifier][:identifier] = fileIdentifier.text unless fileIdentifier.nil?

            # :parent identifier (optional)
            # <xs:element name="parentIdentifier" type="gco:CharacterString_PropertyType" minOccurs="0"/>
            parentIdentifier = xMetadata.xpath(@@parentIdentifierXPath)[0]
            unless parentIdentifier.nil?
              hMetadataInfo[:parentMetadata][:identifier] =
                [{ "identifier": parentIdentifier.text }]
            end

            # :metadataMaintenance (optional)
            # <xs:element name="metadataMaintenance"
            #   type="gmd:MD_MaintenanceInformation_PropertyType" minOccurs="0"/>
            xMaintenance = xMetadata.xpath(@@maintenanceXPath)[0]
            unless xMaintenance.nil?
              hMetadataInfo[:metadataMaintenance] =
                Maintenance.unpack(xMaintenance, hResponseObj)
            end

            # :locale (optional)
            # <xs:element name="language" type="gco:CharacterString_PropertyType" minOccurs="0"/>
            xLocale = xMetadata.xpath(@@localeXPath)
            hMetadataInfo[:defaultMetadataLocale] = Locale.unpack(xLocale, hResponseObj) unless xLocale.nil?

            # :metadataContacts (required)
            # <xs:element name="contact" type="gmd:CI_ResponsibleParty_PropertyType" maxOccurs="unbounded"/>
            # TODO: we're just grabbing the first one for times sake.
            xContact = xMetadata.xpath(@@contactXPath)[0]
            if xContact.nil?
              msg = "WARNING: ISO19115-2 reader: element \'#{@@contactXPath}\'" \
              " is missing in #{xMetadata.name}"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else
              hMetadataInfo[:metadataContacts] = [Responsibility.unpack(xContact, hResponseObj)]
            end
            hMetadataInfo
          end
        end
      end
    end
  end
end
