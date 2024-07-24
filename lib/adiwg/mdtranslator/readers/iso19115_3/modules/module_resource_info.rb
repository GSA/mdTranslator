# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_constraint'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module ResourceInformation
               @@constraintsXPath = 'mdb:metadataConstraints'
               def self.unpack(xMetadata, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hResourceInfo = intMetadataClass.newResourceInfo

                  # just doing constraints to satisfy dcatus
                  xMdConstraints = xMetadata.xpath(@@constraintsXPath)
                  aMdConstraints = xMdConstraints.map { |c| Constraint.unpack(c, hResponseObj) }.flatten
                  hResourceInfo[:constraints] = aMdConstraints

                  hResourceInfo
               end
            end
         end
      end
   end
end
