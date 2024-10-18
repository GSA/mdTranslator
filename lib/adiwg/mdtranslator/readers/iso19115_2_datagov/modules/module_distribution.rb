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

                  # MD_Distribution (required)
                  # <element name="MD_Distribution" substitutionGroup="mcc:Abstract_Distribution"
                  # type="gmd:MD_Distribution_Type">
                  xDistribution = xDistInfo.xpath(@@distributionXPath)[0]
                  if xDistribution.nil?
                     msg = "WARNING: ISO19115-2 reader: element '#{@@distributionXPath}'" \
                        "is missing in #{xDistInfo.name}"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # :distributor (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="distributor" type="gmd:MD_Distributor_PropertyType"/>
                  xDistributors = xDistribution.xpath(@@distributorXPath)
                  hDistribution[:distributor] = xDistributors.map { |d| Distributor.unpack(d, hResponseObj) }

                  # :transferOptions (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="distributorTransferOptions" type="gmd:MD_DigitalTransferOptions_PropertyType"/>
                  xTransfers = xDistribution.xpath(@@transferOptionsXPath)
                  # TODO: should we only set transfer options on the first distributor?
                  if hDistribution[:distributor][0][:transferOptions].empty?
                     hDistribution[:distributor][0][:transferOptions] = xTransfers.map do |t|
                        Transfer.unpack(t, hResponseObj)
                     end
                  end

                  # : distributionFormats (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="distributionFormat" type="gmd:MD_Format_PropertyType">
                  xDistFormat = xDistribution.xpath(@@distributionFormatXPath)
                  unless xDistFormat.empty?
                     distributionFormats = xDistFormat.map { |f| Format.unpack(f, hResponseObj) }

                     if !distributionFormats.compact.empty? && !hDistribution[:distributor][0][:transferOptions].compact.empty?
                        hDistribution[:distributor][0][:transferOptions].map.with_index do |opts, idx|
                           opts[:distributionFormats] = [distributionFormats[idx]]
                        end
                     end
                  end

                  hDistribution
               end
            end
         end
      end
   end
end
