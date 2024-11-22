# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_citation'
require_relative 'module_keyword'
require_relative 'module_responsibility'
require_relative 'module_constraint'
require_relative 'module_extent'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191151datagov
        module DataIdentification
          @@dataIdentificationXPath = 'gmd:MD_DataIdentification'
          @@mdIdentifierCitationXPath = 'gmd:citation'
          @@abstractXPath = 'gmd:abstract'
          @@keywordsXPath = 'gmd:descriptiveKeywords'
          @@pointOfContactXPath = 'gmd:pointOfContact'
          @@constraintsXPath = 'gmd:resourceConstraints'
          @@extentsXPath = 'gmd:extent'
          def self.unpack(xIdentificationInfo, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hResourceInfo = intMetadataClass.newResourceInfo

            # MD_DataIdentification (optional)
            # <xs:sequence minOccurs="0">
            #   <xs:element ref="gmd:MD_DataIdentification"/>
            # </xs:sequence>
            xDataIdentification = xIdentificationInfo.xpath(@@dataIdentificationXPath)[0]
            return nil if xDataIdentification.nil?

            # :citation (required)
            # <xs:element name="citation" type="gmd:CI_Citation_PropertyType"/>
            xCitation = xDataIdentification.xpath(@@mdIdentifierCitationXPath)[0]
            if xCitation.nil?
              msg = "WARNING: ISO19115-1 reader: element \'#{@@mdIdentifierCitationXPath}\' " \
              "is missing in #{xDataIdentification.name}"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else

              # see requirement in citation module
              xCit = xCitation.xpath('gmd:CI_Citation')[0]

              if xCit.nil? && !AdiwgUtils.valid_nil_reason(xCitation, hResponseObj)
                msg = "WARNING: ISO19115-1 reader: element \'#{xCitation.name}\' "\
                 "is missing valid nil reason within \'#{xDataIdentification.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end

              hCitation = Citation.unpack(xCitation, hResponseObj)
              hResourceInfo[:citation] = hCitation unless hCitation.nil?
            end

            # abstract: (required)
            # <xs:element name="abstract" type="gco:CharacterString_PropertyType"/>
            xAbstract = xDataIdentification.xpath(@@abstractXPath)[0]
            if xAbstract.nil?
              msg = "WARNING: ISO19115-1 reader: element \'#{@@abstractXPath}\' " \
              "is missing in #{xDataIdentification.name}"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else

              # all CharacterString are optional
              # <xs:sequence minOccurs="0">
              #   <xs:element ref="gco:CharacterString"/>
              # </xs:sequence>
              xStr = xAbstract.xpath('gco:CharacterString')[0]

              if xStr.nil? && !AdiwgUtils.valid_nil_reason(xAbstract, hResponseObj)
                msg = "WARNING: ISO19115-1 reader: element \'#{xAbstract.name}\' "\
                 "is missing valid nil reason within \'#{xDataIdentification.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end

              hResourceInfo[:abstract] = xAbstract.text.strip unless xStr.nil?
            end

            # keyword (optional)
            # <xs:element name="descriptiveKeywords" type="gmd:MD_Keywords_PropertyType" minOccurs="0"
            # maxOccurs="unbounded"/>
            xKeywords = xDataIdentification.xpath(@@keywordsXPath)
            hResourceInfo[:keywords] = xKeywords.map { |k| Keyword.unpack(k, hResponseObj) }.compact

            # :pointOfContact (optional)
            # <xs:element name="pointOfContact" type="gmd:CI_ResponsibleParty_PropertyType" minOccurs="0"
            # maxOccurs="unbounded"/>
            xPointOfContact = xDataIdentification.xpath(@@pointOfContactXPath)
            hResourceInfo[:pointOfContacts] = xPointOfContact.map do |poc|
              Responsibility.unpack(poc, hResponseObj)
            end.compact

            # resourceConstraints (optional)
            # <xs:element name="resourceConstraints" type="gmd:MD_Constraints_PropertyType" minOccurs="0"
            # maxOccurs="unbounded"/>
            xResourceConstraints = xDataIdentification.xpath(@@constraintsXPath)
            hResourceInfo[:constraints] = xResourceConstraints.map do |r|
              Constraint.unpack(r, hResponseObj)
            end.compact

            # :extent (optional)
            # <xs:element name="extent" type="gmd:EX_Extent_PropertyType" minOccurs="0" maxOccurs="unbounded"/>
            xExtents = xDataIdentification.xpath(@@extentsXPath)
            hResourceInfo[:extents] = xExtents.map { |e| Extent.unpack(e, hResponseObj) }.compact

            hResourceInfo
          end
        end
      end
    end
  end
end
