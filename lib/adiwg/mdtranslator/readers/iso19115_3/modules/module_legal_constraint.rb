# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module LegalConstraint
               # @@legalConstraintXPath = 'mco:MD_LegalConstraints'
               @@accessConstraintsXPath = 'mco:accessConstraints//mco:MD_RestrictionCode'
               @@useConstraintsXPath = 'mco:useConstraints//mco:MD_RestrictionCode'
               @@otherConstraintsXPath = 'mco:otherConstraints//gco:CharacterString'
               @@type = 'legal'
               def self.unpack(xLegalConstraint, _hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hConstraint = intMetadataClass.newConstraint
                  hLegalConstraint = intMetadataClass.newLegalConstraint

                  hConstraint[:type] = @@type

                  # xLegalConstraint = xConstraint.xpath(@@legalConstraintXPath)[0]
                  return nil if xLegalConstraint.nil?

                  # :accessCodes (optional)
                  xAccessConstraints = xLegalConstraint.xpath(@@accessConstraintsXPath)
                  unless xAccessConstraints.empty?
                     hLegalConstraint[:accessCodes] = xAccessConstraints.map do |a|
                        a.attr('codeListValue')
                     end
                  end

                  # :useCodes (optional)
                  xUseConstraints = xLegalConstraint.xpath(@@useConstraintsXPath)
                  unless @@useConstraintsXPath.empty?
                     hLegalConstraint[:useCodes] = xUseConstraints.map do |u|
                        u.attr('codeListValue')
                     end
                  end

                  # :otherCons (optional)
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
