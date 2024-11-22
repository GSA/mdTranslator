# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191151datagov
        module SecurityConstraint
          @@securityConstraintXPath = 'gmd:MD_SecurityConstraints'
          @@classificationXPath = 'gmd:classification'
          @@userNoteXPath = 'gmd:userNote//gco:CharacterString'
          @@classSysXPath = 'gmd:classificationSystem//gco:CharacterString'
          @@handlingXPath = 'gmd:handlingDescription//gco:CharacterString'
          @@type = 'security'
          def self.unpack(xConstraint, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hConstraint = intMetadataClass.newConstraint
            hSecConstraint = intMetadataClass.newSecurityConstraint

            # see module_constraint for requirement info
            xSecurityConstraint = xConstraint.xpath(@@securityConstraintXPath)[0]
            return nil if xSecurityConstraint.nil?

            hConstraint[:type] = @@type

            # :classCode (required)
            # <xs:element name="classification" type="gmd:MD_ClassificationCode_PropertyType"/>
            xClass = xSecurityConstraint.xpath(@@classificationXPath)[0]
            if xClass.nil?
              msg = 'WARNING: ISO19115-1 reader: element \'gmd:classification\' '\
              'is missing in gmd:MD_SecurityConstraints'
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else

              # MD_ClassificationCode (optional)
              # <xs:sequence minOccurs="0">
              #   <xs:element ref="gmd:MD_ClassificationCode"/>
              # </xs:sequence>
              xClassCode = xClass.xpath('gmd:MD_ClassificationCode')[0]

              if xClassCode.nil? && !AdiwgUtils.valid_nil_reason(xClass, hResponseObj)
                msg = "WARNING: ISO19115-1 reader: element \'#{xClass.name}\' "\
                 "is missing valid nil reason within \'#{xSecurityConstraint.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end

              hSecConstraint[:classCode] = xClassCode.attr('codeListValue') unless xClassCode.nil?
            end

            # userNote (optional)
            # <xs:element name="userNote" type="gco:CharacterString_PropertyType" minOccurs="0"/>
            xUserNote = xSecurityConstraint.xpath(@@userNoteXPath)[0]
            hSecConstraint[:userNote] = xUserNote.text unless xUserNote.nil?

            # :classSystem (optional)
            # <xs:element name="classificationSystem" type="gco:CharacterString_PropertyType" minOccurs="0"/>
            xClassSys = xSecurityConstraint.xpath(@@classSysXPath)[0]
            hSecConstraint[:classSystem] = xClassSys.text unless xClassSys.nil?

            # :handling (optional)
            # <xs:element name="handlingDescription" type="gco:CharacterString_PropertyType" minOccurs="0"/>
            xHandling = xSecurityConstraint.xpath(@@handlingXPath)[0]
            hSecConstraint[:handling] = xHandling.text unless xHandling.nil?

            hConstraint[:securityConstraint] = hSecConstraint
            hConstraint
          end
        end
      end
    end
  end
end
