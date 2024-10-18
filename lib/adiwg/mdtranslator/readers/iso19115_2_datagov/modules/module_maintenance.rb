require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152datagov
            module Maintenance
               @@maintenanceInfoXPath = 'gmd:MD_MaintenanceInformation'
               @@frequencyXPath = 'gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode'
               def self.unpack(xMaintenance, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hMaintenance = intMetadataClass.newMaintenance

                  xMaintenanceInfo = xMaintenance.xpath(@@maintenanceInfoXPath)[0]
                  return nil if xMaintenanceInfo.nil?

                  # only thing dcatus needs
                  # :frequency (required)
                  # <xs:element name="maintenanceAndUpdateFrequency" type="gmd:MD_MaintenanceFrequencyCode_PropertyType"/>
                  xFrequency = xMaintenanceInfo.xpath(@@frequencyXPath)[0]
                  if xFrequency.nil?
                     msg = "WARNING: ISO19115-2 reader: element \'#{@@frequencyXPath}\' "\
                        "is missing in #{xMaintenanceInfo.name}"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

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
