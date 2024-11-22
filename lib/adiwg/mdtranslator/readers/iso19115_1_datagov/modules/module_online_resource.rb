# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191151datagov
        module OnlineResource
          @@ciOnlineResourceXPath = 'gmd:CI_OnlineResource'
          @@linkageXPath = 'gmd:linkage'
          @@protocolXPath = 'gmd:protocol//gco:CharacterString'
          @@appProfileXPath = 'gmd:applicationProfile//gco:CharacterString'
          @@nameXPath = 'gmd:name//gco:CharacterString'
          @@descXPath = 'gmd:description//gco:CharacterString'
          @@funcXPath = 'gmd:function//gmd:CI_OnLineFunctionCode'
          def self.unpack(xParent, hResponseObj)
            # xParent because an online resource can occur within
            # mcc:linkage or gmd:onlineResource
            intMetadataClass = InternalMetadata.new
            hOnlineResource = intMetadataClass.newOnlineResource

            # CI_OnlineResource (optional)
            # <xs:sequence minOccurs="0">
            #   <xs:element ref="gmd:CI_OnlineResource"/>
            # </xs:sequence>
            xCiOnelineResource = xParent.xpath(@@ciOnlineResourceXPath)[0]
            return nil if xCiOnelineResource.nil?

            # :olResURI (required)
            # <xs:element name="linkage" type="gmd:URL_PropertyType"/>
            xLink = xCiOnelineResource.xpath(@@linkageXPath)[0]
            if xLink.nil?
              msg = "WARNING: ISO19115-1 reader: element \'#{@@linkageXPath}\' "\
                  "is missing in #{xCiOnelineResource.name}"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else

              # urls are optional
              # <xs:sequence minOccurs="0">
              #   <xs:element ref="gmd:URL"/>
              # </xs:sequence>
              xURI = xLink.xpath('gmd:URL')[0]

              if xURI.nil? && !AdiwgUtils.valid_nil_reason(xLink, hResponseObj)
                msg = "WARNING: ISO19115-1 reader: element \'#{xLink.name}\' "\
                 "is missing valid nil reason within \'#{xCiOnelineResource.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end

              hOnlineResource[:olResURI] = xURI.text.strip unless xURI.nil?
            end

            # :olResName (optional)
            # <xs:element name="name" type="gco:CharacterString_PropertyType" minOccurs="0"/>
            xName = xCiOnelineResource.xpath(@@nameXPath)[0]
            hOnlineResource[:olResName] = xName.text unless xName.nil?

            # :olResDesc (optional)
            # <xs:element name="description" type="gco:CharacterString_PropertyType" minOccurs="0"/>
            xDesc = xCiOnelineResource.xpath(@@descXPath)[0]
            hOnlineResource[:olResDesc] = xDesc.text unless xDesc.nil?

            # :olResFunction (optional)
            # <xs:element name="function" type="gmd:CI_OnLineFunctionCode_PropertyType" minOccurs="0"/>
            xFunc = xCiOnelineResource.xpath(@@funcXPath)[0]
            hOnlineResource[:olResFunction] = xFunc.attr('codeListValue') unless xFunc.nil?

            # :olResApplicationProfile (optional)
            # # <xs:element name="applicationProfile" type="gco:CharacterString_PropertyType" minOccurs="0"/>
            xAppProfile = xCiOnelineResource.xpath(@@appProfileXPath)[0]
            hOnlineResource[:olResApplicationProfile] = xAppProfile.text unless xAppProfile.nil?

            # :olResProtocol (optional)
            # <xs:element name="protocol" type="gco:CharacterString_PropertyType" minOccurs="0"/>
            xProtocol = xCiOnelineResource.xpath(@@protocolXPath)[0]
            hOnlineResource[:olResProtocol] = xProtocol.text unless xProtocol.nil?

            hOnlineResource
          end
        end
      end
    end
  end
end
