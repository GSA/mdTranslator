module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module Identifier
          def self.build(intObj)
            opt1 = intObj.dig(:metadata, :metadataInfo, :metadataIdentifier, :identifier)
            return opt1 unless opt1.nil?

            intObj.dig(:metadata, :resourceInfo, :citation, :title)
          end
        end
      end
    end
  end
end
