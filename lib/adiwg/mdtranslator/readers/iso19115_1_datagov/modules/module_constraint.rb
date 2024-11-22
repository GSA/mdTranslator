# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_legal_constraint'
require_relative 'module_security_constraint'
require_relative 'module_use_constraint'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191151datagov
        module Constraint
          def self.unpack(xConstraint, hResponseObj)
            # all of these are optional and are siblings so any one of these can occur.
            # <xs:sequence minOccurs="0">
            #     <xs:element ref="gmd:MD_Constraints"/>
            # </xs:sequence>

            # LegalConstraint (optional)
            xLegalConstraint = LegalConstraint.unpack(xConstraint, hResponseObj)
            return xLegalConstraint unless xLegalConstraint.nil?

            # SecurityConstraint (optional)
            xSecurityConstraint = SecurityConstraint.unpack(xConstraint, hResponseObj)
            return xSecurityConstraint unless xSecurityConstraint.nil?

            # UseConstraint (optional)
            xUseConstraint = UseConstraint.unpack(xConstraint, hResponseObj)
            xUseConstraint unless xUseConstraint.nil?
          end
        end
      end
    end
  end
end
