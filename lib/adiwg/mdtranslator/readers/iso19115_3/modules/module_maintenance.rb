# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Maintenance
               @@maintenanceInfoXPath = 'mmi:MD_MaintenanceInformation'
               @@frequencyXPath = 'mmi:maintenanceAndUpdateFrequency//mmi:MD_MaintenanceFrequencyCode'
               def self.unpack(xMaintenance, _hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hMaintenance = intMetadataClass.newMaintenance

                  xMaintenanceInfo = xMaintenance.xpath(@@maintenanceInfoXPath)[0]
                  return nil if xMaintenanceInfo.nil?

                  # only thing dcatus needs
                  # :frequency (optional)
                  # <element minOccurs="0" name="maintenanceAndUpdateFrequency"
                  # type="mmi:MD_MaintenanceFrequencyCode_PropertyType">
                  xFrequency = xMaintenanceInfo.xpath(@@frequencyXPath)[0]
                  hMaintenance[:frequency] = xFrequency.nil? ? nil : xFrequency.attr('codeListValue')

                  # TODO: as needed
                  #    dates: [],
                  #    scopes: [],
                  #    notes: [],
                  #    contacts: []

                  hMaintenance
               end
            end
         end
      end
   end
end
