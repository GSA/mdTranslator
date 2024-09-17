# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module LegalConstraint
               # @@legalConstraintXPath = 'gmd:MD_LegalConstraints'
               @@accessConstraintsXPath = 'gmd:accessConstraints//gmd:MD_RestrictionCode'
               @@useConstraintsXPath = 'gmd:useConstraints//gmd:MD_RestrictionCode'
               @@otherConstraintsXPath = 'gmd:otherConstraints//gco:CharacterString'
               @@type = 'legal'
               def self.unpack(xLegalConstraint, _hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hConstraint = intMetadataClass.newConstraint
                  hLegalConstraint = intMetadataClass.newLegalConstraint

                  hConstraint[:type] = @@type

                  # xLegalConstraint = xConstraint.xpath(@@legalConstraintXPath)[0]
                  return nil if xLegalConstraint.nil?

                  # :accessCodes (optional)
                  # <gmd:MD_RestrictionCode codeList="http://mdtranslator.adiwg.org/api/codelists?format=xml#MD_RestrictionCode" codeListValue="access constraint" codeSpace="userCode"/>
                  xAccessConstraints = xLegalConstraint.xpath(@@accessConstraintsXPath)
                  unless xAccessConstraints.empty?
                     hLegalConstraint[:accessCodes] = xAccessConstraints.map do |a|
                        a.attr('codeListValue')
                     end
                  end

                  # :useCodes (optional)
                  # <gmd:MD_RestrictionCode codeList="http://mdtranslator.adiwg.org/api/codelists?format=xml#MD_RestrictionCode" codeListValue="use constraint" codeSpace="userCode"/>
                  xUseConstraints = xLegalConstraint.xpath(@@useConstraintsXPath)
                  unless @@useConstraintsXPath.empty?
                     hLegalConstraint[:useCodes] = xUseConstraints.map do |u|
                        u.attr('codeListValue')
                     end
                  end

                  # :otherCons (optional)
                  # <gco:CharacterString>other constraint</gco:CharacterString>
                  xOtherConstraints = xLegalConstraint.xpath(@@otherConstraintsXPath)
                  hLegalConstraint[:otherCons] = xOtherConstraints.map(&:text).compact unless xOtherConstraints.empty?

                  hConstraint[:legalConstraint] = hLegalConstraint
                  hConstraint
               end
            end
         end
      end
   end
end
