module ADIWG
   module Mdtranslator
      module Writers
         module Dcat_us
            module Temporal

               def self.build(intObj)
                  resourceInfo = intObj.dig(:metadata, :resourceInfo)
                  extent = resourceInfo&.dig(:extents, 0)
                  temporalExtents = extent&.dig(:temporalExtents)

                  if temporalExtents.nil? || temporalExtents.empty?
                     extents = resourceInfo&.dig(:extents)
                     if extents && extents.size > 1
                       extent_with_temporal = extents[1..].find { |e| e.dig(:temporalExtents) }
                       temporalExtents = extent_with_temporal&.dig(:temporalExtents)
                     end
                  end

                  if temporalExtents
                    temporalExtents.each do |temporalExtent|
                      timePeriod = temporalExtent&.dig(:timePeriod)
                      next unless timePeriod
                
                      startDateHash = timePeriod[:startDateTime]
                      endDateHash = timePeriod[:endDateTime]
                      
                      startDate = startDateHash&.dig(:dateTime)
                      endDate = endDateHash&.dig(:dateTime)

                      if startDate && endDate
                        return "#{startDate}/#{endDate}"
                      elsif startDate
                        return startDate
                      elsif endDate
                        return endDate
                      end
                    end
                  end
                
                  nil
               end

            end
         end
      end
   end
end
