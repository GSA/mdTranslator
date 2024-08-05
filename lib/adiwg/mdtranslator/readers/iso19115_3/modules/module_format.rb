# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_citation'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Format
               @@formatXPath = 'mrd:MD_Format'
               @@formatCitationXPath = 'mrd:formatSpecificationCitation'
               def self.unpack(xDistFormat, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hFormat = intMetadataClass.newResourceFormat

                  # MD Format (required)
                  xFormat = xDistFormat.xpath(@@formatXPath)[0]

                  if xFormat.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'mrd:MD_Format\' '\
                        'is missing in \'mrd:distributionFormat\''
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # :formatSpecification (required)
                  # <element name="formatSpecificationCitation" type="mcc:Abstract_Citation_PropertyType">
                  xFormatSpecification = xFormat.xpath(@@formatCitationXPath)[0]

                  if xFormatSpecification.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'mrd:formatSpecificationCitation\' '\
                        'is missing in \'mrd:MD_Format\''
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  hFormat[:formatSpecification] = Citation.unpack(xFormatSpecification, hResponseObj)

                  # TODO
                  # amendmentNumber: nil,
                  # compressionMethod: nil,
                  # technicalPrerequisite: nil

                  hFormat
               end
            end
         end
      end
   end
end
