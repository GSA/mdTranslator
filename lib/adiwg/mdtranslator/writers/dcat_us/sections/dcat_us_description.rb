module ADIWG
   module Mdtranslator
      module Writers
         module Dcat_us
            module Description
               def self.build(intObj)
                  resourceInfo = intObj.dig(:metadata, :resourceInfo)
                  description = resourceInfo&.dig(:abstract)

                  return description if description

                  nil
               end
            end
         end
      end
   end
end
