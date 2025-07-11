# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require 'adiwg/mdtranslator/internal/module_utils'
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
          @@datestampXPath = 'gmd:dateStamp'
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
            # TODO: we're only getting the first one for times sake
            xContact = xMetadata.xpath(@@contactXPath)[0]
            if xContact.nil?
              msg = "WARNING: ISO19115-2 reader: element \'#{@@contactXPath}\'" \
              " is missing in #{xMetadata.name}"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else

              # CI_ResponsibleParty is optional
              # <xs:sequence minOccurs="0">
              #   <xs:element ref="gmd:CI_ResponsibleParty"/>
              # </xs:sequence>
              xResponsibility = xContact.xpath('gmd:CI_ResponsibleParty')[0]
              xResponsibilityLink = xContact.attr('xlink:href')

              # tries to get the element from the xlink:href attr
              if xResponsibility.nil? && !xResponsibilityLink.nil?
                xResponsibility = AdiwgUtils.convert_xlink_to_elem(xResponsibilityLink)
                xContact.add_child(xResponsibility) unless xResponsibility.nil?
              end

              if xResponsibility.nil? && !AdiwgUtils.valid_nil_reason(xContact, hResponseObj)
                msg = "WARNING: ISO19115-2 reader: element \'#{@@contactXPath}\' "\
                 "is missing valid nil reason within \'#{xMetadata.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end

              unless xResponsibility.nil?
                hMetadataInfo[:metadataContacts] << Responsibility.unpack(xContact, hResponseObj)
                hMetadataInfo[:metadataContacts].compact!
              end
            end

            # :metadataDates (required)
            # <xs:element name="dateStamp" type="gco:Date_PropertyType"/>
            xDatestamp = xMetadata.xpath(@@datestampXPath)[0]
            if xDatestamp.nil?
              msg = "WARNING: ISO19115-2 reader: element \'#{@@datestampXPath}\'" \
              " is missing in #{xMetadata.name}"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else
              # date/datetime is optional
              # <xs:choice minOccurs="0">
              #   <xs:element ref="gco:Date"/>
              #   <xs:element ref="gco:DateTime"/>
              # </xs:choice>
              xDate = xDatestamp.xpath('gco:Date | gco:DateTime')[0]

              if xDate.nil? && !AdiwgUtils.valid_nil_reason(xDatestamp, hResponseObj)
                msg = "WARNING: ISO19115-2 reader: element \'#{@@datestampXPath}\' "\
                 "is missing valid nil reason within \'#{xMetadata.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end

              unless xDate.nil?
                dt = AdiwgDateTimeFun.dateTimeFromString(xDate.text)
                if xDate.name == 'Date'
                  dateData = intMetadataClass.newDate
                  dateData[:date] = dt[0]
                else
                  dateData = intMetadataClass.newDateTime
                  dateData[:dateTime] = dt[0]
                end
                hMetadataInfo[:metadataDates] << dateData
              end
            end
            hMetadataInfo
          end
        end
      end
    end
  end
end
