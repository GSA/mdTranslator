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
          @@dateXPath = 'gmd:date'
          @@dateTypeXPath = 'gmd:dateType'
          def self.unpack(xDateParent, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hDate = intMetadataClass.newDate

            # CI_Date (optional)
            # <xs:sequence minOccurs="0">
            #   <xs:element ref="gmd:CI_Date"/>
            # </xs:sequence>
            xDate = xDateParent.xpath(@@ciDateXPath)[0]
            return nil if xDate.nil?

            # :date (required)
            # <xs:element name="date" type="gco:Date_PropertyType"/>
            xDateDate = xDate.xpath(@@dateXPath)[0]
            if xDateDate.nil?
              msg = "WARNING: ISO19115-2 reader: element \'#{@@dateXPath}\' is missing in #{xDate.name}"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else

              # Date is optional
              # <xs:choice minOccurs="0">
              #   <xs:element ref="gco:Date"/>
              #   <xs:element ref="gco:DateTime"/>
              # </xs:choice>
              xD = xDateDate.xpath('gco:Date | gco:DateTime')[0]

              if xD.nil? && !AdiwgUtils.valid_nil_reason(xDateDate, hResponseObj)
                msg = "WARNING: ISO19115-2 reader: element \'#{xDateDate.name}\' "\
                 "is missing valid nil reason within \'#{xDate.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end

              unless xD.nil?
                myDateTime, dateResolution = AdiwgDateTimeFun.dateTimeFromString(xD.text)
                hDate[:date] = myDateTime
                hDate[:dateResolution] = dateResolution
              end
            end

            # :dateType (required)
            # <xs:element name="dateType" type="gmd:CI_DateTypeCode_PropertyType"/>
            xDateTypeCode = xDate.xpath(@@dateTypeXPath)[0]
            if xDateTypeCode.nil?
              msg = "WARNING: ISO19115-2 reader: element \'#{@@dateTypeXPath}\' is missing in #{xDate.name}"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else

              # DateTypeCode is optional
              #   <xs:sequence minOccurs="0">
              # <xs:element ref="gmd:CI_DateTypeCode"/>
              # </xs:sequence>
              xDTCode = xDateTypeCode.xpath('gmd:CI_DateTypeCode')[0]

              if xDTCode.nil? && !AdiwgUtils.valid_nil_reason(xDateTypeCode, hResponseObj)
                msg = "WARNING: ISO19115-2 reader: element \'#{xDateTypeCode.name}\' "\
                 "is missing valid nil reason within \'#{xDate.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end

              hDate[:dateType] = xDTCode.attr('codeListValue') unless xDTCode.nil?
            end

            hDate
          end
        end
      end
    end
  end
end
