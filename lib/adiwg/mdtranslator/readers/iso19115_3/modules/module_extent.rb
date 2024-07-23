# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_geographic_extent'
require_relative 'module_temporal_extent'
require_relative 'module_vertical_extent'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Extent
               @@exExtentXPath = 'gex:EX_Extent'
               @@descXPath = 'gex:description//gco:CharacterString'
               @@geoElemXPath = 'gex:geographicElement'
               @@temporalElemXPath = 'gex:temporalElement'
               @@verticalElemXPath = 'gex:verticalElement'
               def self.unpack(xExtent, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hExtent = intMetadataClass.newExtent

                  # EX_Extent (required)
                  xExExtent = xExtent.xpath(@@exExtentXPath)[0]
                  if xExExtent.nil?
                     msg = 'ERROR: ISO19115-3 reader: element \'gex:EX_Extent\' is missing in extent'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionePass] = false
                     return nil
                  end

                  # :description (optional)
                  xDesc = xExExtent.xpath(@@descXPath)[0]
                  hExtent[:description] = xDesc.nil? ? nil : xDesc.text

                  # :geographicExtents (optional)
                  xGeoElems = xExExtent.xpath(@@geoElemXPath)
                  unless xGeoElems.nil?
                     hExtent[:geographicExtents] = xGeoElems.map { |g| GeographicExtent.unpack(g, hResponseObj) }
                  end

                  # :temporalExtents (optional)
                  xTemporalElems = xExExtent.xpath(@@temporalElemXPath)
                  unless xTemporalElems.nil?
                     hExtent[:temporalExtents] = xTemporalElems.map { |t| TemporalExtent.unpack(t, hResponseObj) }
                  end

                  # :verticalExtents (optional)
                  xVerticalElems = xExExtent.xpath(@@verticalElemXPath)
                  unless xVerticalElems.nil?
                     hExtent[:verticalExtents] = xVerticalElems.map { |v| VerticalExtent.unpack(v, hResponseObj) }
                  end

                  hExtent
               end
            end
         end
      end
   end
end
