# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require 'adiwg/mdtranslator/internal/module_utils'
require_relative 'module_date'
require_relative 'module_responsibility'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module Citation
               @@citationXpath = 'gmd:CI_Citation'
               @@titleXPath = 'gmd:title//gco:CharacterString'
               @@dateXPath = 'gmd:date'
               @@responsibilityXPath = 'gmd:citedResponsibleParty'
               def self.unpack(xCitationParent, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hCitation = intMetadataClass.newCitation

                  xCitation = xCitationParent.xpath(@@citationXpath)[0]
                  if xCitation.nil?
                     msg = "WARNING: ISO19115-2 reader: element \'#{@@citationXpath}\' "\
                        "is missing in \'#{xCitationParent.name}\'"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return hCitation
                  end

                  return hCitation if xCitation.nil?

                  # :title (required)
                  # <xs:element name="title" type="gco:CharacterString_PropertyType"/>
                  title = xCitation.xpath(@@titleXPath)[0]
                  if title.nil?
                     msg = "WARNING: ISO19115-2 reader: element \'#{@@titleXPath}\' "\
                        "is missing in \'#{xCitation.name}\'"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return hCitation
                  end

                  hCitation[:title] = title.text

                  # :dates (required)
                  # <xs:element name="date" type="gmd:CI_Date_PropertyType" maxOccurs="unbounded"/>
                  xDates = xCitation.xpath(@@dateXPath)
                  if xDates.empty?
                     msg = "WARNING: ISO19115-2 reader: element \'#{@@dateXPath}\' "\
                        "is missing in \'#{xCitation.name}\'"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return hCitation
                  end

                  hCitation[:dates] = xDates.map { |d| Date.unpack(d, hResponseObj) }

                  # <xs:element name="citedResponsibleParty"
                  # type="gmd:CI_ResponsibleParty_PropertyType" minOccurs="0" maxOccurs="unbounded"/>
                  xResponsibleParties = xCitation.xpath(@@responsibilityXPath)
                  hCitation[:responsibleParties] = xResponsibleParties.map do |r|
                     Responsibility.unpack(r, hResponseObj)
                  end

                  hCitation[:responsibleParties] = hCitation[:responsibleParties].compact

                  # responsible parties are grouped by role (see class_citation:121 in iso19115-2 writer)
                  hCitation[:responsibleParties] =
                     AdiwgUtils.consolidate_iso191152_rparties(hCitation[:responsibleParties]).compact

                  hCitation
               end
            end
         end
      end
   end
end
