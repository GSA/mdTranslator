# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require 'adiwg-mdcodes'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Locale
               @@langCodeXpath = 'lan:language//lan:LanguageCode'
               @@cntryCodeXpath = 'lan:country//lan:CountryCode'
               @@chrEncXpath = 'lan:characterEncoding//lan:MD_CharacterSetCode'
               @@localeXPath = 'lan:PT_Locale'
               def self.unpack(xLocale, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hLocale = intMetadataClass.newLocale

                  xPTLocale = xLocale.xpath(@@localeXPath)[0]

                  if xLocale && xPTLocale.nil?
                     msg = "WARNING: ISO19115-3 reader: element \'lan:PT_Locale\' is missing in #{xLocale.name}"
                     hResponseObj[:readerStructureMessages] << msg
                     hResponseObj[:readerStructurePass] = false
                     return nil
                  end

                  xLocaleLangCode = xPTLocale.xpath(@@langCodeXpath)

                  # language code is required
                  if xLocaleLangCode.empty?
                     msg = "WARNING: ISO19115-3 reader: element \'lan:LanguageCode\' is missing in #{xLocale.name}"
                     hResponseObj[:readerStructureMessages] << msg
                     hResponseObj[:readerStructurePass] = false
                     return nil
                  end

                  codeListValue = ADIWG::Mdtranslator::Readers::Iso191153::CODELISTVALUE

                  hLocale[:languageCode] = xLocaleLangCode[0].attr(codeListValue)

                  xLocaleCntryCode = xPTLocale.xpath(@@cntryCodeXpath)
                  cc = xLocaleCntryCode.empty? ? nil : xLocaleCntryCode[0].attr(codeListValue)
                  hLocale[:countryCode] = cc

                  xLocaleChrEnc = xPTLocale.xpath(@@chrEncXpath)

                  # character encoding is required
                  if xLocaleChrEnc.empty?
                     msg = 'WARNING: ISO19115-3 reader: element \'lan:MD_CharacterSetCode\' is missing in Locale'
                     hResponseObj[:readerStructureMessages] << msg
                     hResponseObj[:readerStructurePass] = false
                     return hLocale
                  end

                  hLocale[:characterEncoding] = xLocaleChrEnc[0].attr(codeListValue)

                  hLocale
               end
            end
         end
      end
   end
end
