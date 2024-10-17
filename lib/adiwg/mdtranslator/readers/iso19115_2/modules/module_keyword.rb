# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_citation'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module Keyword
               @@keywordsXPath = 'gmd:MD_Keywords'
               @@keywordXPath = 'gmd:keyword//gco:CharacterString'
               @@keywordTypeXPath = 'gmd:type//gmd:MD_KeywordTypeCode'
               @@thesaurusXPath = 'gmd:thesaurusName'
               def self.unpack(xDescriptiveKeyword, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hKeyword = intMetadataClass.newKeyword

                  xMDKeywords = xDescriptiveKeyword.xpath(@@keywordsXPath)[0]
                  return hKeyword if xMDKeywords.nil?

                  # :keyword (required)
                  # <xs:element name="keyword" type="gco:CharacterString_PropertyType" maxOccurs="unbounded"/>
                  xKeywords = xMDKeywords.xpath(@@keywordXPath)
                  if xKeywords.empty?
                     msg = "ERROR: ISO19115-2 reader: element \'#{@@keywordXPath}\' is missing in #{xMDKeywords.name}"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return hKeyword
                  end

                  xKeywords.each do |keyword|
                     k = intMetadataClass.newKeywordObject
                     k[:keyword] = keyword.text
                     hKeyword[:keywords] << k
                  end

                  # :thesaurus (optional)
                  # <xs:element name="thesaurusName" type="gmd:CI_Citation_PropertyType" minOccurs="0"/>
                  xThesarus = xMDKeywords.xpath(@@thesaurusXPath)[0]
                  hKeyword[:thesaurus] = xThesarus.nil? ? nil : Citation.unpack(xThesarus, hResponseObj)

                  hKeyword
               end
            end
         end
      end
   end
end
