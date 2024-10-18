# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_online_resource'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152datagov
            module Transfer
               @@transferXPath = 'gmd:MD_DigitalTransferOptions'
               @@onlineXPath = 'gmd:onLine'
               def self.unpack(xTransfer, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hTransfer = intMetadataClass.newTransferOption

                  # MD_DigitalTransferOptions (required)
                  # <element name="MD_DigitalTransferOptions" substitutionGroup="gco:AbstractObject"
                  # type="gmd:MD_DigitalTransferOptions_Type">
                  xMdTransfer = xTransfer.xpath(@@transferXPath)[0]
                  if xMdTransfer.nil?
                     msg = "WARNING: ISO19115-2 reader: element \'#{@@transferXPath}' "\
                        "is missing in #{xTransfer.name}"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # :onlineOptions (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="onLine"
                  # type="mcc:Abstract_OnlineResource_PropertyType">
                  xOnlineOptions = xMdTransfer.xpath(@@onlineXPath)
                  hTransfer[:onlineOptions] = xOnlineOptions.map { |o| OnlineResource.unpack(o, hResponseObj) }

                  # TODO: (not required by dcatus writer)
                  # :unitsOfDistribution (optional)
                  # :transferSize (optional)
                  # offlineOptions: [],
                  # transferFrequency: {},

                  hTransfer
               end
            end
         end
      end
   end
end
