# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152datagov
            module TimePeriod
               @@timePeriodXPath = 'gml:TimePeriod'
               @@idAttr = 'gml:id'
               @@beginPosXPath = 'gml:beginPosition | gml:begin'
               @@endPosXPath = 'gml:endPosition | gml:end'
               def self.unpack(xTimePeriodExt, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hTimePeriod = intMetadataClass.newTimePeriod

                  # :timeperod (optional)
                  # <sequence minOccurs="0"> <element ref="gml:TimePeriod"/> </sequence>
                  xTimePeriod = xTimePeriodExt.xpath(@@timePeriodXPath)
                  return nil if xTimePeriod.nil? # to-do: report an error?

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
                  if !xStartDatetime.nil? && !xStartDatetime.text.strip.empty?
                     dt = AdiwgDateTimeFun.dateTimeFromString(xStartDatetime.text)
                     startDatetime[:dateTime] = dt[0].to_s
                     startDatetime[:dateResolution] = dt[1]
                  else
                     msg = 'ERROR: ISO19115-2 reader: Element gml:beginPosition or gml:begin '\
                           'is missing in gml:TimePeriod'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end
                  hTimePeriod[:startDateTime] = startDatetime

                  xEndDatetime = xTimePeriod.xpath(@@endPosXPath)[0]
                  endDatetime = intMetadataClass.newDateTime
                  if !xEndDatetime.nil? && !xEndDatetime.text.strip.empty?
                     dt = AdiwgDateTimeFun.dateTimeFromString(xEndDatetime.text)
                     endDatetime[:dateTime] = dt[0].to_s
                     endDatetime[:dateResolution] = dt[1]
                  else
                     msg = 'ERROR: ISO19115-2 reader: Element gml:endPosition or gml:end '\
                           'is missing in gml:TimePeriod'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end
                  hTimePeriod[:endDateTime] = endDatetime

                  hTimePeriod
               end
            end
         end
      end
   end
end
