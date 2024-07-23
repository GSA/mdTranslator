# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_legal_constraint'
require_relative 'module_common_constraint'
require_relative 'module_security_constraint'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Constraint
               @@commonConstraintXPath = 'mco:MD_Constraints'
               @@legalConstraintXPath = 'mco:MD_LegalConstraints'
               @@securityConstraintXPath = 'mco:MD_SecurityConstraints'
               def self.unpack(xConstraint, hResponseObj)
                  # TODO: revisit this module
                  constraint = CommonConstraint.unpack(xConstraint, hResponseObj)
                  return constraint unless constraint.nil?

                  constraint = LegalConstraint.unpack(xConstraint, hResponseObj)
                  return constraint unless constraint.nil?

                  constraint = SecurityConstraint.unpack(xConstraint, hResponseObj)
                  constraint unless constraint.nil?
               end
            end
         end
      end
   end
end
