require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative '../version'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso19115_3

            module Iso19115_3
               def self.unpack(xDoc, hResponseObj)

                  # instance classes needed in script
                  intMetadataClass = InternalMetadata.new

                  intObj = intMetadataClass.newBase
                  @intObj = intObj

                  # build basic mdTranslator internal object
                  hMetadata = intMetadataClass.newMetadata
                  hResourceInfo = intMetadataClass.newResourceInfo
                  hDataQuality = intMetadataClass.newDataQuality
                  hMetadata[:resourceInfo] = hResourceInfo
                  intObj[:metadata] = hMetadata

                  # schema
                  hSchema = intMetadataClass.newSchema
                  hSchema[:name] = 'iso19115_3'
                  hSchema[:version] = ADIWG::Mdtranslator::Readers::Iso19115_3::VERSION
                  @intObj[:schema] = hSchema

									# everything below is temporary just to ensure the process completes
									# when writing to dcat_us
                  intObj[:metadata][:resourceInfo][:citation][:dates] = []

									intObj[:contacts] = [{'contactId': 'test', 'name': 'test', 'eMailList': ['test@gmail.com'], 'externalIdentifier': []}]
									intObj[:metadata][:resourceInfo][:pointOfContacts] = [{'parties':[{'contactId': 'test'}]}]
								  
									intObj[:metadata][:resourceInfo][:citation][:identifiers] = {}
									intObj[:metadata][:resourceInfo][:citation][:onlineResources] = {}

									intObj[:metadata][:metadataInfo][:metadataMaintenance] = {} 
									intObj[:metadata][:metadataInfo][:metadataMaintenance][:frequency] = 'hourly'
									
									intObj[:metadata][:metadataInfo][:metadataIdentifier] = {}
									intObj[:metadata][:metadataInfo][:metadataIdentifier][:identifier] = nil

									intObj[:metadata][:resourceInfo][:citation][:responsibleParties] = [{'parties':[{'contactId': 'test'}]}]  

                  return intObj
               end
            end
        end
      end
   end
end
