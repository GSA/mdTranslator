# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module OnlineResource
               @@onlineResourceXPath = 'cit:onlineResource'
               @@ciOnlineResourceXPath = 'cit:CI_OnlineResource'
               @@linkageXPath = 'cit:linkage//gco:CharacterString'
               @@protocolXPath = 'cit:protocol//gco:CharacterString'
               @@appProfileXPath = 'cit:applicationProfile//gco:CharacterString'
               @@nameXPath = 'cit:name//gco:CharacterString'
               @@descXPath = 'cit:description//gco:CharacterString'
               @@funcXPath = 'cit:function'
               @@protocolReqXPath = 'cit:protocolRequest//gco:CharacterString'
               def self.unpack(xContact, _hResponseObj) # rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
                  onlineResources = []
                  xOnlineResources = xContact.xpath(@@onlineResourceXPath)

                  xOnlineResources.each do |xonlineresource|
                     intMetadataClass = InternalMetadata.new
                     hOnlineResource = intMetadataClass.newOnlineResource

                     xCiOnelineResource = xonlineresource.xpath(@@ciOnlineResourceXPath)

                     return hOnlineResource if xCiOnelineResource.empty?

                     # :olResURI
                     xLink = xCiOnelineResource.xpath(@@linkageXPath)
                     hOnlineResource[:olResURI] = xLink.empty? ? nil : xLink[0].text

                     # :olResName
                     xName = xCiOnelineResource.xpath(@@nameXPath)
                     hOnlineResource[:olResName] = xName.empty? ? nil : xName[0].text

                     # :olResDesc
                     xDesc = xCiOnelineResource.xpath(@@descXPath)
                     hOnlineResource[:olResDesc] = xDesc.empty? ? nil : xDesc[0].text

                     # :olResFunction
                     xFunc = xCiOnelineResource.xpath(@@funcXPath)
                     hOnlineResource[:olResFunction] = xFunc.empty? ? nil : xFunc[0].attr('codeListValue')

                     # :olResApplicationProfile
                     xAppProfile = xCiOnelineResource.xpath(@@appProfileXPath)
                     hOnlineResource[:olResApplicationProfile] = xAppProfile.empty? ? nil : xAppProfile[0].text

                     # :olResProtocol
                     xProtocol = xCiOnelineResource.xpath(@@protocolXPath)
                     hOnlineResource[:olResProtocol] = xProtocol.empty? ? nil : xProtocol[0].text

                     # :olResProtocolRequest
                     xProtocolReq = xCiOnelineResource.xpath(@@protocolReqXPath)
                     hOnlineResource[:olResProtocolRequest] = xProtocolReq.empty? ? nil : xProtocolReq[0].text

                     onlineResources << hOnlineResource
                  end
                  onlineResources
               end
            end
         end
      end
   end
end
