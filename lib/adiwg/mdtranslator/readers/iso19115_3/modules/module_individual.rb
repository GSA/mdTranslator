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

                  # :name
                  xName = xIndividual.xpath(@@nameXPath)
                  hContact[:name] = xName.empty? ? nil : xName[0].text

                  # :positionName
                  xPositionName = xIndividual.xpath(@@positionNameXPath)
                  hContact[:positionName] = xPositionName.empty? ? nil : xPositionName[0].text

                  # :isOrganization
                  hContact[:isOrganization] = false

                  # :externalIdentifier
                  # ( :contactId is second priority in the writer and appears to reflect the same info )
                  xPartyId = xIndividual.xpath(@@partyIdXPath)[0]
                  hContact[:externalIdentifier] = xPartyId.nil? ? nil : Identification.unpack(xPartyId, hResponseObj)

                  # individual - contact information [] (only one contactInfo supported in this implementation)
                  xContactInfo = xIndividual.xpath(@@contactInfoXPath)
                  contactData = Contact.unpack(xContactInfo[0], hResponseObj) unless xContactInfo.empty?

                  return AdiwgUtils.reconcile_hashes(contactData, hContact) unless contactData.nil?

                  hContact
               end
            end
         end
      end
   end
end
