# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module TimePeriod
               @@idAttr = 'gml:id'
               @@descXPath = 'gml:description'
               @@idXPath = 'gml:identifier'
               @@nameXPath = 'gml:name'
               @@beginPosXPath = 'gml:beginPosition'
               @@endPosXPath = 'gml:endPosition'
               @@intervalXPath = 'gml:timeInterval'
               @@durationXPath = 'gml:duration'
               def self.unpack(xTimePeriod, hResponseObj) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
                  intMetadataClass = InternalMetadata.new

                  hTimePeriod = intMetadataClass.newTimePeriod

                  # :timeId
                  timeId = xTimePeriod.attr(@@idAttr)
                  if timeId.nil?
                     msg = 'ERROR: ISO19115-3 reader: element \'gml:TimePeriod\' is missing gml:id attribute'
                     hResponseObj[:readerExecutionMessages] << msg
                  end

                  hTimePeriod[:timeId] = timeId

                  # : description
                  xTimeDesc = xTimePeriod.xpath(@@descXPath)
                  hTimePeriod[:description] = xTimeDesc.empty? ? nil : xTimeDesc[0].text

                  # :identifier
                  xIdentifier = xTimePeriod.xpath(@@idXPath)
                  hTimePeriod[:identifier] = xIdentifier.empty? ? nil : xIdentifier[0].text

                  # :periodNames
                  hTimePeriod[:periodNames] = xTimePeriod.xpath(@@nameXPath).map(&:text).compact

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

                  unless xEndDatetime.nil?
                     dt = AdiwgDateTimeFun.dateTimeFromString(xEndDatetime.text)
                     endDatetime[:dateTime] = dt[0].to_s
                     endDatetime[:dateResolution] = dt[1]
                  end

                  hTimePeriod[:endDateTime] = endDatetime

                  # :timeInterval
                  xTimeInterval = xTimePeriod.xpath(@@intervalXPath)[0]
                  hTimeInterval = intMetadataClass.newTimeInterval

                  unless xTimeInterval.nil?
                     hTimeInterval[:interval] = xTimeInterval.text
                     hTimeInterval[:units] = xTimeInterval.attr('unit')
                  end

                  hTimePeriod[:timeInterval] = hTimeInterval

                  # :duration
                  xDuration = xTimePeriod.xpath(@@durationXPath)[0]
                  hDuration = intMetadataClass.newDuration

                  hDuration = AdiwgDateTimeFun.convertDurationToNamedGroup(xDuration.text) unless xDuration.nil?

                  hTimePeriod[:duration] = hDuration

                  # these are in the newTimePeriod hash but not included in the writer
                  # :startGeologicAge
                  # :endGeologicAge

                  hTimePeriod
               end
            end
         end
      end
   end
end
