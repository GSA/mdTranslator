# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module TimeInstant
               @@idAttr = 'gml:id'
               @@idXPath = 'gml:identifier'
               @@descXPath = 'gml:description'
               @@identifierXPath = 'gml:identifier'
               @@nameXPath = 'gml:name'
               @@timePosXPath = 'gml:timePosition'
               def self.unpack(xTimeInstant, hResponseObj)
                  intMetadataClass = InternalMetadata.new

                  hTimeInst = intMetadataClass.newTimeInstant

                  # :timeId
                  timeId = xTimeInstant.attr(@@idAttr)
                  if timeId.nil?
                     msg = 'ERROR: ISO19115-3 reader: element \'gml:TimeInstant\' is missing gml:id attribute'
                     hResponseObj[:readerExecutionMessages] << msg
                  end

                  hTimeInst[:timeId] = timeId

                  # : description
                  xTimeDesc = xTimeInstant.xpath(@@descXPath)
                  hTimeInst[:description] = xTimeDesc.empty? ? nil : xTimeDesc[0].text

                  # :identifier
                  xIdentifier = xTimeInstant.xpath(@@idXPath)
                  hTimeInst[:identifier] = xIdentifier.empty? ? nil : xIdentifier[0].text

                  # :instantNames
                  hTimeInst[:instantNames] = xTimeInstant.xpath(@@nameXPath).map(&:text).compact

                  # :timeInstant { :dateTime: nil, :dateResolution: nil},
                  hTimeInstant = intMetadataClass.newDateTime
                  xTimePosition = xTimeInstant.xpath(@@timePosXPath)[0]

                  # TODO: confirm this
                  unless xTimePosition.nil?
                     hTimeInstant[:dateTime] = xTimePosition.text
                     hTimeInstant[:dateResolution] = 'hms'
                  end

                  hTimeInst[:timeInstant] = hTimeInstant

                  # in newTimeInstant hash but not included in the writer
                  # : geologicAge:

                  hTimeInst
               end
            end
         end
      end
   end
end
