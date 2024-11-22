# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191151datagov
        module TimeInstant
          @@timeInstantXPath = 'gml:TimeInstant'
          @@timePositionXPath = 'gml:timePosition'
          def self.unpack(xExtent, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hTimeInstant = intMetadataClass.newTimeInstant

            # :TimeInstant (optional)
            # <sequence minOccurs="0">
            #   <element ref="gml:TimeInstant"/>
            # </sequence>
            xTimeInstant = xExtent.xpath(@@timeInstantXPath)[0]
            return nil if xTimeInstant.nil?

            # id is apparently a required attr
            # https://schemas.opengis.net/gml/3.2.1/gmlBase.xsd
            idRegex = /^[a-zA-Z_][\w.-]*$/
            timeInstantID = xTimeInstant.attr('gml:id')

            if timeInstantID.nil? || idRegex.match(timeInstantID).nil?
              msg = "WARNING: ISO19115-1 reader: element \'#{@@timeInstantXPath}\' "\
                 'is missing valid gml:id'
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else
              hTimeInstant[:timeId] = timeInstantID
            end

            # :timePosition (required)
            # <sequence>
            #   <element ref="gml:timePosition"/>
            # </sequence>
            xTimePosition = xTimeInstant.xpath(@@timePositionXPath)[0]
            if xTimePosition.nil?
              msg = "WARNING: ISO19115-1 reader: element \'#{@@timePositionXPath}\' "\
                 "is missing in \'#{xTimeInstant.name}\'"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            elsif !AdiwgUtils.valid_nil_reason(xTimePosition, hResponseObj) && xTimePosition.text.empty?
              msg = "WARNING: ISO19115-1 reader: Element #{@@timePositionXPath} "\
                        "is missing valid nilReason within \'#{xTimeInstant.name}\'"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else
              unless xTimePosition.text.empty?
                dt = AdiwgDateTimeFun.dateTimeFromString(xTimePosition.text)
                hTimeInstant[:timeInstant][:dateTime] = dt[0].to_s
                hTimeInstant[:timeInstant][:dateResolution] = dt[1]
              end
            end

            hTimeInstant
          end
        end
      end
    end
  end
end
