require 'jbuilder'

module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module IsPartOf
          def self.build(intObj)
            associatedResources = intObj.dig(:metadata, :associatedResources)

            associatedResources.each do |resource|
              next unless resource[:associationType] == 'largerWorkCitation'

              return resource.dig(:resourceCitation, :title)
            end
            nil
          end
        end
      end
    end
  end
end
