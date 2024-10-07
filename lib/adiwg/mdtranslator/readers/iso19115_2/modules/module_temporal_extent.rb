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
               @@timePeriodExtXPath = 'gmd:extent'
               def self.unpack(xtemporalelem, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hTemporalExt = intMetadataClass.newTemporalExtent

                  # :EX_TemporalExtent (optional)
                  # <xs:sequence minOccurs="0"> <xs:element ref="gmd:EX_TemporalExtent"/> </xs:sequence>
                  xTemporalExt = xtemporalelem.xpath(@@temporalExtXPath)[0]
                  return nil if xTemporalExt.nil?

                  # :extent (required)
                  # <xs:element name="extent" type="gts:TM_Primitive_PropertyType"/>
                  xTimePeriodExt = xTemporalExt.xpath(@@timePeriodExtXPath)[0]
                  if xTimePeriodExt.nil?
                     msg = "ERROR: ISO19115-2 reader: Element gmd:extent is missing in gmd:EX_TemporalExtent"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  hTemporalExt[:timePeriod] = TimePeriod.unpack(xTimePeriodExt, hResponseObj)

                  hTemporalExt
               end
            end
         end
      end
   end
end
