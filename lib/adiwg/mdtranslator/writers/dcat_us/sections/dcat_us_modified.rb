module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module Modified
          def self.build(intObj)
            resourceInfo = intObj[:metadata][:resourceInfo]
            citation = resourceInfo[:citation]
            dates = citation[:dates]
            # pulling from path 3 instead of path 2 in the
            # iso19115 1 & 2 to dcatus mapping doc
            dates.map { |d| d[:date] }.compact.sort!.last
          end
        end
      end
    end
  end
end
