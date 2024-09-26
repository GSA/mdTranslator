module ADIWG
   module Mdtranslator
      module Writers
         module Dcat_us
            module Rights

               def self.build(intObj, accessLevel)
                  resourceInfo = intObj.dig(:metadata, :resourceInfo)
                  constraints = resourceInfo&.dig(:constraints)
                
                  if accessLevel && ["restricted public", "non-public"].include?(accessLevel)
                    constraints&.each do |constraint|
                      if constraint[:type] == "use"
                        return constraint[:useLimitation].join(" ")
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
