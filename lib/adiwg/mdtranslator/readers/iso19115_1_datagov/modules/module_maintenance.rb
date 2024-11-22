# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require 'adiwg/mdtranslator/internal/module_utils'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191151datagov
        module Maintenance
          @@maintenanceInfoXPath = 'gmd:MD_MaintenanceInformation'
          @@frequencyXPath = 'gmd:maintenanceAndUpdateFrequency'
          def self.unpack(xMaintenance, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hMaintenance = intMetadataClass.newMaintenance

            # MD_MaintenanceInformation (optional)
            # <xs:sequence minOccurs="0">
            #   <xs:element ref="gmd:MD_MaintenanceInformation"/>
            # </xs:sequence>
            xMaintenanceInfo = xMaintenance.xpath(@@maintenanceInfoXPath)[0]
            return nil if xMaintenanceInfo.nil?

            # only thing dcatus needs
            # :frequency (required)
            # <xs:element name="maintenanceAndUpdateFrequency"
            # type="gmd:MD_MaintenanceFrequencyCode_PropertyType"/>
            xFrequency = xMaintenanceInfo.xpath(@@frequencyXPath)[0]
            if xFrequency.nil?
              msg = "WARNING: ISO19115-1 reader: element \'#{@@frequencyXPath}\' "\
                 "is missing in #{xMaintenanceInfo.name}"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else

              xCode = xFrequency.xpath('gmd:MD_MaintenanceFrequencyCode')[0]

              if xCode.nil? && !AdiwgUtils.valid_nil_reason(xFrequency, hResponseObj)
                msg = "WARNING: ISO19115-1 reader: element \'#{xFrequency.name}\' "\
                 "is missing valid nil reason within \'#{xMaintenanceInfo.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end

              hMaintenance[:frequency] = xCode.attr('codeListValue') unless xCode.nil?
            end

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
