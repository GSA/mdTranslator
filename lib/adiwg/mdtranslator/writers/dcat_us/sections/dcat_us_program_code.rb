require 'jbuilder'

module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module ProgramCode
          def self.build(intObj)
            responsibleParties = intObj[:metadata][:resourceInfo][:citation][:responsibleParties]
            contacts = []
            responsibleParties.each do |party|
              contactId = party[:parties][0][:contactId]
              contacts << Dcat_us.get_contact_by_id(contactId)
            end

            programContacts = contacts&.select do |contact|
              contact[:externalIdentifier].any? do |id|
                id[:namespace] == 'programCode'
              end
            end

            programsCodes = []
            programContacts.each do |contact|
              programCode = contact[:externalIdentifier].find { |id| id[:namespace] == 'programCode' }
              programsCodes << programCode[:identifier]
            end

            return nil if programsCodes.empty?

            programsCodes
          end
        end
      end
    end
  end
end
