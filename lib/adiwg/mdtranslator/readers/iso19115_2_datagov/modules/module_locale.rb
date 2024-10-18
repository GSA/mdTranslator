# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require 'adiwg-mdcodes'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152datagov
            module Locale
               @@localeXPath = 'gmd:PT_Locale'
               @@langCodeXpath = 'gmd:languageCode//gmd:LanguageCode'

               def self.unpack(xLocale, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hLocale = intMetadataClass.newLocale

                  # :PT_Locale (optional)
                  # <xs:sequence minOccurs="0"><xs:element ref="gmd:PT_Locale"/></xs:sequence>
                  xPTLocale = xLocale.xpath(@@localeXPath)[0]
                  return nil if xPTLocale.nil?

                  # :LanguageCode (optional)
                  # <xs:sequence minOccurs="0"><xs:element ref="gmd:LanguageCode"/></xs:sequence>
                  xLocaleLangCode = xPTLocale.xpath(@@langCodeXpath)
                  hLocale[:languageCode] = xLocaleLangCode.attr('codeListValue').text unless xLocaleLangCode.nil?

                  hLocale
               end
            end
         end
      end
   end
end
