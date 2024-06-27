# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require 'adiwg-mdcodes'
require_relative 'module_identification'
require_relative 'module_citation'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Locale
               @@langCodeXpath = './/lan:LanguageCode'
               @@cntryCodeXpath = './/lan:CountryCode'
               @@chrEncXpath = './/lan:MD_CharacterSetCode'
               @@localeXpath = './/mdb:defaultLocale'
               def self.unpack(xMetadata, _hResponseObj)
                  xLocale = xMetadata.xpath(@@localeXpath)
                  xLocale = xLocale[0]

                  intMetadataClass = InternalMetadata.new
                  hLocale = intMetadataClass.newLocale

                  codeListValue = 'codeListValue'

                  xLocaleLangCode = xLocale.xpath(@@langCodeXpath)
                  hLocale[:languageCode] = xLocaleLangCode[0].attr(codeListValue)

                  xLocaleCntryCode = xLocale.xpath(@@cntryCodeXpath)
                  hLocale[:countryCode] = xLocaleCntryCode[0].attr(codeListValue)

                  xLocaleChrEnc = xLocale.xpath(@@chrEncXpath)
                  hLocale[:characterEncoding] = xLocaleChrEnc[0].attr(codeListValue)

                  hLocale
               end
            end
         end
      end
   end
end
