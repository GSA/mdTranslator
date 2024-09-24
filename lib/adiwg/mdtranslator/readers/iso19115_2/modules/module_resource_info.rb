# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_citation'
require_relative 'module_keyword'
require_relative 'module_responsibility'
require_relative 'module_constraint'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module ResourceInformation
               @@mdIdentifierCitationXPath = 'gmd:citation'
               @@abstractXPath = 'gmd:abstract//gco:CharacterString'
               @@keywordsXPath = 'gmd:descriptiveKeywords'
               @@pointOfContactXPath = 'gmd:pointOfContact'
               @@constraintsXPath = 'gmd:resourceConstraints'
               def self.unpack(xDataIdentification, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hResourceInfo = intMetadataClass.newResourceInfo

                  # :citation (required)
                  # <xs:element name="citation" type="gmd:CI_Citation_PropertyType"/>
                  xCitation = xDataIdentification.xpath(@@mdIdentifierCitationXPath)[0]
                  if xCitation.nil?
                     msg = "WARNING: ISO19115-2 reader: element \'#{@@mdIdentifierCitationXPath}\' " \
                     "is missing in #{xDataIdentification.name}"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return hResourceInfo
                  end

                  hResourceInfo[:citation] = Citation.unpack(xCitation, hResponseObj)

                  # abstract: (required)
                  # <xs:element name="abstract" type="gco:CharacterString_PropertyType"/>
                  xAbstract = xDataIdentification.xpath(@@abstractXPath)[0]
                  if xAbstract.nil?
                     msg = "WARNING: ISO19115-2 reader: element \'#{@@abstractXPath}\' " \
                     "is missing in #{xDataIdentification.name}"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return hResourceInfo
                  end

                  hResourceInfo[:abstract] = xAbstract.text

                  # keyword (optional)
                  # <xs:element name="descriptiveKeywords" type="gmd:MD_Keywords_PropertyType" minOccurs="0"
                  # maxOccurs="unbounded"/>
                  xKeywords = xDataIdentification.xpath(@@keywordsXPath)
                  hResourceInfo[:keywords] = xKeywords.map { |k| Keyword.unpack(k, hResponseObj) }

                  # :pointOfContact (optional)
                  # <xs:element name="pointOfContact" type="gmd:CI_ResponsibleParty_PropertyType" minOccurs="0"
                  # maxOccurs="unbounded"/>
                  xPointOfContact = xDataIdentification.xpath(@@pointOfContactXPath)
                  hResourceInfo[:pointOfContacts] = xPointOfContact.map do |poc|
                     Responsibility.unpack(poc, hResponseObj)
                  end

                  # resourceConstraints (optional)
                  # <xs:element name="resourceConstraints" type="gmd:MD_Constraints_PropertyType" minOccurs="0"
                  # maxOccurs="unbounded"/>
                  xResourceConstraints = xDataIdentification.xpath(@@constraintsXPath)
                  hResourceInfo[:constraints] = xResourceConstraints.map do |r|
                     Constraint.unpack(r, hResponseObj)
                  end

                  hResourceInfo
               end
            end
         end
      end
   end
end
