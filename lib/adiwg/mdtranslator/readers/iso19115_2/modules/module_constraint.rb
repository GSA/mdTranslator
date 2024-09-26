# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_legal_constraint'
require_relative 'module_security_constraint'
require_relative 'module_use_constraint'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module Constraint
               def self.unpack(xConstraint, hResponseObj)
                  # the requirement of these is inherited from the parent since
                  # a constraint can be 1 of 3 types
                  # for example, gmd:resourceConstraints is optional under
                  # gmd:MD_DataIdentification so all of these are optional

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
