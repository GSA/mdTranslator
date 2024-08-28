# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_responsibility'
require_relative 'module_order'
require_relative 'module_transfer'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Distributor
               @@distributorXPath = 'mrd:MD_Distributor'
               @@distributorContactXPath = 'mrd:distributorContact'
               @@distOrderXPath = 'mrd:distributionOrderProcess'
               @@distTransferXPath = 'mrd:distributorTransferOptions'
               def self.unpack(xDistributor, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hDistributor = intMetadataClass.newDistributor

                  # MD_Distributor (required)
                  # <element name="MD_Distributor" substitutionGroup="gco:AbstractObject"
                  # type="mrd:MD_Distributor_Type">
                  xMdDistributor = xDistributor.xpath(@@distributorXPath)[0]
                  if xMdDistributor.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'mrd:MD_Distributor\' '\
                        'is missing in mrd:distributor'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # :contact (required)
                  # <element name="distributorContact" type="mcc:Abstract_Responsibility_PropertyType">
                  xDistContact = xMdDistributor.xpath(@@distributorContactXPath)[0]
                  if xDistContact.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'mrd:distributorContact\' '\
                        'is missing in mrd:MD_Distributor'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  hDistributor[:contact] = Responsibility.unpack(xDistContact, hResponseObj)

                  # :orderProcess (optional) []
                  # <element maxOccurs="unbounded" minOccurs="0" name="distributionOrderProcess"
                  # type="mcc:Abstract_StandardOrderProcess_PropertyType"/>
                  xOrders = xMdDistributor.xpath(@@distOrderXPath)
                  hDistributor[:orderProcess] = xOrders.map { |o| Order.unpack(o, hResponseObj) }

                  # :transferOptions (optional) []
                  # <element maxOccurs="unbounded" minOccurs="0" name="distributorTransferOptions"
                  # type="mrd:MD_DigitalTransferOptions_PropertyType"/>
                  xTransfers = xMdDistributor.xpath(@@distTransferXPath)
                  hDistributor[:transferOptions] = xTransfers.map { |t| Transfer.unpack(t, hResponseObj) }

                  hDistributor
               end
            end
         end
      end
   end
end
