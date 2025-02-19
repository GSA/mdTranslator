module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module Rights
          def self.build(intObj, accessLevel)
            return unless ['restricted public', 'non-public'].include?(accessLevel)

            resourceInfo = intObj.dig(:metadata, :resourceInfo)
            constraints = resourceInfo&.dig(:constraints)

            output = []
            constraints&.each do |constraint|
              if constraint[:type] == 'legal'
                rights = constraint[:legalConstraint][:accessCodes]
                output += rights unless rights.nil?
              end
              if constraint[:type] == 'security'
                rights = constraint[:securityConstraint][:classCode]
                output += [rights] unless rights.nil?
              end
            end
            output.join(', ')
          end
        end
      end
    end
  end
end
