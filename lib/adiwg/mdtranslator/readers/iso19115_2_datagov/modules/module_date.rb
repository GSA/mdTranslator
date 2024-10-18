# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

# TODO: gmd:date is required in gmd:CI_Citation at least once and is unbounded.
# requiring gmd:CI_Date gets tricky with self-closing elements. revist this...

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152datagov
            module Date
               @@ciDateXPath = 'gmd:CI_Date'
               @@dateXPath = 'gmd:date//gco:Date'
               @@dateTypeXPath = 'gmd:dateType//gmd:CI_DateTypeCode'
               def self.unpack(xDateParent, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hDate = intMetadataClass.newDate

                  # CI_Date (required)
                  # <xs:element name="CI_Date" type="gmd:CI_Date_Type"/>
                  xDate = xDateParent.xpath(@@ciDateXPath)[0]

                  if xDate.nil?
                     msg = "WARNING: ISO19115-2 reader: element \'#{@@ciDateXPath}\' "\
                        "is missing in \'#{xDateParent.name}\'"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return hDate
                  end

                  hasDate = false

                  # :date (required)
                  # <xs:element name="date" type="gco:Date_PropertyType"/>
                  xDateData = xDate.xpath(@@dateXPath)
                  xDateData.each do |xdate|
                     next if xdate.nil?

                     myDateTime, dateResolution = AdiwgDateTimeFun.dateTimeFromString(xdate.text)
                     hDate[:date] = myDateTime
                     hDate[:dateResolution] = dateResolution
                     hasDate = true
                  end

                  if hasDate == false
                     msg = "WARNING: ISO19115-3 reader: element \'#{@@ciDateXPath}\' is missing a date element"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return hDate
                  end

                  # :dateType (required)
                  # <xs:element name="dateType" type="gmd:CI_DateTypeCode_PropertyType"/>
                  xDateTypeCode = xDate.xpath(@@dateTypeXPath)[0]
                  if xDateTypeCode.nil?
                     msg = "WARNING: ISO19115-3 reader: element \'#{@@dateTypeXPath}\' is missing in #{@@ciDateXPath}"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return hDate
                  end

                  hDate[:dateType] = xDateTypeCode.attr('codeListValue')

                  hDate
               end
            end
         end
      end
   end
end
