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
               @@otherLocaleXpath = './/mdb:otherLocale'
               @@codeListValue = 'codeListValue'

               def self.process_locale(xLocale, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hLocale = intMetadataClass.newLocale

                  xLocaleLangCode = xLocale.xpath(@@langCodeXpath)

                  # language code is required
                  if xLocaleLangCode.empty?
                     msg = 'WARNING: ISO19115-3 reader: element \'lan:LanguageCode\' is missing in Locale'
                     hResponseObj[:readerStructureMessages] << msg
                     hResponseObj[:readerStructurePass] = false
                     return hLocale
                  end

                  hLocale[:languageCode] = xLocaleLangCode[0].attr(@@codeListValue)

                  xLocaleCntryCode = xLocale.xpath(@@cntryCodeXpath)
                  cc = xLocaleCntryCode.empty? ? nil : xLocaleCntryCode[0].attr(@@codeListValue)
                  hLocale[:countryCode] = cc

                  xLocaleChrEnc = xLocale.xpath(@@chrEncXpath)

                  # character encoding is required
                  if xLocaleChrEnc.empty?
                     msg = 'WARNING: ISO19115-3 reader: element \'lan:MD_CharacterSetCode\' is missing in Locale'
                     hResponseObj[:readerStructureMessages] << msg
                     hResponseObj[:readerStructurePass] = false
                     return hLocale
                  end

                  hLocale[:characterEncoding] = xLocaleChrEnc[0].attr(@@codeListValue)

                  hLocale
               end

               def self.unpack(xMetadata, hResponseObj, localType)
                  localeXpath = localType == 'other' ? @@otherLocaleXpath : @@localeXpath
                  xLocales = xMetadata.xpath(localeXpath)

                  res = xLocales.map { |l| process_locale(l, hResponseObj) }
                  return res[0] if localType == 'default'

                  res
               end
            end
         end
      end
   end
end
