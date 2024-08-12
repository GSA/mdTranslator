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

                  # :name (optional)
                  # <element minOccurs="0" name="name" type="gco:CharacterString_PropertyType">
                  # internal contacts need to have a name in order to add them so??
                  xName = xOrg.xpath(@@nameXPath)
                  unless xName.empty?
                     val = xName[0].text
                     hContact[:name] = val
                     contactId = Iso191153.add_contact(val, true)
                     hContact[:contactId] = contactId
                     hContact[:contactName] = val # TODO: revisit this.
                  end

                  # :isOrganization
                  hContact[:isOrganization] = true

                  # :externalIdentifier
                  # <element maxOccurs="unbounded" minOccurs="0" name="partyIdentifier"
                  # type="mcc:MD_Identifier_PropertyType">
                  xOrgPartyId = xOrg.xpath(@@partyIdXPath)
                  hContact[:externalIdentifier] = xOrgPartyId.map { |i| Identification.unpack(i, hResponseObj)[0] }

                  # individual - contact information [] (only one contactInfo supported in this implementation)
                  # <element maxOccurs="unbounded" minOccurs="0" name="contactInfo" type="cit:CI_Contact_PropertyType">
                  # the schema indicates contactInfo can be an array but the implementation is only 1? keeping it at 1.
                  xContactInfo = xOrg.xpath(@@contactInfoXPath)[0]
                  contactData = Contact.unpack(xContactInfo, hResponseObj) unless xContactInfo.nil?
                  hContact = AdiwgUtils.reconcile_hashes(contactData, hContact) unless contactData.nil?

                  # :logos
                  xLogos = xOrg.xpath(@@logoXPath)
                  xLogos.each do |xlogo|
                     hContact[:logos] << BrowseGraphic.unpack(xlogo, hResponseObj)
                  end

                  Iso191153.set_contact(hContact)

                  hContact
               end
            end
         end
      end
   end
end
