module ADIWG
   module Mdtranslator
      module Writers
         module Dcat_us
            module Keyword
 
               def self.build(intObj)
                  resourceInfo = intObj.dig(:metadata, :resourceInfo)
                  keywords = resourceInfo&.dig(:keywords)
                
                  return keywords&.flat_map { |keyword| keyword[:keywords]&.map { |kw| kw[:keyword] } } || []
                end                
                
            end
         end
      end
   end
end
 