# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_contact'
require_relative 'module_identification'
require_relative 'module_browse_graphic'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Organization
               @@nameXPath = 'cit:name//gco:CharacterString'
               @@orgXPath = 'cit:CI_Organisation'
               @@contactInfoXPath = 'cit:contactInfo'
               @@partyIdXPath = 'cit:partyIdentifier'
               @@logoXPath = 'cit:logo'

               def self.unpack(xParty, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hContact = intMetadataClass.newContact

                  # TODO: look into why i may need to use individual
                  # individualClass = CI_Individual.new(@xml, @hResponseObj)

                  xOrg = xParty.xpath(@@orgXPath)[0]
                  return nil if xOrg.nil?

                  # :name
                  xName = xOrg.xpath(@@nameXPath)
                  hContact[:name] = xName.empty? ? nil : xName[0].text

                  # :isOrganization
                  hContact[:isOrganization] = true

                  # :externalIdentifier
                  # ( :contactId is second priority in the writer and appears to reflect the same info )
                  xOrgPartyId = xOrg.xpath(@@partyIdXPath)[0]
                  hContact[:externalIdentifier] =
                     xOrgPartyId.nil? ? nil : Identification.unpack(xOrgPartyId, hResponseObj)

                  # individual - contact information [] (only one contactInfo supported in this implementation)
                  xContactInfo = xOrg.xpath(@@contactInfoXPath)
                  contactData = Contact.unpack(xContactInfo[0], hResponseObj) unless xContactInfo.empty?

                  hContact = AdiwgUtils.reconcile_hashes(contactData, hContact)

                  # :logos
                  xLogos = xOrg.xpath(@@logoXPath)
                  xLogos.each do |xlogo|
                     hContact[:logos] << BrowseGraphic.unpack(xlogo, hResponseObj)
                  end

                  # :memberOfOrgs TODO

                  hContact
               end
            end
         end
      end
   end
end
