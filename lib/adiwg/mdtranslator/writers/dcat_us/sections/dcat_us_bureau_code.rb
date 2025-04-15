require 'jbuilder'

module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module BureauCode
          def self.build(intObj)
            responsibleParties = intObj[:metadata][:resourceInfo][:citation][:responsibleParties]
            contacts = []
            responsibleParties.each do |party|
              contactId = party[:parties][0][:contactId]
              contacts << Dcat_us.get_contact_by_id(contactId)
            end

            bureauContacts = contacts&.select do |contact|
              contact[:externalIdentifier].any? do |id|
                id[:namespace] == 'bureauCode'
              end
            end

            bureauCodes = []
            bureauContacts.each do |contact|
              bureauCode = contact[:externalIdentifier].find { |id| id[:namespace] == 'bureauCode' }
              bureauCodes << bureauCode[:identifier]
            end

            return nil if bureauCodes.empty?

            bureauCodes
          end
        end
      end
    end
  end
end
