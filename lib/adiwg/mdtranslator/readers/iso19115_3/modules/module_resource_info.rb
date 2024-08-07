# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_constraint'
require_relative 'module_citation'
require_relative 'module_keyword'
require_relative 'module_extent'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module ResourceInformation
               # TODO: reuse idInfo//md_Info paths instead of repeating.
               @@constraintsXPath = 'mdb:identificationInfo//mri:MD_DataIdentification//mri:resourceConstraints'
               @@mdIdentifierCitationXPath = 'mdb:identificationInfo//mri:MD_DataIdentification//mri:citation'
               @@abstractXPath = 'mdb:identificationInfo//mri:MD_DataIdentification//mri:abstract//gco:CharacterString'
               @@keywordsXPath = 'mdb:identificationInfo//mri:MD_DataIdentification//mri:descriptiveKeywords'
               @@extentsXPath = 'mdb:identificationInfo//mri:MD_DataIdentification//mri:extent'
               def self.unpack(xMetadata, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hResourceInfo = intMetadataClass.newResourceInfo

                  # just doing constraints to satisfy dcatus
                  # :constraints
                  xMdConstraints = xMetadata.xpath(@@constraintsXPath)
                  aMdConstraints = xMdConstraints.map { |c| Constraint.unpack(c, hResponseObj) }.flatten
                  hResourceInfo[:constraints] = aMdConstraints

                  # :citation
                  xCitation = xMetadata.xpath(@@mdIdentifierCitationXPath)
                  hResourceInfo[:citation] = Citation.unpack(xCitation, hResponseObj)

                  # :abstract
                  xAbstract = xMetadata.xpath(@@abstractXPath)[0]
                  hResourceInfo[:abstract] = xAbstract.nil? ? nil : xAbstract.text

                  # :keywords
                  xKeywords = xMetadata.xpath(@@keywordsXPath)
                  hResourceInfo[:keywords] = xKeywords.map { |k| Keyword.unpack(k, hResponseObj) }

                  # :extents
                  xExtents = xMetadata.xpath(@@extentsXPath)
                  hResourceInfo[:extents] = xExtents.map { |e| Extent.unpack(e, hResponseObj) }

                  hResourceInfo
               end
            end
         end
      end
   end
end
