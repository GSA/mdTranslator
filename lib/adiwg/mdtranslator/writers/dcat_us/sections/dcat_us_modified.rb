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
            opt1 = dates.map { |d| d[:date] }.compact.sort!.last
            return opt1 unless opt1.nil?

            opt2 = intObj.dig(:metadata, :metadataInfo, :metadataDates, 0)
            return if opt2.nil?

            opt2.key?(:date) ? opt2[:date] : opt2[:dateTime]
          end
        end
      end
    end
  end
end
