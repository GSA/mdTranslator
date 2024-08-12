# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require 'adiwg/mdtranslator/readers/iso19115_3/iso19115_3_reader'
require_relative 'module_extent'
require_relative 'module_party'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Responsibility
               @@respbltyXpath = 'cit:CI_Responsibility'
               @@roleCodeXpath = 'cit:role//cit:CI_RoleCode'
               @@extentXPath = 'cit:extent'
               @@partyXPath = 'cit:party'
               def self.unpack(xParent, hResponseObj)
                  # cit:CI_Responsibility can occur in a variety of places
                  # (e.g. mco:addressee, mdb:contact, cit:citedResponsibleParty, mco:responsibleParty )
                  # so that's the reason for the vague arg name "xParent"

                  intMetadataClass = InternalMetadata.new
                  hRespblty = intMetadataClass.newResponsibility

                  xRespblty = xParent.xpath(@@respbltyXpath)[0]
                  return nil if xRespblty.nil?

                  # cit: role (required)
                  # <element name="role" type="cit:CI_RoleCode_PropertyType">
                  xRoleCode = xRespblty.xpath(@@roleCodeXpath)[0]
                  if xRoleCode.nil?
                     msg = 'ERROR: ISO19115-3 reader: element \'cit:role\' is missing in cit:CI_Responsibility'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  codeListValue = ADIWG::Mdtranslator::Readers::Iso191153::CODELISTVALUE
                  hRespblty[:roleName] = xRoleCode.attr(codeListValue)

                  # :roleExtents (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="extent"
                  # type="mcc:Abstract_Extent_PropertyType">
                  xExtents = xRespblty.xpath(@@extentXPath)
                  hRespblty[:roleExtents] = xExtents.map { |e| Extent.unpack(e, hResponseObj) }

                  # :parties (required)
                  # <element maxOccurs="unbounded" name="party" type="cit:AbstractCI_Party_PropertyType"/>
                  xParties = xRespblty.xpath(@@partyXPath)
                  if xParties.empty?
                     msg = 'ERROR: ISO19115-3 reader: element \'cit:party\' is missing in cit:CI_Responsibility'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  hRespblty[:parties] = xParties.map { |p| Party.unpack(p, hResponseObj) }

                  hRespblty
               end
            end
         end
      end
   end
end
