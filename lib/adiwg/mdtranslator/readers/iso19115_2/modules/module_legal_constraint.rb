# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module LegalConstraint
               @@legalConstraintXPath = 'gmd:MD_LegalConstraints'
               @@accessConstraintsXPath = 'gmd:accessConstraints//gmd:MD_RestrictionCode'
               @@useConstraintsXPath = 'gmd:useConstraints//gmd:MD_RestrictionCode'
               @@otherConstraintsXPath = 'gmd:otherConstraints//gco:CharacterString'
               @@type = 'legal'
               def self.unpack(xConstraint, _hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hConstraint = intMetadataClass.newConstraint
                  hLegalConstraint = intMetadataClass.newLegalConstraint

                  xLegalConstraint = xConstraint.xpath(@@legalConstraintXPath)[0]
                  return nil if xLegalConstraint.nil?

                  hConstraint[:type] = @@type

                  # :accessCodes (optional)
                  # <xs:element name="accessConstraints" type="gmd:MD_RestrictionCode_PropertyType"
                  # minOccurs="0" maxOccurs="unbounded"/>
                  xAccessConstraints = xLegalConstraint.xpath(@@accessConstraintsXPath)
                  unless xAccessConstraints.empty?
                     hLegalConstraint[:accessCodes] = xAccessConstraints.map do |a|
                        a.attr('codeListValue')
                     end
                  end

                  # :useCodes (optional)
                  # <xs:element name="useConstraints" type="gmd:MD_RestrictionCode_PropertyType"
                  # minOccurs="0" maxOccurs="unbounded"/>
                  xUseConstraints = xLegalConstraint.xpath(@@useConstraintsXPath)
                  unless @@useConstraintsXPath.empty?
                     hLegalConstraint[:useCodes] = xUseConstraints.map do |u|
                        u.attr('codeListValue')
                     end
                  end

                  # :otherCons (optional)
                  # <xs:element name="otherConstraints" type="gco:CharacterString_PropertyType"
                  # minOccurs="0" maxOccurs="unbounded"/>
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
