# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_time_period'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module TemporalExtent
               @@temporalExtXPath = 'gmd:EX_TemporalExtent'
               @@timePeriodXPath = './/gml:TimePeriod'
               def self.unpack(xtemporalelem, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hTemporalExt = intMetadataClass.newTemporalExtent

                  xTemporalExt = xtemporalelem.xpath(@@temporalExtXPath)[0]
                  return nil if xTemporalExt.nil?

                  # :timePeriod
                  xTimePeriod = xTemporalExt.xpath(@@timePeriodXPath)[0]
                  hTemporalExt[:timePeriod] = TimePeriod.unpack(xTimePeriod, hResponseObj) unless xTimePeriod.nil?

                  hTemporalExt
               end
            end
         end
      end
   end
end
