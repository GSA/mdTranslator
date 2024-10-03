# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module TimePeriod
               @@idAttr = 'gml:id'
               @@beginPosXPath = 'gml:beginPosition | gml:begin'
               @@endPosXPath = 'gml:endPosition | gml:end'
               def self.unpack(xTimePeriod, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hTimePeriod = intMetadataClass.newTimePeriod

                  timeId = xTimePeriod.attr(@@idAttr)
                  if timeId.nil?
                     msg = 'ERROR: ISO19115-2 reader: Attribut gml:id is missing in gml:TimePeriod'
                     hResponseObj[:readerExecutionMessages] << msg
                  end

                  hTimePeriod[:timeId] = timeId
                  
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
                  end
                  hTimePeriod[:endDateTime] = endDatetime

                  hTimePeriod
               end
            end
         end
      end
   end
end
