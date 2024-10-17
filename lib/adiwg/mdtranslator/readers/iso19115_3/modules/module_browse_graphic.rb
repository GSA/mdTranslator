# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_online_resource'
require_relative 'module_constraint'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module BrowseGraphic
               @@nameXPath = 'mcc:fileName//gco:CharacterString'
               @@descXPath = 'mcc:fileDescription//gco:CharacterString'
               @@typeXPath = 'mcc:fileType//gco:CharacterString'
               @@browseGraphicXPath = 'mcc:MD_BrowseGraphic'
               @@imageConstraintsXPath = 'mcc:imageConstraints'
               @@linkageXPath = 'mcc:linkage'
               def self.unpack(xLogo, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hGraphic = intMetadataClass.newGraphic

                  xBrowseGraphic = xLogo.xpath(@@browseGraphicXPath)[0]

                  if xBrowseGraphic.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'mcc:MD_BrowseGraphic\' '\
                        'is missing in logo'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # :graphicName (required)
                  xName = xBrowseGraphic.xpath(@@nameXPath)[0]
                  if xName.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'mcc:fileName\' '\
                        'is missing in MD_BrowseGraphic'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  hGraphic[:graphicName] = xName.text

                  # :graphicDescription (optional)
                  xDesc = xBrowseGraphic.xpath(@@descXPath)[0]
                  hGraphic[:graphicDescription] = xDesc.nil? ? nil : xDesc.text

                  # :graphicType (optional)
                  xType = xBrowseGraphic.xpath(@@typeXPath)[0]
                  hGraphic[:graphicType] = xType.nil? ? nil : xType.text

                  # :graphicConstraints (optional)
                  xImageConstraints = xBrowseGraphic.xpath(@@imageConstraintsXPath)
                  unless xImageConstraints.empty?
                     hGraphic[:graphicConstraints] = xImageConstraints.map { |i| Constraint.unpack(i, hResponseObj) }
                  end

                  # :graphicURI (optional)
                  xLinkages = xBrowseGraphic.xpath(@@linkageXPath)
                  unless xLinkages.empty?
                     hGraphic[:xLinkage] = xLinkages.map do |l|
                        OnlineResource.unpack(l, hResponseObj)
                     end
                  end

                  hGraphic
               end
            end
         end
      end
   end
end
