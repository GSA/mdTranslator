module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module Keyword
          def self.build(intObj)
            resourceInfo = intObj.dig(:metadata, :resourceInfo)
            keywords = resourceInfo&.dig(:keywords)
            keywords = keywords&.flat_map { |keyword| keyword[:keywords]&.map { |kw| kw[:keyword] } }

            keywords.reject(&:empty?)
          end
        end
      end
    end
  end
end
