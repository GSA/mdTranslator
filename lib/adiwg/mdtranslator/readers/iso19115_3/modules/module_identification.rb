# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_citation'
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
            module Identification
               @@codeXPath = './/mcc:code//gco:CharacterString'
               @@codeSpaceXpath = './/mcc:codeSpace//gco:CharacterString'
               @@descXpath = './/mcc:description//gco:CharacterString'
               @@versionXpath = './/mcc:version//gco:CharacterString'
               @@authorityXpath = 'mcc:authority'
               @@identifierXpath = 'mcc:MD_Identifier'

               def self.process_id(xIdentifier, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hIdentifier = intMetadataClass.newIdentifier

                  id = xIdentifier.xpath(@@codeXPath)
                  cs = xIdentifier.xpath(@@codeSpaceXpath)
                  desc = xIdentifier.xpath(@@descXpath)
                  version = xIdentifier.xpath(@@versionXpath)

                  # code is required
                  if id.empty?
                     msg = 'WARNING: ISO19115-3 reader: element \'code\' is missing in metadata identifier'
                     hResponseObj[:readerStructureMessages] << msg
                     hResponseObj[:readerStructurePass] = false
                  end

                  hIdentifier[:identifier] = id.empty? ? nil : id[0].text
                  hIdentifier[:namespace] = cs.empty? ? nil : cs[0].text
                  hIdentifier[:version] = version.empty? ? nil : version[0].text
                  hIdentifier[:description] = desc.empty? ? nil : desc[0].text

                  xAuthority = xIdentifier.xpath(@@authorityXpath)
                  hIdentifier[:citation] =
                     xAuthority.empty? ? nil : Citation.unpack(xAuthority[0], hResponseObj)

                  hIdentifier
               end

               def self.unpack(xMetadata, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hIdentifier = intMetadataClass.newIdentifier

                  xIdentifiers = xMetadata.xpath(@@identifierXpath)

                  if xMetadata.name == 'metadataIdentifier' && xIdentifiers.empty?
                     msg = 'WARNING: ISO19115-3 reader: element \'mcc:MD_Identifier\' '\
                        'is missing in metadata identifier'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false

                     hIdentifier
                  end

                  res = xIdentifiers.map { |i| process_id(i, hResponseObj) }
                  return res[0] if xMetadata.name == 'metadataIdentifier'

                  res
               end
            end
         end
      end
   end
end
