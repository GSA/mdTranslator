# frozen_string_literal: true

require 'nokogiri'
require 'uuidtools'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative '../version'
require_relative 'module_metadata'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Iso191153
               def self.unpack(xMetadata, hResponseObj)
                  intMetadataClass = InternalMetadata.new

                  intObj = intMetadataClass.newBase
                  @intObj = intObj

                  # :schema
                  hSchema = intMetadataClass.newSchema
                  hSchema[:name] = 'iso19115_3'
                  hSchema[:version] = ADIWG::Mdtranslator::Readers::Iso191153::VERSION
                  @intObj[:schema] = hSchema

                  hMetadata = Metadata.unpack(xMetadata, hResponseObj)
                  @intObj[:metadata] = hMetadata

                  # :contacts # TODO
                  # @intObj[:contacts] = nil
                  # intObj[:contacts] = [{'contactId': 'test', 'name': 'test', 'eMailList':
                  # ['test@gmail.com'], 'externalIdentifier': []}]

                  # :dataDictionaries
                  # @intObj[:dataDictionaries] = [] # TODO

                  # :metadataRepositories
                  # @intObj[:metadataRepositories] = [] # TODO

                  intObj
               end

               # find the array pointer and type for a contact
               def self.find_contact_by_id(contactId)
                  contactIndex = nil
                  contactType = nil
                  unless @contacts.empty?
                     @contacts.each_with_index do |contact, i|
                        next unless contact[:contactId] == contactId

                        contactType = if contact[:isOrganization]
                                         'organization'
                                      else
                                         'individual'
                                      end
                        contactIndex = i
                     end
                  end
                  [contactIndex, contactType]
               end

               # find contact id for a name
               def self.find_contact_by_name(contactName)
                  @contacts.each do |contact|
                     return contact[:contactId] if contact[:name] == contactName
                  end
                  nil
               end

               # add new contact to contacts array
               def self.add_contact(name, isOrg)
                  contactId = find_contact_by_name(name)
                  if contactId.nil?
                     intMetadataClass = InternalMetadata.new
                     hContact = intMetadataClass.newContact
                     contactId = UUIDTools::UUID.random_create.to_s
                     hContact[:contactId] = contactId
                     hContact[:name] = name
                     hContact[:isOrganization] = isOrg
                     @contacts << hContact
                  end
                  contactId
               end

               # return contact by id
               def self.get_contact_by_id(contactId)
                  index = find_contact_by_id(contactId)[0]
                  return @contacts[index] unless index.nil?

                  nil
               end

               # add or replace the contact
               def self.set_contact(hContact)
                  index = find_contact_by_id(hContact[:contactId])[0]
                  if index.nil?
                     @contacts << hContact
                     index = @contacts.length - 1
                  else
                     @contacts[index] = hContact
                  end
                  index
               end

               # set an internal object for tests
               def self.set_intobj(intObj)
                  @intObj = intObj
                  @contacts = @intObj[:contacts]
               end

               # get internal object
               def self.get_intobj
                  @intObj
               end

               # get metadata time convention
               def self.get_metadata_time_convention
                  @xDoc.xpath('./metadata/metainfo/mettc').text
               end

               # set @xDoc for minitests
               def self.set_xdoc(xDoc)
                  @xDoc = xDoc
               end

               # add new associated resource
               def self.add_associated_resource(hResource)
                  @intObj[:metadata][:associatedResources] << hResource
               end
            end
         end
      end
   end
end