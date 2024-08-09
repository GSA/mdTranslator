require 'jbuilder'

module ADIWG
   module Mdtranslator
      module Writers
         module Dcat_us
            module ContactPoint
               def self.build(intObj)
                  resourceInfo = intObj[:metadata][:resourceInfo]
                  pointOfContact = resourceInfo[:pointOfContacts][0]
                  contactId = pointOfContact[:parties][0][:contactId]

                  # contact = Dcat_us.get_contact_by_id(contactId)

                  intObj[:contacts].each do |hContact|
                     next unless hContact[:contactId] == contactId

                     fn = hContact[:name]
                     hasEmail = hContact[:eMailList][0]

                     Jbuilder.new do |json|
                        json.set!('@type', 'vcard:Contact')
                        json.set!('fn', fn)
                        json.set!('hasEmail', hasEmail)
                        return json
                     end
                  end
               end
            end
         end
      end
   end
end
