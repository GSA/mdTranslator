# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_distributor'
require_relative 'module_transfer'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191152datagov
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

            # we're not doing anything with formats. we let the harvester determine the format.
            # : distributionFormats (optional)
            # <element maxOccurs="unbounded" minOccurs="0" name="distributionFormat"
            # type="gmd:MD_Format_PropertyType">
            # xDistFormat = xDistribution.xpath(@@distributionFormatXPath)
            # distributionFormats = xDistFormat.map { |f| Format.unpack(f, hResponseObj) }.compact

            # distributors and certain distributions/resources are siblings. the internal md object
            # doesn't support that. distributions need to be within a distributor so we're putting
            # the distributions without a distributor within the first one
            unless hDistribution[:distributor].empty?
              hDistribution[:distributor][0][:transferOptions] += transferOptions
            end

            hDistribution
          end
        end
      end
    end
  end
end
