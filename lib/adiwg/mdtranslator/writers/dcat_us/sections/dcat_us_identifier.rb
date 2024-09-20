module ADIWG
   module Mdtranslator
      module Writers
         module Dcat_us
            module Identifier

               def self.build(intObj)
                  identifier = intObj.dig(:metadata, :metadataInfo, :metadataIdentifier, :identifier)
                  return identifier unless identifier.nil?

                  citation = intObj.dig(:metadata, :resourceInfo, :citation)
                  identifiers = citation&.dig(:identifiers)
                  onlineResources = citation&.dig(:onlineResources)
                  uri = onlineResources.dig(0, :olResURI)
                
                  # uri is supposed to be more descriptive than identifiers
                  return uri unless uri.nil?
                  return identifiers[0][:identifier] unless identifiers.nil? || identifiers.empty?

                  nil
               end
            end
         end
      end
   end
end
