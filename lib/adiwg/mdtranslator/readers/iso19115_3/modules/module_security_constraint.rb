# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module SecurityConstraint
               @@securityConstraintXPath = 'mco:MD_SecurityConstraints'
               @@classificationXPath = 'mco:classification//mco:MD_ClassificationCode'
               @@userNoteXPath = 'mco:userNote//gco:CharacterString'
               @@classSysXPath = 'mco:classificationSystem//gco:CharacterString'
               @@handlingXPath = 'mco:handlingDescription//gco:CharacterString'
               @@type = 'security'
               def self.unpack(xSecurityConstraint, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hConstraint = intMetadataClass.newConstraint
                  hSecConstraint = intMetadataClass.newSecurityConstraint

                  hConstraint[:type] = @@type

                  # xSecurityConstraint = xConstraint.xpath(@@securityConstraintXPath)[0]
                  return nil if xSecurityConstraint.nil?

                  # :classCode (required)
                  xClassCode = xSecurityConstraint.xpath(@@classificationXPath)[0]
                  if xClassCode.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'mco:classification\' '\
                     'is missing in mco:MD_SecurityConstraints'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  hSecConstraint[:classCode] = xClassCode.attr('codeListValue')

                  # userNote (optional)
                  xUserNote = xSecurityConstraint.xpath(@@userNoteXPath)[0]
                  hSecConstraint[:userNote] = xUserNote.nil? ? nil : xUserNote.text

                  # :classSystem (optional)
                  xClassSys = xSecurityConstraint.xpath(@@classSysXPath)[0]
                  hSecConstraint[:classSystem] = xClassSys.nil? ? nil : xClassSys.text

                  # :handling (optional)
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
