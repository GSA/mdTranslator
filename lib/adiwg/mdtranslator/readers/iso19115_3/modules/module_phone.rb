# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Telephone
               @@telephoneXPath = 'cit:CI_Telephone'
               @@numberXPath = 'cit:number//gco:CharacterString'
               @@numTypeXPath = 'cit:numberType//cit:CI_TelephoneTypeCode'
               def self.unpack(xPhone, hResponseObj)
                  xTelephone = xPhone.xpath(@@telephoneXPath)
                  return nil if xTelephone.empty?

                  intMetadataClass = InternalMetadata.new
                  hPhone = intMetadataClass.newPhone

                  # :phoneNumber
                  xNumber = xTelephone.xpath(@@numberXPath)[0]

                  if xNumber.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'cit:number\' '\
                     'is missing in cit:phone'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     hPhone
                  end

                  hPhone[:phoneNumber] = xNumber.text

                  # :phoneServiceTypes
                  xPhoneType = xTelephone.xpath(@@numTypeXPath)

                  hPhone[:phoneServiceTypes] = xPhoneType.empty? ? [] : [xPhoneType[0].attr('codeListValue')]

                  hPhone
               end
            end
         end
      end
   end
end
