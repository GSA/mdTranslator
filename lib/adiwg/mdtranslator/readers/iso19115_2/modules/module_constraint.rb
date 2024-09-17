# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_legal_constraint'
require_relative 'module_security_constraint'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module Constraint
               @@legalConstraintXPath = 'gmd:MD_LegalConstraints'
               @@securityConstraintXPath = 'gmd:MD_SecurityConstraints'
               def self.unpack(xConstraint, hResponseObj)
                  # legal constraints
                  xLegalConstraint = xConstraint.xpath(@@legalConstraintXPath)[0]
                  unless xLegalConstraint.nil?
                     return LegalConstraint.unpack(xLegalConstraint, hResponseObj)
                  end

                  # security constraints
                  xSecurityConstraint = xConstraint.xpath(@@securityConstraintXPath)[0]
                  unless xSecurityConstraint.nil?
                     return SecurityConstraint.unpack(xSecurityConstraint, hResponseObj)
                  end
               end
            end
         end
      end
   end
end
