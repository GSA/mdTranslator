# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_geographic_extent'
# require_relative 'module_temporal_extent'
# require_relative 'module_vertical_extent'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Extent
               @@extentXPath = 'mri:extent'
               @@exExtentXPath = 'gex:EX_Extent'
               @@descXPath = 'gex:description//gco:CharacterString'
               def self.process_extent(xExtent, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hExtent = intMetadataClass.newExtent

                  xExExtent = xExtent.xpath(@@exExtentXPath)[0] # there should only be 1

                  if xExExtent.nil?
                     msg = 'ERROR: ISO19115-3 reader: element \'gex:EX_Extent\' is missing in mri:extent'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionePass] = false
                  end

                  # : description
                  xDesc = xExtent.xpath(@@descXPath)[0]
                  hExtent[:description] = xDesc.nil? ? nil : xDesc.text

                  # :geographicExtents array
                  hExtent[:geographicExtents] = GeographicExtent.unpack(xExExtent, hResponseObj)

                  # :temporalExtents array
                  # :verticalExtents array

                  # {
                  #    description: nil,
                  #    geographicExtents: [],
                  #    temporalExtents: [],
                  #    verticalExtents: []
                  # }
                  # tempExtClass = EX_TemporalExtent.new(@xml, @hResponseObj)
                  # vertExtClass = EX_VerticalExtent.new(@xml, @hResponseObj)
                  # geoExtClass = GeographicExtent.new(@xml, @hResponseObj)

                  hExtent
               end

               def self.unpack(xRespblty, hResponseObj)
                  xExtents = xRespblty.xpath(@@extentXPath)
                  xExtents.map { |e| process_extent(e, hResponseObj) }
               end
            end
         end
      end
   end
end
