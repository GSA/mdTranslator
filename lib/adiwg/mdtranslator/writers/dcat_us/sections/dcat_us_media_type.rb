require 'jbuilder'

module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module MediaType
          def self.build(transfer)
            return unless transfer[:distributionFormats].size.positive?

            transfer[:distributionFormats][0][:formatSpecification][:title]
          end
        end
      end
    end
  end
end
