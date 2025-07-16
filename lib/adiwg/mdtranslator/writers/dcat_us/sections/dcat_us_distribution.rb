require 'jbuilder'
require 'adiwg/mdtranslator/internal/module_utils'

require_relative 'dcat_us_access_url'
require_relative 'dcat_us_download_url'
require_relative 'dcat_us_media_type'

module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module Distribution
          def self.build(intObj)
            resourceDistributions1 = intObj.dig(:metadata, :distributorInfo)
            resourceDistributions2 = intObj.dig(:metadata, :associatedResources)
            resourceDistributions3 = intObj.dig(:metadata, :resourceInfo, :keywords)
            resourceDistributions4 = intObj.dig(:metadata, :resourceInfo, :citation)
            resourceDistributions5 = intObj.dig(:metadata, :resourceInfo, :pointOfContacts, 0, :parties, 0)

            # gather up all our online resources from our options
            onlineResources = []

            resourceDistributions1&.each do |resource|
              resource[:distributor]&.each do |distributor|
                distributor[:transferOptions]&.each do |transfer|
                  transfer[:onlineOptions]&.each do |option|
                    onlineResources << option
                  end
                end
              end
            end

            resourceDistributions2&.each do |resource|
              data = resource.dig(:resourceCitation, :onlineResources)
              onlineResources += data unless data.nil?
            end

            resourceDistributions3&.each do |resource|
              unless resource[:thesaurus][:onlineResources].nil?
                onlineResources += resource[:thesaurus][:onlineResources]
              end
            end

            # citation in resource info is required. if it's missing we wouldn't get here.
            # but just in case
            unless resourceDistributions4[:onlineResources].nil?
              onlineResources += resourceDistributions4[:onlineResources]
            end

            unless resourceDistributions5.nil?
              contact = intObj[:contacts].select { |c| c[:contactId] == resourceDistributions5[:contactId] }[0]
              onlineResources += contact[:onlineResources]
            end

            # removes duplicates in-place by uri
            onlineResources.uniq! { |onlineresource| onlineresource[:olResURI] }

            distributions = []

            onlineResources&.each do |option|
              next unless option[:olResURI]

              description = AdiwgUtils.empty_string_to_nil(option[:olResDesc])
              accessURL = AccessURL.build(option)
              downloadURL = DownloadURL.build(option)
              # we calculate the mediaType in the harvester
              # because it's unreliable in the source
              # mediaType is required if downloadURL is present
              mediaType = 'placeholder/value' if downloadURL

              title = AdiwgUtils.empty_string_to_nil(option[:olResName])

              distribution = Jbuilder.new do |json|
                json.set!('@type', 'dcat:Distribution')
                json.set!('description', description)
                json.set!('accessURL', accessURL) if accessURL
                json.set!('downloadURL', downloadURL) if downloadURL
                json.set!('mediaType', mediaType)
                json.set!('title', title)
              end
              distributions << distribution.attributes!
            end
            distributions
          end
        end
      end
    end
  end
end
