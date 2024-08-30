# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_citation'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module ResourceInformation
               @@mdIdentifierCitationXPath = 'gmd:citation'
               def self.unpack(xDataIdentification, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hResourceInfo = intMetadataClass.newResourceInfo

                  # :citation (required)
                  # <xs:element name="citation" type="gmd:CI_Citation_PropertyType"/>
                  xCitation = xDataIdentification.xpath(@@mdIdentifierCitationXPath)[0]
                  if xCitation.nil?
                     msg = "WARNING: ISO19115-2 reader: element \'#{@@mdIdentifierCitationXPath}\' " \
                     "is missing in #{xDataIdentification.name}"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return hResourceInfo
                  end

                  hResourceInfo[:citation] = Citation.unpack(xCitation, hResponseObj)

                  hResourceInfo
               end
            end
         end
      end
   end
end
