# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_phone'
require_relative 'module_address'
require_relative 'module_online_resource'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Contact
               @@onlineResourceXPath = 'cit:onlineResource'
               @@contactXpath = 'cit:CI_Contact'
               @@contactTypeXPath = 'cit:contactType//gco:CharacterString'
               @@contactInstXPath = 'cit:contactInstructions//gco:CharacterString'
               @@contactHOSXPath = 'cit:hoursOfService//gco:CharacterString'
               @@phoneXPath = 'cit:phone'
               def self.unpack(xContactInfo, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hContact = intMetadataClass.newContact

                  xContact = xContactInfo.xpath(@@contactXpath)[0]

                  if xContact.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'cit:CI_Contact\' '\
                        'is missing in cit:contactInfo'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return xContact
                  end

                  # :contactType
                  xContactType = xContact.xpath(@@contactTypeXPath)
                  hContact[:contactType] = xContactType.empty? ? nil : xContactType[0].text

                  # :contactInstructions
                  xContactInstructions = xContact.xpath(@@contactInstXPath)
                  hContact[:contactInstructions] = xContactInstructions.empty? ? nil : xContactInstructions[0].text

                  # :hoursOfService
                  xContactHOS = xContact.xpath(@@contactHOSXPath)
                  hContact[:hoursOfService] = xContactHOS.empty? ? nil : xContactHOS[0].text

                  # :phones
                  xPhones = xContact.xpath(@@phoneXPath)
                  hContact[:phones] = xPhones.map { |phone| Telephone.unpack(phone, hResponseObj) }

                  # :addresses & eMailList
                  aAddressData = Address.unpack(xContact, hResponseObj)
                  hContact[:addresses] = aAddressData[0]
                  hContact[:eMailList] = aAddressData[1]

                  # :onlineResources
                  xOnlineResources = xContact.xpath(@@onlineResourceXPath)
                  unless xOnlineResources.empty?
                     hContact[:onlineResources] = xOnlineResources.map { |r| OnlineResource.unpack(r, hResponseObj) }
                  end

                  # memberOfOrgs & logos aren't used in the writer
                  hContact
               end
            end
         end
      end
   end
end
