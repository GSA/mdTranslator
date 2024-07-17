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
               @@partyXPath = 'cit:party'
               @@individualXPath = 'cit:CI_Individual'
               @@orgXPath = 'cit:CI_Organisation'
               def self.unpack(xResponsibility, hResponseObj)
                  parties = []

                  xParties = xResponsibility.xpath(@@partyXPath)

                  xParties.each do |xparty|
                     # individual
                     hIndividual = Individual.unpack(xparty, hResponseObj)
                     parties << hIndividual unless hIndividual.nil?

                     # organization
                     hOrg = Organization.unpack(xparty, hResponseObj)
                     parties << hOrg unless hOrg.nil?
                  end
                  parties
               end
            end
         end
      end
   end
end
