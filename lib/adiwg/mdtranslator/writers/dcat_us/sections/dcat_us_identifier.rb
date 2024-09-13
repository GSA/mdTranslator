module ADIWG
   module Mdtranslator
      module Writers
         module Dcat_us
            module Identifier

               def self.build(intObj)
                  citation = intObj.dig(:metadata, :resourceInfo, :citation)
                  identifiers = citation&.dig(:identifiers)
                  onlineResources = citation&.dig(:onlineResources)
                  uri = onlineResources.dig(0, :olResURI)
                
                  # return uri if it exists, or the first identifier found
                  return uri unless uri.nil?
                  return identifiers[0][:identifier] unless identifiers.nil? || identifiers.empty?

                  nil
               end
                                    

            end
         end
      end
   end
end
