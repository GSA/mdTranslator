# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_distributor'
require_relative 'module_transfer'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191151datagov
        module Distribution
          @@distributionXPath = 'gmd:MD_Distribution'
          @@descXPath = 'gmd:description//gco:CharacterString'
          @@distributorXPath = 'gmd:distributor'
          @@distributionFormatXPath = 'gmd:distributionFormat'
          @@transferOptionsXPath = 'gmd:transferOptions'
          def self.unpack(xDistInfo, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hDistribution = intMetadataClass.newDistribution

            # MD_Distribution (optional)
            # <xs:sequence minOccurs="0">
            #   <xs:element ref="gmd:MD_Distribution"/>
            # </xs:sequence>
            xDistribution = xDistInfo.xpath(@@distributionXPath)[0]
            return nil if xDistribution.nil?

            # :distributor (optional)
            # <element maxOccurs="unbounded" minOccurs="0" name="distributor"
            # type="gmd:MD_Distributor_PropertyType"/>
            xDistributors = xDistribution.xpath(@@distributorXPath)
            hDistribution[:distributor] = xDistributors.map do |d|
              Distributor.unpack(d, hResponseObj)
            end.compact

            # :transferOptions (optional)
            # <element maxOccurs="unbounded" minOccurs="0" name="distributorTransferOptions"
            # type="gmd:MD_DigitalTransferOptions_PropertyType"/>
            xTransfers = xDistribution.xpath(@@transferOptionsXPath)
            transferOptions = xTransfers.map { |t| Transfer.unpack(t, hResponseObj) }.compact
            optionSize = transferOptions.size

            # : distributionFormats (optional)
            # <element maxOccurs="unbounded" minOccurs="0" name="distributionFormat"
            # type="gmd:MD_Format_PropertyType">
            xDistFormat = xDistribution.xpath(@@distributionFormatXPath)
            distributionFormats = xDistFormat.map { |f| Format.unpack(f, hResponseObj) }.compact
            formatSize = distributionFormats.size

            smallestArr = formatSize > optionSize ? transferOptions : distributionFormats

            hDistribution[:distributor].each do |distributor|
              (0...smallestArr.size).each do |idx|
                distributor[:transferOptions][idx] = transferOptions[idx]
                distributor[:transferOptions][idx][:distributionFormats] = [distributionFormats[idx]]
              end
            end

            hDistribution
          end
        end
      end
    end
  end
end
