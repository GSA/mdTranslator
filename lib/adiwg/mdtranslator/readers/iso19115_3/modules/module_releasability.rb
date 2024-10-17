# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_responsibility'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Releasability
               @@releasabilityXPath = 'mco:MD_Releasability'
               @@addresseeXPath = 'mco:addressee'
               @@statementXPath = 'mco:statement//gco:CharacterString'
               @@dissConstraintXPath = 'mco:disseminationConstraints//mco:MD_RestrictionCode'
               def self.unpack(xReleasability, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hRelease = intMetadataClass.newRelease

                  xReleasability = xReleasability.xpath(@@releasabilityXPath)[0]
                  return nil if xReleasability.nil?

                  # :addressee (optional)
                  xAddressee = xReleasability.xpath(@@addresseeXPath)
                  hRelease[:addressee] = xAddressee.map { |a| Responsibility.unpack(a, hResponseObj) }

                  # :statement (optional)
                  xStatement = xReleasability.xpath(@@statementXPath)[0]
                  hRelease[:statement] = xStatement.nil? ? nil : xStatement.text

                  # :disseminationConstraint (optional)
                  hRelease[:disseminationConstraint] = xReleasability.xpath(@@dissConstraintXPath).map do |code|
                     code.attr('codeListValue')
                  end

                  hRelease
               end
            end
         end
      end
   end
end
