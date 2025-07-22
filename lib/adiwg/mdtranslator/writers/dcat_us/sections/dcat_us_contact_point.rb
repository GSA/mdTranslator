require 'jbuilder'

module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module ContactPoint
          def self.build(intObj)
            resourceInfo = intObj[:metadata][:resourceInfo]
            pointOfContactOpt1 = resourceInfo.dig(:pointOfContacts, 0, :parties, 0)
            pointOfContactOpt2 = intObj.dig(:metadata, :metadataInfo, :metadataContacts, 0, :parties, 0)
            options = [pointOfContactOpt1, pointOfContactOpt2].compact

            fn = ''
            hasEmail = ''

            options.each do |option|
              # skip if we already have a fullname and email
              next if !fn.empty? && !hasEmail.empty?

              # Dcat_us functions (parent module to ContactPoint) aren't available here
              # when unit testing so replicating the logic here.
              contact = intObj[:contacts].select { |c| c[:contactId] == option[:contactId] }[0]
              name = contact[:name]
              email = contact[:eMailList][0]

              next if email == 'None'

              if !name.nil? && !email.nil?
                fn = name
                hasEmail = email
              end
            end

            return nil if fn.empty? | hasEmail.empty?

            hasEmail = hasEmail.downcase.strip.gsub(/\s+/, '')

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
