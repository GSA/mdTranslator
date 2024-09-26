# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module UseConstraint
               @@useConstraintXPath = 'gmd:MD_Constraints'
               @@useLimitationXPath = 'gmd:useLimitation//gco:CharacterString'
               @@type = 'use'
               def self.unpack(xConstraint, _hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hConstraint = intMetadataClass.newConstraint

                  xUseConstraint = xConstraint.xpath(@@useConstraintXPath)[0]
                  return nil if xUseConstraint.nil?

                  hConstraint[:type] = @@type

                  # useLimitation (optional)
                  # <xs:element name="useLimitation" type="gco:CharacterString_PropertyType" minOccurs="0"
                  # maxOccurs="unbounded"/>
                  xUseLimitations = xUseConstraint.xpath(@@useLimitationXPath)
                  hConstraint[:useLimitation] = xUseLimitations.map(&:text).compact

                  hConstraint
               end
            end
         end
      end
   end
end
