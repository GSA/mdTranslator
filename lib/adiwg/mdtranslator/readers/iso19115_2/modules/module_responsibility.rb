# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module Responsibility
               @@responsibilityXPath = 'gmd:CI_ResponsibleParty'
               @@individualXPath = 'gmd:individualName//gco:CharacterString'
               @@orgXPath = 'gmd:organisationName//gco:CharacterString'
               @@roleCodeXPath = 'gmd:role//gmd:CI_RoleCode'
               @@emailXPath = './/gmd:electronicMailAddress//gco:CharacterString'
               def self.unpack(xRParty, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hRespblty = intMetadataClass.newResponsibility
                  hContact = intMetadataClass.newContact

                  xRParty = xRParty.xpath(@@responsibilityXPath)[0]
                  return nil if xRParty.nil?

                  # :roleName (required)
                  # <xs:element name="role" type="gmd:CI_RoleCode_PropertyType"/>
                  xRoleCode = xRParty.xpath(@@roleCodeXPath)[0]

                  if xRoleCode.nil?
                     msg = "WARNING: ISO19115-2 reader: element \'#{@@roleCodeXPath}\' "\
                        "is missing in \'#{xRParty.name}\'"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  hRespblty[:roleName] = xRoleCode.attr('codeListValue')

                  # determine whether an individual or organization contact
                  # the schema suggests both can occur. just use the first valid one you find.
                  # <xs:element name="individualName" type="gco:CharacterString_PropertyType" minOccurs="0"/>
                  # <xs:element name="organisationName" type="gco:CharacterString_PropertyType" minOccurs="0"/
                  # >
                  xOrgName = xRParty.xpath(@@orgXPath)[0]
                  contactTypeFound = false
                  contactName = nil

                  unless xOrgName.nil?
                     hContact[:isOrganization] = true
                     contactName = xOrgName.text
                     contactTypeFound = true
                  end

                  xIndividual = xRParty.xpath(@@individualXPath)[0]
                  if !xIndividual.nil? && contactTypeFound == false
                     hContact[:isOrganization] = false
                     contactName = xIndividual.text
                  end

                  if contactName.nil?
                     # TODO: revisit this. this seems like the right decision.
                     # talk to chris about this. can there a responsibility party without an i or o?
                     # this may need to be elevated to an error not a warning.
                     msg = "WARNING: ISO19115-2 reader: \'#{@@responsibilityXPath}\' must have at " \
                     'least an individual or organization. neither are present.'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  else
                     hContact[:name] = contactName
                     contactId = Iso191152.add_contact(contactName, hContact[:isOrganization])
                     hContact[:contactId] = contactId
                     hContact[:contactName] = contactName # TODO: revisit this.
                     hContact[:contactType] = hContact[:isOrganization] ? 'organization' : 'individual'
                  end

                  # :emailList
                  # <xs:element name="electronicMailAddress" type="gco:CharacterString_PropertyType" minOccurs="0"
                  # maxOccurs="unbounded"/>
                  xEmails = xRParty.xpath(@@emailXPath)
                  hContact[:eMailList] = xEmails.map(&:text).compact

                  Iso191152.set_contact(hContact)

                  hRespblty[:parties] = [hContact]

                  hRespblty
               end
            end
         end
      end
   end
end
