# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191152datagov
        module Responsibility
          @@responsibilityXPath = 'gmd:CI_ResponsibleParty'
          @@individualXPath = 'gmd:individualName//gco:CharacterString'
          @@orgXPath = 'gmd:organisationName//gco:CharacterString'
          @@posXPath = 'gmd:positionName//gco:CharacterString'
          @@roleXPath = 'gmd:role'
          @@emailXPath = './/gmd:electronicMailAddress//gco:CharacterString'
          def self.unpack(xRParty, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hRespblty = intMetadataClass.newResponsibility
            hContact = intMetadataClass.newContact

            # CI_ResponsibleParty (optional)
            # <xs:sequence minOccurs="0">
            #   <xs:element ref="gmd:CI_ResponsibleParty"/>
            # </xs:sequence>
            xRParty = xRParty.xpath(@@responsibilityXPath)[0]
            return nil if xRParty.nil?

            # :roleName (required)
            # <xs:element name="role" type="gmd:CI_RoleCode_PropertyType"/>
            xRole = xRParty.xpath(@@roleXPath)[0]
            if xRole.nil?
              msg = "WARNING: ISO19115-2 reader: element \'#{@@roleXPath}\' "\
                 "is missing in \'#{xRParty.name}\'"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else

              # CI_RoleCode (optional)
              # <xs:sequence minOccurs="0">
              #   <xs:element ref="gmd:CI_RoleCode"/>
              # </xs:sequence>
              xRC = xRole.xpath('gmd:CI_RoleCode')[0]

              if xRC.nil? && !AdiwgUtils.valid_nil_reason(xRole, hResponseObj)
                msg = "WARNING: ISO19115-2 reader: element \'#{xRole.name}\' "\
                 "is missing valid nil reason within \'#{xRParty.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end

              hRespblty[:roleName] = xRC.attr('codeListValue') unless xRC.nil?
            end

            # determine whether an individual or organization contact
            # the schema suggests both can occur. just use the first valid one you find.
            # <xs:element name="individualName" type="gco:CharacterString_PropertyType" minOccurs="0"/>
            # <xs:element name="organisationName" type="gco:CharacterString_PropertyType" minOccurs="0"/
            # >
            # <xs:element name="positionName" type="gco:CharacterString_PropertyType" minOccurs="0"/>
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
              contactTypeFound = true
            end

            xPositionName = xRParty.xpath(@@posXPath)[0]
            if !xPositionName.nil? && contactTypeFound == false
              hContact[:isOrganization] = false
              contactName = xPositionName.text
            end

            unless contactName.nil?
              hContact[:name] = contactName
              contactId = Iso191152datagov.add_contact(contactName, hContact[:isOrganization])
              hContact[:contactId] = contactId
              hContact[:contactName] = contactName # TODO: revisit this.
              hContact[:contactType] = hContact[:isOrganization] ? 'organization' : 'individual'
            end

            # :emailList
            # <xs:element name="electronicMailAddress" type="gco:CharacterString_PropertyType" minOccurs="0"
            # maxOccurs="unbounded"/>
            # TODO: add contact module and address module
            # grabbing the emails directly is an antipattern but
            # we need a way to bubble up that information from my
            # great grandchild
            xEmails = xRParty.xpath(@@emailXPath)
            hContact[:eMailList] = xEmails.map(&:text).compact

            contactIdx = Iso191152datagov.set_contact(hContact)

            hParty = intMetadataClass.newParty
            hParty[:contactId] = hContact[:contactId]
            hParty[:contactIndex] = contactIdx
            hParty[:contactType] = hContact[:contactType]
            hParty[:contactName] = hContact[:contactName]
            # :organizationMembers skipping for now.

            hRespblty[:parties] = [hParty]

            hRespblty
          end
        end
      end
    end
  end
end
