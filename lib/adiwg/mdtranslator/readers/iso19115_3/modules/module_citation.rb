# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
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
               def self.unpack(xMetadata, _hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hCitation = intMetadataClass.newCitation

                  id = xMetadata.xpath(ADIWG::Mdtranslator::Readers::Iso191153::CODE_XPATH)
                  cs = xMetadata.xpath(ADIWG::Mdtranslator::Readers::Iso191153::CODESPACE_XPATH)
                  desc = xMetadata.xpath(ADIWG::Mdtranslator::Readers::Iso191153::DESC_XPATH)
                  title = xMetadata.xpath(ADIWG::Mdtranslator::Readers::Iso191153::TITLE_XPATH)

                  hCitation[:title] = title[0].text
                  hCitation[:description] = desc[0].text
                  hCitation[:identifiers] = [{ identifier: id[0].text,
                                               namespace: cs[0].text,
                                               version: nil, # TODO
                                               description: desc[0].text,
                                               citation: {} }]

                  hCitation
               end
            end
         end
      end
   end
end
