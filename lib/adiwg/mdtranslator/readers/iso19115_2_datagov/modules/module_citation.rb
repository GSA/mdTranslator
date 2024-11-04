# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require 'adiwg/mdtranslator/internal/module_utils'
require_relative 'module_date'
require_relative 'module_responsibility'
require_relative 'module_online_resource'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191152datagov
        module Citation
          @@citationXpath = 'gmd:CI_Citation'
          @@titleXPath = 'gmd:title'
          @@dateXPath = 'gmd:date'
          @@responsibilityXPath = 'gmd:citedResponsibleParty'
          @@onlineResourceXPath = './/gmd:onlineResource'
          def self.unpack(xCitationParent, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hCitation = intMetadataClass.newCitation

            # CI_Citation (optional)
            # <xs:sequence minOccurs="0">
            #   <xs:element ref="gmd:CI_Citation"/>
            # </xs:sequence>
            xCitation = xCitationParent.xpath(@@citationXpath)[0]
            return nil if xCitation.nil?

            # :title (required)
            # <xs:element name="title" type="gco:CharacterString_PropertyType"/>
            xTitle = xCitation.xpath(@@titleXPath)[0]
            if xTitle.nil?
              msg = "WARNING: ISO19115-2 reader: element \'#{@@titleXPath}\' "\
                 "is missing in \'#{xCitation.name}\'"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else

              # all CharacterString are optional
              # <xs:sequence minOccurs="0">
              #   <xs:element ref="gco:CharacterString"/>
              # </xs:sequence>
              xStr = xTitle.xpath('gco:CharacterString')[0]

              if xStr.nil? && !AdiwgUtils.valid_nil_reason(xTitle, hResponseObj)
                msg = "WARNING: ISO19115-2 reader: element \'#{xTitle.name}\' "\
                 "is missing valid nil reason within \'#{xCitation.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end

              hCitation[:title] = xStr.text.strip unless xStr.nil?
            end

            # :dates (required)
            # <xs:element name="date" type="gmd:CI_Date_PropertyType" maxOccurs="unbounded"/>
            xDates = xCitation.xpath(@@dateXPath)
            if xDates.empty?
              msg = "WARNING: ISO19115-2 reader: element \'#{@@dateXPath}\' "\
                "is missing in \'#{xCitation.name}\'"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else
              nilReasons = 0
              xDates.each do |xdate|
                if AdiwgUtils.valid_nil_reason(xdate, hResponseObj)
                  nilReasons += 1
                  next
                end

                hDate = Date.unpack(xdate, hResponseObj)
                hCitation[:dates] << hDate unless hDate.nil?
              end

              if hCitation[:dates].empty? && xDates.size != nilReasons
                msg = "WARNING: ISO19115-2 reader: element \'#{@@dateXPath}\' "\
                "is missing valid nil reason within \'#{xCitation.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end
            end

            # :citedResponsibleParty (optional)
            # <xs:element name="citedResponsibleParty"
            # type="gmd:CI_ResponsibleParty_PropertyType" minOccurs="0" maxOccurs="unbounded"/>
            xResponsibleParties = xCitation.xpath(@@responsibilityXPath)
            hCitation[:responsibleParties] = xResponsibleParties.map do |r|
              Responsibility.unpack(r, hResponseObj)
            end.compact

            # responsible parties are grouped by role (see class_citation:121 in iso19115-2 writer)
            hCitation[:responsibleParties] =
              AdiwgUtils.consolidate_iso191152_rparties(hCitation[:responsibleParties]).compact

            # onlineResource (optional)
            # <xs:element name="onlineResource" type="gmd:CI_OnlineResource_PropertyType" minOccurs="0"/>
            # this is actually in "CI_Contact_Type". TODO: revisit.
            xOnlineResource = xCitation.xpath(@@onlineResourceXPath)[0]
            unless xOnlineResource.nil?
              hCitation[:onlineResources] = [OnlineResource.unpack(xOnlineResource, hResponseObj)]
            end

            hCitation
          end
        end
      end
    end
  end
end
