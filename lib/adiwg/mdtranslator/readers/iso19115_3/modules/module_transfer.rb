# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_online_resource'
require_relative 'module_format'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Transfer
               @@transferXPath = 'mrd:MD_DigitalTransferOptions'
               @@unitsOfDistXPath = 'mrd:unitsOfDistribution//gco:CharacterString'
               @@transferSizeXPath = 'mrd:transferSize//gco:Real'
               @@onlineXPath = 'mrd:onLine'
               @@offlineXPath = 'mrd:offLine'
               @@distFormatXPath = 'mrd:distributionFormat'
               def self.unpack(xTransfer, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hTransfer = intMetadataClass.newTransferOption

                  # MD_DigitalTransferOptions (required)
                  # <element name="MD_DigitalTransferOptions" substitutionGroup="gco:AbstractObject"
                  # type="mrd:MD_DigitalTransferOptions_Type">
                  xMdTransfer = xTransfer.xpath(@@transferXPath)[0]
                  if xMdTransfer.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'mrd:MD_DigitalTransferOptions\' '\
                        'is missing in mrd:distributorTransferOptions'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # :unitsOfDistribution (optional)
                  # <element minOccurs="0" name="unitsOfDistribution" type="gco:CharacterString_PropertyType">
                  xUnitDist = xMdTransfer.xpath(@@unitsOfDistXPath)[0]
                  hTransfer[:unitsOfDistribution] = xUnitDist.nil? ? nil : xUnitDist.text

                  # :transferSize (optional)
                  # <element minOccurs="0" name="transferSize" type="gco:Real_PropertyType">
                  xTransferSize = xMdTransfer.xpath(@@transferSizeXPath)[0]
                  hTransfer[:transferSize] = xTransferSize.nil? ? nil : xTransferSize.text

                  # :onlineOptions (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="onLine"
                  # type="mcc:Abstract_OnlineResource_PropertyType">
                  xOnlineOptions = xMdTransfer.xpath(@@onlineXPath)
                  hTransfer[:onlineOptions] = xOnlineOptions.map { |o| OnlineResource.unpack(o, hResponseObj) }

                  # : distributionFormats (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="distributionFormat"
                  # type="mrd:MD_Format_PropertyType">
                  xDistFormat = xMdTransfer.xpath(@@distFormatXPath)

                  hTransfer[:distributionFormats] = xDistFormat.map { |f| Format.unpack(f, hResponseObj) }

                  # TODO: (not required by dcatus writer)
                  # offlineOptions: [],
                  # transferFrequency: {},

                  hTransfer
               end
            end
         end
      end
   end
end
