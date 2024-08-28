# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require 'adiwg/mdtranslator/internal/module_utils'
require_relative 'module_contact'
require_relative 'module_identification'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Individual
               @@individualXPath = 'cit:CI_Individual'
               @@nameXPath = 'cit:name//gco:CharacterString'
               @@positionNameXPath = 'cit:positionName//gco:CharacterString'
               @@contactInfoXPath = 'cit:contactInfo'
               @@partyIdXPath = 'cit:partyIdentifier'
               def self.unpack(xParty, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hContact = intMetadataClass.newContact

                  xIndividual = xParty.xpath(@@individualXPath)[0]
                  return nil if xIndividual.nil?

                  # :name (optional)
                  # <element minOccurs="0" name="name" type="gco:CharacterString_PropertyType">
                  # internal contacts need to have a name in order to add them so??
                  xName = xIndividual.xpath(@@nameXPath)
                  unless xName.empty?
                     val = xName[0].text
                     hContact[:name] = val
                     contactId = Iso191153.add_contact(val, false)
                     hContact[:contactId] = contactId
                     hContact[:contactName] = val # TODO: revisit this.
                  end

                  # :positionName (optional)
                  # <element minOccurs="0" name="positionName" type="gco:CharacterString_PropertyType">
                  xPositionName = xIndividual.xpath(@@positionNameXPath)
                  hContact[:positionName] = xPositionName.empty? ? nil : xPositionName[0].text

                  # :isOrganization
                  hContact[:isOrganization] = false

                  # :externalIdentifier
                  # <element maxOccurs="unbounded" minOccurs="0" name="partyIdentifier"
                  # type="mcc:MD_Identifier_PropertyType">
                  xPartyId = xIndividual.xpath(@@partyIdXPath)
                  hContact[:externalIdentifier] = xPartyId.map { |p| Identification.unpack(p, hResponseObj)[0] }

                  # individual - contact information [] (only one contactInfo supported in this implementation)
                  # <element maxOccurs="unbounded" minOccurs="0" name="contactInfo" type="cit:CI_Contact_PropertyType">
                  # the schema indicates contactInfo can be an array but the implementation is only 1? keeping it at 1.
                  xContactInfo = xIndividual.xpath(@@contactInfoXPath)[0]
                  contactData = Contact.unpack(xContactInfo, hResponseObj) unless xContactInfo.nil?
                  hContact = AdiwgUtils.reconcile_hashes(contactData, hContact) unless contactData.nil?

                  Iso191153.set_contact(hContact)

                  hContact
               end
            end
         end
      end
   end
end
