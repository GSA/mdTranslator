# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_individual'
require_relative 'module_organization'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Party
               def self.unpack(xParty, hResponseObj)
                  # the `newParty` internal object
                  # TODO: revisit this module
                  # intMetadataClass = InternalMetadata.new
                  # hParty = intMetadataClass.newParty

                  # individual
                  hIndividual = Individual.unpack(xParty, hResponseObj)
                  return hIndividual unless hIndividual.nil?

                  # organization
                  hOrg = Organization.unpack(xParty, hResponseObj)
                  hOrg unless hOrg.nil?
               end
            end
         end
      end
   end
end
