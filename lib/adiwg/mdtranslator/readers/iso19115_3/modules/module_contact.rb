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

                  return nil if xContact.nil?

                  # :contactType (optional)
                  # <element minOccurs="0" name="contactType" type="gco:CharacterString_PropertyType"/>
                  xContactType = xContact.xpath(@@contactTypeXPath)[0]
                  hContact[:contactType] = xContactType.nil? ? nil : xContactType.text

                  # :contactInstructions (optional)
                  # <element minOccurs="0" name="contactInstructions"
                  # type="gco:CharacterString_PropertyType">
                  xContactInstructions = xContact.xpath(@@contactInstXPath)[0]
                  hContact[:contactInstructions] = xContactInstructions.nil? ? nil : xContactInstructions.text

                  # :hoursOfService (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="hoursOfService"
                  # type="gco:CharacterString_PropertyType">
                  xContactHOS = xContact.xpath(@@contactHOSXPath)
                  hContact[:hoursOfService] = xContactHOS.map(&:text).compact

                  # :phones (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="phone" type="cit:CI_Telephone_PropertyType">
                  xPhones = xContact.xpath(@@phoneXPath)
                  hContact[:phones] = xPhones.map { |phone| Telephone.unpack(phone, hResponseObj) }

                  # :addresses (optional) & eMailList
                  # <element maxOccurs="unbounded" minOccurs="0" name="address" type="cit:CI_Address_PropertyType">
                  # ^ this applies to both physical and electronic addresses
                  aAddressData = Address.unpack(xContact, hResponseObj)
                  hContact[:addresses] = aAddressData[0]
                  hContact[:eMailList] = aAddressData[1]

                  # :onlineResources (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="onlineResource"
                  # type="cit:CI_OnlineResource_PropertyType">
                  xOnlineResources = xContact.xpath(@@onlineResourceXPath)
                  unless xOnlineResources.empty?
                     hContact[:onlineResources] = xOnlineResources.map { |r| OnlineResource.unpack(r, hResponseObj) }
                  end

                  # contactId: nil,
                  # isOrganization: false,
                  # name: nil,
                  # externalIdentifier: [],
                  # positionName: nil,
                  # memberOfOrgs: [],
                  # logos: [],
                  # phones: [],
                  # addresses: [],
                  # eMailList: [],
                  # onlineResources: [],
                  # hoursOfService: [],
                  # contactInstructions: nil,
                  # contactType: nil

                  # memberOfOrgs & logos aren't used in the writer
                  hContact
               end
            end
         end
      end
   end
end
