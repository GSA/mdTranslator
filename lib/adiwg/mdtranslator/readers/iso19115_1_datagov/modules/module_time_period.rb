# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191151datagov
        module TimePeriod
          @@timePeriodXPath = 'gml:TimePeriod'
          @@idAttr = 'gml:id'
          @@beginPosXPath = 'gml:beginPosition | gml:begin'
          @@endPosXPath = 'gml:endPosition | gml:end'
          def self.unpack(xExtent, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hTimePeriod = intMetadataClass.newTimePeriod

            # :timeperiod (optional)
            # <sequence minOccurs="0">
            #   <element ref="gml:TimePeriod"/>
            # </sequence>
            xTimePeriod = xExtent.xpath(@@timePeriodXPath)[0]
            return nil if xTimePeriod.nil?

            # :beginPosition/:begin and :endPosition/:end
            # <sequence>
            #    <choice>
            #      <element name="beginPosition" type="gml:TimePositionType"/>
            #      <element name="begin" type="gml:TimeInstantPropertyType"/>
            #    </choice>
            #    <choice>
            #      <element name="endPosition" type="gml:TimePositionType"/>
            #      <element name="end" type="gml:TimeInstantPropertyType"/>
            #    </choice>
            #    <group ref="gml:timeLength" minOccurs="0"/>
            # </sequence>

            xStartDatetime = xTimePeriod.xpath(@@beginPosXPath)[0]
            startDatetime = intMetadataClass.newDateTime
            if xStartDatetime.nil?
              msg = 'WARNING: ISO19115-1 reader: Element gml:beginPosition or gml:begin '\
                    'is missing in gml:TimePeriod'
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            elsif !AdiwgUtils.valid_nil_reason(xStartDatetime, hResponseObj) && xStartDatetime.text.empty?
              msg = 'WARNING: ISO19115-1 reader: Element gml:beginPosition or gml:begin '\
                    "is missing valid nilReason within \'#{xTimePeriod.name}\'"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else
              unless xStartDatetime.text.empty?
                dt = AdiwgDateTimeFun.dateTimeFromString(xStartDatetime.text)
                startDatetime[:dateTime] = dt[0].to_s
                startDatetime[:dateResolution] = dt[1]
                hTimePeriod[:startDateTime] = startDatetime
              end
            end

            xEndDatetime = xTimePeriod.xpath(@@endPosXPath)[0]
            endDatetime = intMetadataClass.newDateTime
            if xEndDatetime.nil?
              msg = 'WARNING: ISO19115-1 reader: Element gml:endPosition or gml:end '\
                    'is missing in gml:TimePeriod'
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            elsif !AdiwgUtils.valid_nil_reason(xEndDatetime, hResponseObj) && xEndDatetime.text.empty?
              msg = 'WARNING: ISO19115-1 reader: Element gml:endPosition or gml:end '\
                        "is missing valid nilReason within \'#{xTimePeriod.name}\'"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else
              unless xEndDatetime.text.empty?
                dt = AdiwgDateTimeFun.dateTimeFromString(xEndDatetime.text)
                endDatetime[:dateTime] = dt[0].to_s
                endDatetime[:dateResolution] = dt[1]
                hTimePeriod[:endDateTime] = endDatetime
              end
            end

            hTimePeriod
          end
        end
      end
    end
  end
end
