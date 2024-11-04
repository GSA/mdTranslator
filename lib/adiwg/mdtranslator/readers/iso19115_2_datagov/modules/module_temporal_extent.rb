# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_time_period'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191152datagov
        module TemporalExtent
          @@temporalExtXPath = 'gmd:EX_TemporalExtent'
          @@timePeriodExtXPath = 'gmd:extent'
          def self.unpack(xtemporalelem, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hTemporalExt = intMetadataClass.newTemporalExtent

            # EX_TemporalExtent (optional)
            # <xs:sequence minOccurs="0">
            #   <xs:element ref="gmd:EX_TemporalExtent"/>
            # </xs:sequence>
            xTemporalExt = xtemporalelem.xpath(@@temporalExtXPath)[0]
            return nil if xTemporalExt.nil?

            # :extent (required)
            # <xs:element name="extent" type="gts:TM_Primitive_PropertyType"/>
            xExtent = xTemporalExt.xpath(@@timePeriodExtXPath)[0]
            if xExtent.nil?
              msg = "ERROR: ISO19115-2 reader: Element #{@@timePeriodExtXPath} is " \
              'missing in gmd:EX_TemporalExtent'
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else

              # :TimePeriod (optional)
              # <sequence minOccurs="0">
              #   <element ref="gml:TimePeriod"/>
              # </sequence>
              xTP = xExtent.xpath('gml:TimePeriod')[0]

              # TODO: because TimePeriod has a sibling this isn't correct.
              if xTP.nil? && !AdiwgUtils.valid_nil_reason(xExtent, hResponseObj)
                msg = "WARNING: ISO19115-2 reader: element \'#{xExtent.name}\' "\
                 "is missing valid nil reason within \'#{xTemporalExt.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end

              # TimeInstant and TimePeriod are siblings. either can occur within "extent" in this context.
              # however, dcatus temporal only looks for timePeriod.
              hTemporalExt[:timePeriod] = TimePeriod.unpack(xExtent, hResponseObj) unless xTP.nil?
            end

            hTemporalExt
          end
        end
      end
    end
  end
end
