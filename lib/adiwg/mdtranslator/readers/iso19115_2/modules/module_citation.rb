# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_date'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module Citation
               @@citationXpath = 'gmd:CI_Citation'
               @@titleXPath = 'gmd:title//gco:CharacterString'
               @@dateXPath = 'gmd:date'
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

                  hCitation
               end
            end
         end
      end
   end
end
