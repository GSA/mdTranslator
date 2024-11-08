require 'jbuilder'

module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module Issued
          def self.build(intObj)
            dates = intObj[:metadata][:resourceInfo][:citation][:dates]
            dates = dates.reject { |o| o[:date].nil? }.map { |o| o[:date] }

            dates.min
          end
        end
      end
    end
  end
end
