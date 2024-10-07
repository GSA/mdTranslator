require 'jbuilder'

module ADIWG
   module Mdtranslator
      module Writers
         module Dcat_us
            module SystemOfRecords

               def self.build(intObj)
                  associatedResources = intObj.dig(:metadata, :associatedResources)
                  return nil if associatedResources.nil?
                  
                  associatedResources.each do |resource|
                     # TODO: does this string check need to be expanded for ISO 19115-2 docs?
                    if resource[:initiativeType] == 'sorn'
                      onlineResources = resource.dig(:resourceCitation, :onlineResources)
                      return onlineResources.first[:olResURI] if onlineResources&.first&.has_key?(:olResURI)
                    end
                  end
                  
                  return nil
               end

            end
         end
      end
   end
end
