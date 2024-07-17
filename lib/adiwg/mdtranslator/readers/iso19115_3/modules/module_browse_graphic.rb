# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_online_resource'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module BrowseGraphic
               @@nameXPath = 'mcc:fileName//gco:CharacterString'
               @@descXPath = 'mcc:fileDescription//gco:CharacterString'
               @@typeXPath = 'mcc:fileType//gco:CharacterString'
               @@browseGraphicXPath = 'mcc:MD_BrowseGraphic'
               # @@constraintsXpath = 'mcc:imageConstraints' # TODO
               def self.unpack(xLogo, hResponseObj)
                  xBrowseGraphic = xLogo.xpath(@@browseGraphicXPath)[0]
                  intMetadataClass = InternalMetadata.new
                  hGraphic = intMetadataClass.newGraphic

                  if xBrowseGraphic.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'mcc:MD_BrowseGraphic\' '\
                        'is missing in logo'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     nil
                  end

                  # :graphicName ( required )
                  xName = xBrowseGraphic.xpath(@@nameXPath)[0]
                  if xName.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'mcc:fileName\' '\
                        'is missing in MD_BrowseGraphic'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     nil
                  end

                  hGraphic[:graphicName] = xName.text

                  # :graphicDescription
                  xDesc = xBrowseGraphic.xpath(@@descXPath)[0]
                  hGraphic[:graphicDescription] = xDesc.nil? ? nil : xDesc.text

                  # :graphicType
                  xType = xBrowseGraphic.xpath(@@typeXPath)[0]
                  hGraphic[:graphicType] = xType.nil? ? nil : xType.text

                  # :graphicConstraints TODO
                  # :graphicURI TODO

                  hGraphic
               end
            end
         end
      end
   end
end
