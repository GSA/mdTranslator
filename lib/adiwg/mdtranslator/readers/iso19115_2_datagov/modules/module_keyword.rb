# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_citation'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191152datagov
        module Keyword
          @@keywordsXPath = 'gmd:MD_Keywords'
          @@keywordXPath = 'gmd:keyword'
          @@thesaurusXPath = 'gmd:thesaurusName'
          def self.unpack(xDescriptiveKeyword, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hKeyword = intMetadataClass.newKeyword

            xMDKeywords = xDescriptiveKeyword.xpath(@@keywordsXPath)[0]
            return nil if xMDKeywords.nil?

            # :keyword (required)
            # <xs:element name="keyword" type="gco:CharacterString_PropertyType" maxOccurs="unbounded"/>
            xKeywords = xMDKeywords.xpath(@@keywordXPath)

            if xKeywords.empty?
              msg = "WARNING: ISO19115-2 reader: element \'#{@@keywordXPath}\' "\
                "is missing in \'#{xMDKeywords.name}\'"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else
              nilReasons = 0
              xKeywords.each do |keyword|
                if AdiwgUtils.valid_nil_reason(keyword, hResponseObj)
                  nilReasons += 1
                  next
                end

                keyword = keyword.xpath('gco:CharacterString')[0]
                next if keyword.nil?

                k = intMetadataClass.newKeywordObject
                k[:keyword] = keyword.text
                hKeyword[:keywords] << k
              end

              if hKeyword[:keywords].empty? && xKeywords.size != nilReasons
                msg = "WARNING: ISO19115-2 reader: element \'#{@@keywordXPath}\' "\
                "is missing in \'#{xMDKeywords.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end
            end

            # :thesaurus (optional)
            # <xs:element name="thesaurusName" type="gmd:CI_Citation_PropertyType" minOccurs="0"/>
            xThesarus = xMDKeywords.xpath(@@thesaurusXPath)[0]
            unless xThesarus.nil?
              hCitation = Citation.unpack(xThesarus, hResponseObj)
              hKeyword[:thesaurus] = hCitation unless hCitation.nil?
            end

            hKeyword
          end
        end
      end
    end
  end
end
