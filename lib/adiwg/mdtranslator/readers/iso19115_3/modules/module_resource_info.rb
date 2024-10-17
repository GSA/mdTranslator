# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_constraint'
require_relative 'module_citation'
require_relative 'module_keyword'
require_relative 'module_extent'
require_relative 'module_responsibility'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module ResourceInformation
               # TODO: reuse idInfo//md_Info paths instead of repeating.
               @@constraintsXPath = 'mri:resourceConstraints'
               @@mdIdentifierCitationXPath = 'mri:citation'
               @@abstractXPath = 'mri:abstract//gco:CharacterString'
               @@keywordsXPath = 'mri:descriptiveKeywords'
               @@extentsXPath = 'mri:extent'
               @@pocXPath = 'mri:pointOfContact'
               def self.unpack(xDataIdentification, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hResourceInfo = intMetadataClass.newResourceInfo

                  # just doing constraints to satisfy dcatus
                  # :constraints (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="resourceConstraints"
                  # type="mcc:Abstract_Constraints_PropertyType"/>
                  xMdConstraints = xDataIdentification.xpath(@@constraintsXPath)
                  aMdConstraints = xMdConstraints.map { |c| Constraint.unpack(c, hResponseObj) }.flatten
                  hResourceInfo[:constraints] = xMdConstraints.empty? ? nil : aMdConstraints

                  # :citation (required)
                  # <element name="citation" type="mcc:Abstract_Citation_PropertyType">
                  xCitation = xDataIdentification.xpath(@@mdIdentifierCitationXPath)[0]
                  if xCitation.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'cit:number\' '\
                     'is missing in cit:phone'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return hResourceInfo
                  end
                  hResourceInfo[:citation] = Citation.unpack(xCitation, hResponseObj)

                  # :abstract (required)
                  # <element name="abstract" type="gco:CharacterString_PropertyType">
                  xAbstract = xDataIdentification.xpath(@@abstractXPath)[0]
                  if xAbstract.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'mri:abstract & gco:CharacterString\' '\
                     'is missing in mri:MD_DataIdentification'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return hResourceInfo
                  end

                  hResourceInfo[:abstract] = xAbstract.nil? ? nil : xAbstract.text

                  # :keywords (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="descriptiveKeywords"
                  # type="mri:MD_Keywords_PropertyType"/>
                  xKeywords = xDataIdentification.xpath(@@keywordsXPath)
                  hResourceInfo[:keywords] = xKeywords.map { |k| Keyword.unpack(k, hResponseObj) }

                  # :extents (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="extent" type="mcc:Abstract_Extent_PropertyType">
                  xExtents = xDataIdentification.xpath(@@extentsXPath)
                  hResourceInfo[:extents] = xExtents.map { |e| Extent.unpack(e, hResponseObj) }

                  # :pointOfContacts (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="pointOfContact"
                  # type="mcc:Abstract_Responsibility_PropertyType">
                  xPointOfContacts = xDataIdentification.xpath(@@pocXPath)
                  hResourceInfo[:pointOfContacts] = xPointOfContacts.map do |poc|
                     Responsibility.unpack(poc, hResponseObj)
                  end

                  hResourceInfo
               end
            end
         end
      end
   end
end
