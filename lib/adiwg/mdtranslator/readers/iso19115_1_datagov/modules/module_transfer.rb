# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_online_resource'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191151datagov
        module Transfer
          @@transferXPath = 'gmd:MD_DigitalTransferOptions'
          @@onlineXPath = 'gmd:onLine'
          def self.unpack(xTransfer, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hTransfer = intMetadataClass.newTransferOption

            # MD_DigitalTransferOptions (optional)
            # <xs:sequence minOccurs="0">
            #   <xs:element ref="gmd:MD_DigitalTransferOptions"/>
            # </xs:sequence>
            xMdTransfer = xTransfer.xpath(@@transferXPath)[0]
            return nil if xMdTransfer.nil?

            # :onlineOptions (optional)
            # <element maxOccurs="unbounded" minOccurs="0" name="onLine"
            # type="mcc:Abstract_OnlineResource_PropertyType">
            xOnlineOptions = xMdTransfer.xpath(@@onlineXPath)
            hTransfer[:onlineOptions] = xOnlineOptions.map do |o|
              OnlineResource.unpack(o, hResponseObj)
            end.compact

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
