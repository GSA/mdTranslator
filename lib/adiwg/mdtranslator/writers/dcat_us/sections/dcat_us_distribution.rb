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
              accessURL = AccessURL.access_url?(option)
              # if it's not a web page and it has a file extension then let's assume it's a downloadable file
              downloadURL = DownloadURL.download_url?(option) unless accessURL

              # no point in creating a distribution if there's no link
              next unless accessURL || downloadURL

              # at this point one is true
              linkData = accessURL ? ['accessURL', option[:olResURI]] : ['downloadURL', option[:olResURI]]

              # if there's a downloadURL there has to be a mediaType in dcatus 1.1 so using a placeholder
              mediaType = accessURL ? 'text/html' : 'placeholder/value'

              title = AdiwgUtils.empty_string_to_nil(option[:olResName])

              distribution = Jbuilder.new do |json|
                json.set!('@type', 'dcat:Distribution')
                json.set!('description', description)
                json.set!(*linkData)
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
