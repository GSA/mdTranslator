require 'jbuilder'
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
              onlineResources += resource[:resourceCitation][:onlineResources]
            end

            resourceDistributions3&.each do |resource|
              onlineResources += resource[:thesaurus][:onlineResources]
            end

            onlineResources.uniq! # removes duplicates in-place

            distributions = []

            onlineResources&.each do |option|
              # mediaType = MediaType.build(transfer)
              # TODO: change this when mediatype conversion works.
              # the mediatype needs to be set if there's a downloadURL
              mediaType = 'placeholder/value'

              next unless option[:olResURI]

              description = option[:olResDesc] || nil
              accessURL = AccessURL.build(option)
              downloadURL = DownloadURL.build(option)
              title = option[:olResName] || nil

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
