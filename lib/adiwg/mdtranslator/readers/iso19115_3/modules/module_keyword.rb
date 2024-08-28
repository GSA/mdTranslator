# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_citation'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Keyword
               @@keywordsXPath = 'mri:MD_Keywords'
               @@keywordXPath = 'mri:keyword//gco:CharacterString'
               @@keywordTypeXPath = 'mri:type//mri:MD_KeywordTypeCode'
               @@thesaurusXPath = 'mri:thesaurusName'
               def self.unpack(xDescriptiveKeyword, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hKeyword = intMetadataClass.newKeyword

                  xMDKeywords = xDescriptiveKeyword.xpath(@@keywordsXPath)[0]
                  if xMDKeywords.nil?
                     msg = 'ERROR: ISO19115-3 reader: element \'mri:MD_Keywords\' is missing in mri:descriptiveKeywords'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # :keyword (required)
                  # <element maxOccurs="unbounded" name="keyword" type="gco:CharacterString_PropertyType">
                  xKeywords = xMDKeywords.xpath(@@keywordXPath)
                  if xKeywords.empty?
                     msg = 'ERROR: ISO19115-3 reader: element \'mri:keyword\' is missing in mri:MD_Keywords'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  xKeywords.each do |keyword|
                     k = intMetadataClass.newKeywordObject
                     k[:keyword] = keyword.text
                     hKeyword[:keywords] << k
                  end

                  # :type (optional)
                  # <element minOccurs="0" name="type" type="mri:MD_KeywordTypeCode_PropertyType">
                  xKeywordType = xMDKeywords.xpath(@@keywordTypeXPath)[0]
                  hKeyword[:type] = xKeywordType.nil? ? nil : xKeywordType.attr('codeListValue')

                  # :thesaurus (optional)
                  # <element minOccurs="0" name="thesaurusName" type="mcc:Abstract_Citation_PropertyType">
                  xThesarus = xMDKeywords.xpath(@@thesaurusXPath)[0]
                  hKeyword[:thesaurus] = Citation.unpack(xThesarus, hResponseObj)

                  # keywordClass
                  # <element minOccurs="0" name="keywordClass" type="mri:MD_KeywordClass_PropertyType"/>
                  # keyword - keyword class {MD_KeywordClass} - not implemented in mdJson 2.0

                  hKeyword
               end
            end
         end
      end
   end
end
