# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_releasability'
require_relative 'module_scope'
require_relative 'module_browse_graphic'
require_relative 'module_citation'
require_relative 'module_responsibility'

require 'debug'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module CommonConstraint
               @@constraintXPath = 'mco:MD_Constraints'
               @@releaseXPath = 'mco:releasability'
               @@responsiblePartyXPath = 'mco:responsibleParty'
               @@useLimitationXPath = 'mco:useLimitation//gco:CharacterString'
               @@appScopeXPath = 'mco:constraintApplicationScope'
               @@graphicXPath = 'mco:graphic'
               @@referenceXPath = 'mco:reference'
               @@releasabilityXPath = 'mco:releasability'
               @@type = 'use'
               def self.unpack(xConstraint, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hConstraint = intMetadataClass.newConstraint

                  xCommonConstraint = xConstraint.xpath(@@constraintXPath)[0]
                  return nil if xCommonConstraint.nil?

                  # :type (internal)
                  hConstraint[:type] = @@type

                  # :useLimitation (optional)
                  hConstraint[:useLimitation] = xCommonConstraint.xpath(@@useLimitationXPath).map(&:text).compact

                  # :scope (optional)
                  xAppScope = xCommonConstraint.xpath(@@appScopeXPath)[0]
                  hConstraint[:scope] = xAppScope.nil? ? nil : Scope.unpack(xAppScope, hResponseObj)

                  # :graphic (optional)
                  xGraphics = xCommonConstraint.xpath(@@graphicXPath)
                  hConstraint[:graphic] = xGraphics.map { |g| BrowseGraphic.unpack(g, hResponseObj) }

                  # :reference (optional)
                  xReferences = xCommonConstraint.xpath(@@referenceXPath)
                  hConstraint[:reference] = xReferences.map { |r| Citation.unpack(r, hResponseObj) }

                  # :releasability (optional)
                  xReleasability = xCommonConstraint.xpath(@@releasabilityXPath)[0]
                  hConstraint[:releasability] =
                     xReleasability.nil? ? nil : Releasability.unpack(xReleasability, hResponseObj)

                  # :responsibleParty(optional)
                  xResponsibleParties = xCommonConstraint.xpath(@@responsiblePartyXPath)
                  hConstraint[:responsibleParty] = xResponsibleParties.map do |p|
                     Responsibility.unpack(p, hResponseObj)
                  end

                  # :legalConstraint (not processed by the writer)

                  hConstraint
               end
            end
         end
      end
   end
end
