module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module Temporal
          def self.build(intObj)
            resourceInfo = intObj.dig(:metadata, :resourceInfo)
            extent = resourceInfo&.dig(:extents, 0)
            temporalExtents = extent&.dig(:temporalExtents)

            return nil if temporalExtents.nil?

            temporalExtents.each do |temporalExtent|
              timePeriod = temporalExtent&.dig(:timePeriod)
              timeInstant = temporalExtent&.dig(:timeInstant)
              next unless timePeriod && timeInstant

              startDate = timePeriod.dig(:startDateTime, :dateTime)
              endDate = timePeriod.dig(:endDateTime, :dateTime)

              startDate = timeInstant[:dateTime] if startDate.nil?

              startDate = AdiwgUtils.empty_string_to_nil(startDate)
              endDate = AdiwgUtils.empty_string_to_nil(endDate)

              if startDate && endDate
                return "#{startDate}/#{endDate}"
              elsif startDate
                return "#{startDate}/#{startDate}"
              elsif endDate
                return "#{endDate}/#{endDate}"
              end
            end

            nil
          end
        end
      end
    end
  end
end
