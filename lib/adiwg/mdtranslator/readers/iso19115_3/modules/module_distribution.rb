# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_distributor'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Distribution
               @@distributionXPath = 'mrd:MD_Distribution'
               @@descXPath = 'mrd:description//gco:CharacterString'
               @@distributorXPath = 'mrd:distributor'
               def self.unpack(xDistInfo, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hDistribution = intMetadataClass.newDistribution

                  # MD_Distribution (required)
                  # <element name="MD_Distribution" substitutionGroup="mcc:Abstract_Distribution"
                  # type="mrd:MD_Distribution_Type">
                  xDistribution = xDistInfo.xpath(@@distributionXPath)[0]
                  if xDistribution.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'mrd:MD_Distribution\' '\
                        'is missing in mdb:distributionInfo'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # :description (optional)
                  # <element minOccurs="0" name="description" type="gco:CharacterString_PropertyType"/>
                  xDesc = xDistribution.xpath(@@descXPath)[0]
                  hDistribution[:description] = xDesc.nil? ? nil : xDesc.text

                  # :distributor (optional)
                  # <element maxOccurs="unbounded" minOccurs="0" name="distributor"
                  # type="mrd:MD_Distributor_PropertyType"/>
                  xDistributors = xDistribution.xpath(@@distributorXPath)
                  hDistribution[:distributor] = xDistributors.map { |d| Distributor.unpack(d, hResponseObj) }

                  # :liabilityStatement not processing in the writer
                  # distribution - transfer options - supported under distributor
                  # distribution - distribution format - supported under distributor

                  hDistribution
               end
            end
         end
      end
   end
end
