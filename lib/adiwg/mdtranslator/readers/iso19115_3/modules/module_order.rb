# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Order
               @@orderXPath = 'mrd:MD_StandardOrderProcess'
               @@feeXPath = 'mrd:fees//gco:CharacterString'
               @@availableXPath = 'mrd:plannedAvailableDateTime//gco:DateTime'
               @@orderInstrsXPath = 'mrd:orderingInstructions//gco:CharacterString'
               @@turnAroundXPath = 'mrd:turnaround//gco:CharacterString'
               def self.unpack(xDistOrder, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hOrder = intMetadataClass.newOrderProcess

                  # MD_StrandardOrderProcess (required)
                  # <element name="MD_StandardOrderProcess"
                  # substitutionGroup="mcc:Abstract_StandardOrderProcess"
                  # type="mrd:MD_StandardOrderProcess_Type">
                  xOrder = xDistOrder.xpath(@@orderXPath)[0]
                  if xOrder.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'mrd:MD_StandardOrderProcess\' '\
                        'is missing in mrd:distributionOrderProcess'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # :fees (optional)
                  # <element minOccurs="0" name="fees" type="gco:CharacterString_PropertyType">
                  xFee = xOrder.xpath(@@feeXPath)
                  hOrder[:fees] = xFee.nil? ? nil : xFee.text

                  # :plannedAvailability (optional)
                  # <element minOccurs="0" name="plannedAvailableDateTime"
                  # type="gco:DateTime_PropertyType">
                  xAvailable = xOrder.xpath(@@availableXPath)[0]
                  unless xAvailable.nil?
                     hDateTime = intMetadataClass.newDateTime
                     myDateTime, dateResolution = AdiwgDateTimeFun.dateTimeFromString(xAvailable.text)
                     hDateTime[:dateTime] = myDateTime
                     hDateTime[:dateResolution] = dateResolution
                     hOrder[:plannedAvailability] = hDateTime
                  end

                  # :orderingInstructions (optional)
                  # <element minOccurs="0" name="orderingInstructions"
                  # type="gco:CharacterString_PropertyType">
                  xOrderInstructions = xOrder.xpath(@@orderInstrsXPath)[0]
                  hOrder[:orderingInstructions] = xOrderInstructions.nil? ? nil : xOrderInstructions.text

                  # :turnaround (optional)
                  # <element minOccurs="0" name="turnaround" type="gco:CharacterString_PropertyType">
                  xTurnAround = xOrder.xpath(@@turnAroundXPath)[0]
                  hOrder[:turnaround] = xTurnAround.nil? ? nil : xTurnAround.text

                  hOrder
               end
            end
         end
      end
   end
end
