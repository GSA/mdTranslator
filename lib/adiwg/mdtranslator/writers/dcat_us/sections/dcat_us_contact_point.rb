require 'jbuilder'

module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module ContactPoint
          def self.build(intObj)
            resourceInfo = intObj[:metadata][:resourceInfo]
            pointOfContact = resourceInfo[:pointOfContacts][0]

            fn = ''
            hasEmail = ''

            return if pointOfContact.nil?

            contactId = pointOfContact[:parties][0][:contactId]

            contact = Dcat_us.get_contact_by_id(contactId)
            fn = contact[:name]
            hasEmail = contact[:eMailList][0]

            # there's an email and it doesn't already start with "mailto:"
            hasEmail = "mailto:#{hasEmail}" if !hasEmail.nil? && (!hasEmail.start_with? 'mailto:')

            Jbuilder.new do |json|
              json.set!('@type', 'vcard:Contact')
              json.set!('fn', fn)
              json.set!('hasEmail', hasEmail)
            end
          end
        end
      end
    end
  end
end
