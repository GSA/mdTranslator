# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_identification'
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
               @@titleXPath = 'cit:title//gco:CharacterString'
               @@citIdXpath = 'cit:identifier'
               def self.unpack(xCitationParent, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hCitation = intMetadataClass.newCitation

                  xCitation = xCitationParent.xpath(@@citationXpath)
                  return hCitation if xCitation.empty?

                  xCitation = xCitation[0]

                  # :title
                  title = xCitation.xpath(@@titleXPath)
                  hCitation[:title] = title.empty? ? nil : title[0].text

                  # :identifiers
                  citId = xCitation.xpath(@@citIdXpath)
                  hCitation[:identifiers] = citId.empty? ? [] : Identification.unpack(citId[0], hResponseObj)

                  # TODO: rest of the hCitation properties!

                  hCitation
               end
            end
         end
      end
   end
end
