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
               @@minValXPath = 'gex:minimumValue//gco:Real'
               @@maxValXpath = 'gex:maximumValue//gco:Real'
               def self.unpack(xExtent, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  extents = []

                  xVertElems = xExtent.xpath(@@vertElemXPath)

                  xVertElems.each do |xvertelem|
                     hVertExt = intMetadataClass.newVerticalExtent
                     xVertExt = xvertelem.xpath(@@vertExtXpath)

                     # TODO: :description

                     # :minValue required
                     xMinVal = xVertExt.xpath(@@minValXPath)

                     if xMinVal.empty?
                        msg = 'WARNING: ISO19115-3 reader: vertical element minimum value is'\
                        'missing in gex:EX_VerticalExtent'
                        hResponseObj[:readerExecutionMessages] << msg
                        hResponseObj[:readerExecutionPass] = false
                     else
                        hVertExt[:minValue] = xMinVal[0].text.to_f
                     end

                     # :maxValue required
                     xMaxVal = xVertExt.xpath(@@maxValXpath)

                     if xMaxVal.empty?
                        msg = 'WARNING: ISO19115-3 reader: vertical element maximum value is'\
                        'missing in gex:EX_VerticalExtent'
                        hResponseObj[:readerExecutionMessages] << msg
                        hResponseObj[:readerExecutionPass] = false
                     else
                        hVertExt[:maxValue] = xMaxVal[0].text.to_f
                     end

                     hVertExt[:crsId] = ReferenceSystem.unpack(xVertExt, hResponseObj)
                     extents << hVertExt
                  end
                  extents
               end
            end
         end
      end
   end
end
