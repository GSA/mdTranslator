# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_time_instant'
require_relative 'module_time_period'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module TemporalExtent
               @@temporalElemXPath = 'gex:temporalElement'
               @@temporalExtXPath = 'gex:EX_TemporalExtent'
               @@timePeriodXPath = './/gml:TimePeriod'
               @@timeInstantXPath = './/gml:TimeInstant'
               def self.unpack(xExExtent, hResponseObj)
                  intMetadataClass = InternalMetadata.new

                  extents = []

                  xTemporalElems = xExExtent.xpath(@@temporalElemXPath)

                  return extents if xTemporalElems.empty?

                  xTemporalElems.each do |xtemporalelem|
                     hTemporalExt = intMetadataClass.newTemporalExtent

                     xTemporalExt = xtemporalelem.xpath(@@temporalExtXPath)[0]

                     # :timePeriod
                     xTimePeriod = xTemporalExt.xpath(@@timePeriodXPath)[0]
                     hTemporalExt[:timePeriod] = TimePeriod.unpack(xTimePeriod, hResponseObj) unless xTimePeriod.nil?

                     # :timeInstant
                     xTimeInstant = xTemporalExt.xpath(@@timeInstantXPath)[0]
                     unless xTimeInstant.nil?
                        hTemporalExt[:timeInstant] =
                           TimeInstant.unpack(xTimeInstant, hResponseObj)
                     end

                     extents << hTemporalExt
                  end
                  extents
               end
            end
         end
      end
   end
end
