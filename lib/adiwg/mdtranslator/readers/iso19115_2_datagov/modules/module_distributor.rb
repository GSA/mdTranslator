# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_transfer'
require_relative 'module_format'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152datagov
            module Distributor
               @@distributorXPath = 'gmd:MD_Distributor'
               @@distributorTransferOptionsXpath = 'gmd:distributorTransferOptions'
               @@distributorFormatOptionsXpath = 'gmd:distributorFormat'
               def self.unpack(xDistributor, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hDistributor = intMetadataClass.newDistributor

                  xMdDistributor = xDistributor.xpath(@@distributorXPath)[0]
                  if xMdDistributor.nil?
                     msg = 'WARNING: ISO19115-2 reader: element \'gmd:MD_Distributor\' '\
                        'is missing in gmd:distributor'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # distributorTransferOptions (optional)
                  # <xs:element name="distributorTransferOptions" type="gmd:MD_DigitalTransferOptions_PropertyType" minOccurs="0" maxOccurs="unbounded"/>
                  xDistrTransferOptions = xMdDistributor.xpath(@@distributorTransferOptionsXpath)
                  hDistributor[:transferOptions] = xDistrTransferOptions.map { |t| Transfer.unpack(t, hResponseObj) }

                  # distributorFormat (optional)
                  # <xs:element name="distributorFormat" type="gmd:MD_Format_PropertyType" minOccurs="0" maxOccurs="unbounded"/>
                  xDistrFormats = xMdDistributor.xpath(@@distributorFormatOptionsXpath)
                  unless xDistrFormats.empty?
                     distributionFormats = xDistrFormats.map { |f| Format.unpack(f, hResponseObj) }
                     if !distributionFormats.compact.empty? && !hDistributor[:transferOptions].compact.empty?
                        hDistributor[:transferOptions].map.with_index do |opts, idx|
                           opts[:distributionFormats] = [distributionFormats[idx]]
                        end
                     end
                  end

                  # TODO: (not required by dcatus writer)
                  # :distributorContact (required, but not by DCAT-US)
                  # <xs:element name="distributorContact" type="gmd:CI_ResponsibleParty_PropertyType"/>

                  # :distributionOrderProcess (optional)
                  # <xs:element name="distributionOrderProcess" type="gmd:MD_StandardOrderProcess_PropertyType" minOccurs="0" maxOccurs="unbounded"/>

                  hDistributor
               end
            end
         end
      end
   end
end
