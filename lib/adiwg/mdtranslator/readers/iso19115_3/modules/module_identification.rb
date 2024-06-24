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
         module Iso19115_3

            module Identification
        
               def self.unpack(xMetadata, hResponseObj)
					
				intMetadataClass = InternalMetadata.new
				hIdentifier = intMetadataClass.newIdentifier
                                
				id = xMetadata.xpath(ADIWG::Mdtranslator::Readers::Iso19115_3::CODE_XPATH)
				cs = xMetadata.xpath(ADIWG::Mdtranslator::Readers::Iso19115_3::CODESPACE_XPATH)
				desc = xMetadata.xpath(ADIWG::Mdtranslator::Readers::Iso19115_3::DESC_XPATH)
				title = xMetadata.xpath(ADIWG::Mdtranslator::Readers::Iso19115_3::TITLE_XPATH)

				hIdentifier[:identifier] = id[0].text
				hIdentifier[:namespace] = cs[0].text
				hIdentifier[:version] = nil # TODO
				hIdentifier[:description] = desc[0].text
				hIdentifier[:citation] = nil # TODO

				return hIdentifier

               end

            end

         end
      end
   end
end
