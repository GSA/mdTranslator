# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_identification'
require_relative 'module_date'
require_relative 'module_responsibility'
require_relative 'module_online_resource'

# require_relative 'module_citation'
# require_relative 'module_timePeriod'
# require_relative 'module_timeInstant'
# require_relative 'module_spatialDomain'
# require_relative 'module_keyword'
# require_relative 'module_contact'
# require_relative 'module_security'
# require_relative 'module_taxonomy'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Citation
               @@citationXpath = 'cit:CI_Citation'
               @@dateXPath = 'cit:date'
               @@titleXPath = 'cit:title//gco:CharacterString'
               @@alternateTitleXPath = 'cit:alternateTitle//gco:CharacterString'
               @@responsiblePartiesXPath = 'cit:citedResponsibleParty'
               @@citIdXpath = 'cit:identifier'
               @@onlineResourceXPath = 'cit:onlineResource'
               def self.unpack(xCitationParent, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hCitation = intMetadataClass.newCitation

                  # (required)
                  # <element name="CI_Citation" substitutionGroup="mcc:Abstract_Citation" type="cit:CI_Citation_Type">
                  xCitation = xCitationParent.xpath(@@citationXpath)[0]
                  return hCitation if xCitation.nil?

                  # :title (required)
                  # <element name="title" type="gco:CharacterString_PropertyType">
                  title = xCitation.xpath(@@titleXPath)[0]
                  if title.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'cit:title\' '\
                        'is missing in \'cit:CI_Citation\''
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  hCitation[:title] = title.text

                  # :alternateTitles (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="alternateTitle"
                  # type="gco:CharacterString_PropertyType">
                  xAlternateTitle = xCitation.xpath(@@alternateTitleXPath)
                  hCitation[:alternateTitles] = xAlternateTitle.map(&:text).compact

                  # :dates (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="date" type="cit:CI_Date_PropertyType">
                  xDates = xCitation.xpath(@@dateXPath)
                  hCitation[:dates] = xDates.map { |d| Date.unpack(d, hResponseObj) }

                  # :responsibleParties (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="citedResponsibleParty"
                  # type="cit:CI_Responsibility_PropertyType">
                  xResponsibleParties = xCitation.xpath(@@responsiblePartiesXPath)
                  hCitation[:responsibleParties] = xResponsibleParties.map do |r|
                     Responsibility.unpack(r, hResponseObj)
                  end

                  # :onlineResources (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="onlineResource"
                  # type="cit:CI_OnlineResource_PropertyType">
                  xOnlineResources = xCitation.xpath(@@onlineResourceXPath)
                  hCitation[:onlineResources] = xOnlineResources.map { |o| OnlineResource.unpack(o, hResponseObj) }

                  # :identifiers
                  citIds = xCitation.xpath(@@citIdXpath)
                  hCitation[:identifiers] = citIds.map { |c| Identification.unpack(c, hResponseObj) }

                  # TODO: all these other things...
                  #    edition: nil,
                  #    presentationForms: [],
                  #    series: {},
                  #    otherDetails: [],
                  #    browseGraphics: []
                  # }

                  hCitation
               end
            end
         end
      end
   end
end
