# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module OnlineResource
               @@ciOnlineResourceXPath = 'gmd:CI_OnlineResource'
               @@linkageXPath = 'gmd:linkage//gmd:URL'
               @@protocolXPath = 'gmd:protocol//gco:CharacterString'
               @@appProfileXPath = 'gmd:applicationProfile//gco:CharacterString'
               @@nameXPath = 'gmd:name//gco:CharacterString'
               @@descXPath = 'gmd:description//gco:CharacterString'
               @@funcXPath = 'gmd:function//gmd:CI_OnLineFunctionCode'
               @@protocolReqXPath = 'gmd:protocolRequest//gco:CharacterString'
               def self.unpack(xParent, _hResponseObj)
                  # xParent because an online resource can occur within
                  # mcc:linkage or gmd:onlineResource
                  intMetadataClass = InternalMetadata.new
                  hOnlineResource = intMetadataClass.newOnlineResource

                  xCiOnelineResource = xParent.xpath(@@ciOnlineResourceXPath)

                  return nil if xCiOnelineResource.empty?

                  # :olResURI (optional)
                  xLink = xCiOnelineResource.xpath(@@linkageXPath)
                  hOnlineResource[:olResURI] = xLink.empty? ? nil : xLink[0].text

                  # :olResName (optional)
                  xName = xCiOnelineResource.xpath(@@nameXPath)
                  hOnlineResource[:olResName] = xName.empty? ? nil : xName[0].text

                  # :olResDesc (optional)
                  xDesc = xCiOnelineResource.xpath(@@descXPath)
                  hOnlineResource[:olResDesc] = xDesc.empty? ? nil : xDesc[0].text

                  # :olResFunction (optional)
                  xFunc = xCiOnelineResource.xpath(@@funcXPath)
                  hOnlineResource[:olResFunction] = xFunc.empty? ? nil : xFunc[0].attr('codeListValue')

                  # :olResApplicationProfile (optional)
                  xAppProfile = xCiOnelineResource.xpath(@@appProfileXPath)
                  hOnlineResource[:olResApplicationProfile] = xAppProfile.empty? ? nil : xAppProfile[0].text

                  # :olResProtocol (optional)
                  xProtocol = xCiOnelineResource.xpath(@@protocolXPath)
                  hOnlineResource[:olResProtocol] = xProtocol.empty? ? nil : xProtocol[0].text

                  # :olResProtocolRequest (optional)
                  xProtocolReq = xCiOnelineResource.xpath(@@protocolReqXPath)
                  hOnlineResource[:olResProtocolRequest] = xProtocolReq.empty? ? nil : xProtocolReq[0].text
                  hOnlineResource
               end
            end
         end
      end
   end
end
