# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require 'adiwg/mdtranslator/readers/iso19115_3/iso19115_3_reader'
require_relative 'module_extent'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Responsibility
               @@contactXpath = 'mdb:contact'
               @@respbltyXpath = 'cit:CI_Responsibility'
               @@roleCodeXpath = 'cit:role//cit:CI_RoleCode'
               def self.process_responsibility(xContact, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hRespblty = intMetadataClass.newResponsibility

                  xRespblty = xContact.xpath(@@respbltyXpath)[0]

                  # CI_Responsibility is required
                  if xRespblty.nil?
                     msg = 'ERROR: ISO19115-3 reader: element \'cit:CI_Responsibility\' is missing in mdb:contact'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionePass] = false

                     return hRespblty
                  end

                  xRoleCode = xRespblty.xpath(@@roleCodeXpath)[0]

                  if xRoleCode.nil?
                     msg = 'ERROR: ISO19115-3 reader: element \'cit:role\' is missing in cit:CI_Responsibility'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionePass] = false

                     return hRespblty
                  end

                  codeListValue = ADIWG::Mdtranslator::Readers::Iso191153::CODELISTVALUE

                  # :roleName
                  hRespblty[:roleName] = xRoleCode.attr(codeListValue)

                  # :roleExtents # TODO
                  hRespblty[:roleExtents] = Extent.unpack(xRespblty, hResponseObj)

                  # :parties # TODO

                  hRespblty
               end

               def self.unpack(xMetadata, hResponseObj)
                  xContacts = xMetadata.xpath(@@contactXpath)

                  # contact is required
                  if xContacts.empty?
                     msg = 'ERROR: ISO19115-3 reader: element \'mdb:contact\' is missing in mdb:metadataIdentifier'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionePass] = false
                  end

                  xContacts.map { |c| process_responsibility(c, hResponseObj) }
               end
            end
         end
      end
   end
end
