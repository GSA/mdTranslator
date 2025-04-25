require 'jbuilder'

module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module ContactPoint
          def self.build(intObj)
            resourceInfo = intObj[:metadata][:resourceInfo]
            pointOfContact = resourceInfo.dig(:pointOfContacts, 0, :parties, 0)

            return if pointOfContact.nil?

            fn = ''
            hasEmail = ''

            # TODO: revisit contacts but this should do what we want for ISO
            # the idea here is to check in 2 spots for contact information. if the
            # first one doesn't contain both a non-nil full name (fn) and email
            # then attempt the other one.
            if pointOfContact.key?(:name)
              if !pointOfContact[:name].nil? && !pointOfContact[:eMailList][0].nil?
                fn = pointOfContact[:name]
                hasEmail = pointOfContact[:eMailList][0]
              else
                pointOfContact = intObj.dig(:metadata, :metadataInfo, :metadataContacts, 0, :parties, 0)
                unless pointOfContact.nil?
                  fn = pointOfContact[:name]
                  hasEmail = pointOfContact[:eMailList][0]
                end
              end
            else
              contactId = pointOfContact[:contactId]

              contact = Dcat_us.get_contact_by_id(contactId)

              fn = contact[:name]
              hasEmail = contact[:eMailList][0]
            end

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
