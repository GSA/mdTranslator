# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191152datagov
        module Format
          @@formatXPath = 'gmd:MD_Format'
          @@formatNameXPath = 'gmd:name'
          def self.unpack(xDistFormat, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hFormat = intMetadataClass.newResourceFormat

            # MD Format (optional)
            # <xs:sequence minOccurs="0">
            #   <xs:element ref="gmd:MD_Format"/>
            # </xs:sequence>
            xFormat = xDistFormat.xpath(@@formatXPath)[0]
            return nil if xFormat.nil?

            # :name (required)
            # <xs:element name="name" type="gco:CharacterString_PropertyType"/>
            xName = xFormat.xpath(@@formatNameXPath)[0]
            if xName.nil?
              msg = "WARNING: ISO19115-2 reader: element \'#{@@formatNameXPath}\' "\
                 "is missing in \'#{xFormat.name}\'"
              hResponseObj[:readerValidationMessages] << msg
              hResponseObj[:readerValidationPass] = false
            else

              # all CharacterString are optional
              # <xs:sequence minOccurs="0">
              #   <xs:element ref="gco:CharacterString"/>
              # </xs:sequence>
              xStr = xName.xpath('gco:CharacterString')[0]

              if xStr.nil? && !AdiwgUtils.valid_nil_reason(xName, hResponseObj)
                msg = "WARNING: ISO19115-2 reader: element \'#{xName.name}\' "\
                 "is missing valid nil reason within \'#{xFormat.name}\'"
                hResponseObj[:readerValidationMessages] << msg
                hResponseObj[:readerValidationPass] = false
              end

              hFormat[:formatSpecification][:title] = xStr.text.strip unless xStr.nil?
            end

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
