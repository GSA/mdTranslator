# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Date
               @@ciDateXPath = 'cit:CI_Date'
               @@dateTimeXPath = 'cit:date//gco:DateTime'
               @@dateXPath = 'cit:date//gco:Date'
               @@dateTypeXPath = 'cit:dateType//cit:CI_DateTypeCode'
               def self.unpack(xDateParent, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hDate = intMetadataClass.newDate

                  # CI_Date (required)
                  # <element name="CI_Date" substitutionGroup="mcc:Abstract_TypedDate" type="cit:CI_Date_Type">
                  xDate = xDateParent.xpath(@@ciDateXPath)[0]

                  if xDate.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'cit:CI_Date\' is missing in cit:date'
                     hResponseObj[:readerStructureMessages] << msg
                     hResponseObj[:readerStructurePass] = false
                     return nil
                  end

                  hasDate = false

                  # :date (required)
                  # <element name="date" type="gco:Date_PropertyType">
                  # date and datetime are both expressed using the same xml element
                  # so `hasDate` refers to either one. see citation.xsd for more info.
                  xDateData = [xDate.xpath(@@dateTimeXPath)[0], xDate.xpath(@@dateXPath)[0]]
                  xDateData.each do |xdate|
                     next if xdate.nil?

                     myDateTime, dateResolution = AdiwgDateTimeFun.dateTimeFromString(xdate.text)
                     hDate[:date] = myDateTime
                     hDate[:dateResolution] = dateResolution
                     hasDate = true
                  end

                  if hasDate == false
                     msg = 'WARNING: ISO19115-3 reader: element \'cit:CI_Date\' is missing a date/datetime element'
                     hResponseObj[:readerStructureMessages] << msg
                     hResponseObj[:readerStructurePass] = false
                     return nil
                  end

                  # :dateType (required)
                  # <element name="dateType" type="cit:CI_DateTypeCode_PropertyType">
                  xDateTypeCode = xDate.xpath(@@dateTypeXPath)[0]
                  if xDateTypeCode.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'cit:CI_DateTypeCode\' is missing in cit:CI_Date'
                     hResponseObj[:readerStructureMessages] << msg
                     hResponseObj[:readerStructurePass] = false
                     return nil
                  end

                  hDate[:dateType] = xDateTypeCode.attr('codeListValue')

                  hDate
               end
            end
         end
      end
   end
end
