require 'jbuilder'

module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module DescribedByType
          def self.build(intObj)
            #  metadataInfo[:metadataOnlineOptions][0][:olResProtocol]
            dataDictionaries = intObj[:dataDictionaries]

            dataDictionaries.each do |datadictionary|
              next if datadictionary[:includedWithDataset]

              onlineResources = datadictionary[:citation][:onlineResources]
              onlineResources.each do |resource|
                return resource[:olResProtocol] if resource[:olResURI] && !resource[:olResURI].end_with?('.html')
              end
            end
            nil
          end
        end
      end
    end
  end
end
