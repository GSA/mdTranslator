# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module Format
               @@formatXPath = 'gmd:MD_Format'
               @@formatNameXPath = 'gmd:name//gco:CharacterString'
               def self.unpack(xDistFormat, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hFormat = intMetadataClass.newResourceFormat

                  # MD Format (required)
                  xFormat = xDistFormat.xpath(@@formatXPath)[0]

                  if xFormat.nil?
                     msg = 'WARNING: ISO19115-2 reader: element \'gmd:MD_Format\' '\
                        'is missing in \'gmd:distributionFormat\''
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return hFormat
                  end

                  # :name (required)
                  # <xs:element name="specification" type="gco:CharacterString_PropertyType" minOccurs="0"/>
                  name = xFormat.xpath(@@formatNameXPath)[0]
                  if name.nil?
                     msg = "WARNING: ISO19115-2 reader: element \'#{@@formatNameXPath}\' "\
                        "is missing in \'#{xFormat.name}\'"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # TODO: confirm this pathing
                  hFormat[:formatSpecification][:title] = name.text

                  # TODO: (not required by dcatus writer)
                  # :version (required)
                  # :amendmentNumber (optional)
                  # :specification (optional)
                  # fileDecompressionTechnique (optional)
                  # :formatDistributor (optional)

                  hFormat
               end
            end
         end
      end
   end
end