# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_reference_system'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module VerticalExtent
               @@vertElemXPath = 'gex:verticalElement'
               @@vertExtXpath = 'gex:EX_VerticalExtent'
               @@vertCRSIdXPath = 'gex:verticalCRSId'
               @@minValXPath = 'gex:minimumValue//gco:Real'
               @@maxValXpath = 'gex:maximumValue//gco:Real'
               def self.unpack(xvertElem, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hVertExt = intMetadataClass.newVerticalExtent
                  # :description exists in the internal object but not processed in the writer

                  xVertExt = xvertElem.xpath(@@vertExtXpath)[0]
                  return nil if xVertExt.nil?

                  # :minValue (required)
                  xMinVal = xVertExt.xpath(@@minValXPath)[0]

                  if xMinVal.nil?
                     msg = 'WARNING: ISO19115-3 reader: vertical element minimum value is'\
                     'missing in gex:EX_VerticalExtent'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  hVertExt[:minValue] = xMinVal.text.to_f

                  # :maxValue (required)
                  xMaxVal = xVertExt.xpath(@@maxValXpath)[0]

                  if xMaxVal.nil?
                     msg = 'WARNING: ISO19115-3 reader: vertical element maximum value is'\
                     'missing in gex:EX_VerticalExtent'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                  end

                  hVertExt[:maxValue] = xMaxVal.text.to_f

                  # :crsId (optional)
                  vertCRSId = xVertExt.xpath(@@vertCRSIdXPath)[0]
                  hVertExt[:crsId] = ReferenceSystem.unpack(vertCRSId, hResponseObj) unless vertCRSId.nil?

                  hVertExt
               end
            end
         end
      end
   end
end
