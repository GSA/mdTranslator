module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module Description
          def self.build(intObj)
            resourceInfo = intObj.dig(:metadata, :resourceInfo)
            resourceInfo&.dig(:abstract)
          end
        end
      end
    end
  end
end
