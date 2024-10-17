# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module SecurityConstraint
               @@securityConstraintXPath = 'gmd:MD_SecurityConstraints'
               @@classificationXPath = 'gmd:classification//gmd:MD_ClassificationCode'
               @@userNoteXPath = 'gmd:userNote//gco:CharacterString'
               @@classSysXPath = 'gmd:classificationSystem//gco:CharacterString'
               @@handlingXPath = 'gmd:handlingDescription//gco:CharacterString'
               @@type = 'security'
               def self.unpack(xConstraint, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hConstraint = intMetadataClass.newConstraint
                  hSecConstraint = intMetadataClass.newSecurityConstraint

                  xSecurityConstraint = xConstraint.xpath(@@securityConstraintXPath)[0]
                  return nil if xSecurityConstraint.nil?

                  hConstraint[:type] = @@type

                  # :classCode (required)
                  # <xs:element name="classification" type="gmd:MD_ClassificationCode_PropertyType"/>
                  xClassCode = xSecurityConstraint.xpath(@@classificationXPath)[0]
                  if xClassCode.nil?
                     msg = 'WARNING: ISO19115-2 reader: element \'gmd:classification\' '\
                     'is missing in gmd:MD_SecurityConstraints'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  hSecConstraint[:classCode] = xClassCode.attr('codeListValue')

                  # userNote (optional)
                  # <xs:element name="userNote" type="gco:CharacterString_PropertyType" minOccurs="0"/>
                  xUserNote = xSecurityConstraint.xpath(@@userNoteXPath)[0]
                  hSecConstraint[:userNote] = xUserNote.nil? ? nil : xUserNote.text

                  # :classSystem (optional)
                  # <xs:element name="classificationSystem" type="gco:CharacterString_PropertyType" minOccurs="0"/>
                  xClassSys = xSecurityConstraint.xpath(@@classSysXPath)[0]
                  hSecConstraint[:classSystem] = xClassSys.nil? ? nil : xClassSys.text

                  # :handling (optional)
                  # <xs:element name="handlingDescription" type="gco:CharacterString_PropertyType" minOccurs="0"/>
                  xHandling = xSecurityConstraint.xpath(@@handlingXPath)[0]
                  hSecConstraint[:handling] = xHandling.nil? ? nil : xHandling.text

                  hConstraint[:securityConstraint] = hSecConstraint
                  hConstraint
               end
            end
         end
      end
   end
end
