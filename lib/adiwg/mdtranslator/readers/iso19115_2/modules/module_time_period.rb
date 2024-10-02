# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module TimePeriod
               @@idAttr = 'gml:id'
               @@PositionAttr = 'indeterminatePosition'
               @@beginPosXPath = 'gml:beginPosition'
               @@endPosXPath = 'gml:endPosition'
               def self.unpack(xTimePeriod, hResponseObj)
                  intMetadataClass = InternalMetadata.new

                  hTimePeriod = intMetadataClass.newTimePeriod

                  # :timeId
                  timeId = xTimePeriod.attr(@@idAttr)
                  if timeId.nil?
                     msg = 'ERROR: ISO19115-2 reader: element \'gml:TimePeriod\' is missing gml:id attribute'
                     hResponseObj[:readerExecutionMessages] << msg
                  end

                  hTimePeriod[:timeId] = timeId
                  
                  # :startDatetime
                  xStartDatetime = xTimePeriod.xpath(@@beginPosXPath)[0]
                  startDatetime = intMetadataClass.newDateTime

                  unless xStartDatetime.nil?
                     dt = AdiwgDateTimeFun.dateTimeFromString(xStartDatetime.text)
                     startDatetime[:dateTime] = dt[0].to_s
                     startDatetime[:dateResolution] = dt[1]
                  end

                  hTimePeriod[:startDateTime] = startDatetime

                  # :endDateTime
                  xEndDatetime = xTimePeriod.xpath(@@endPosXPath)[0]
                  endDatetime = intMetadataClass.newDateTime

                  if !xEndDatetime.nil? && !xEndDatetime.text.strip.empty?
                     # If the text is not empty, process it as a date
                     dt = AdiwgDateTimeFun.dateTimeFromString(xEndDatetime.text)
                     endDatetime[:dateTime] = dt[0].to_s
                     endDatetime[:dateResolution] = dt[1]
                   elsif !xEndDatetime.nil? && !xEndDatetime.attr(@@PositionAttr).nil?
                     # If the text is empty but indeterminatePosition exists, use its value
                     endDatetime[:dateTime] = xEndDatetime.attr(@@PositionAttr)
                     endDatetime[:dateResolution] = 'indeterminate'
                   end

                  hTimePeriod[:endDateTime] = endDatetime

                  hTimePeriod
               end
            end
         end
      end
   end
end
