require 'jbuilder'

module ADIWG
   module Mdtranslator
      module Writers
         module Dcat_us
            module LandingPage

               def self.build(intObj)
                  onlineResources = intObj.dig(:metadata, :resourceInfo, :citation, :onlineResources)
                  if onlineResources
                    onlineResources.each do |resource|
                     # TODO: revisit this with Chris
                      if resource.dig(:olResFunction) == 'landingPage' || 'information'
                        return resource.dig(:olResURI)
                      end
                    end
                  end
                  
                  return nil
                end                
                
            end
         end
      end
   end
end
