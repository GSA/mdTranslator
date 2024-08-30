# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module Citation
               @@citationXpath = 'gmd:CI_Citation'
               @@titleXPath = 'gmd:title//gco:CharacterString'
               def self.unpack(xCitationParent, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hCitation = intMetadataClass.newCitation

                  xCitation = xCitationParent.xpath(@@citationXpath)[0]
                  return hCitation if xCitation.nil?

                  # :title (required)
                  # <xs:element name="title" type="gco:CharacterString_PropertyType"/>
                  title = xCitation.xpath(@@titleXPath)[0]
                  if title.nil?
                     msg = "WARNING: ISO19115-2 reader: element \'#{@@citationXpath}\' "\
                        "is missing in \'#{xCitationParent.name}\'"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return hCitation
                  end

                  hCitation[:title] = title.text

                  hCitation
               end
            end
         end
      end
   end
end
