# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_citation'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module AdditionalDocument
               def self.unpack(xAdditionalDoc, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hAdditionalDoc = intMetadataClass.newAdditionalDocumentation

                  # citation (required)
                  # <element name="CI_Citation" substitutionGroup="mcc:Abstract_Citation"
                  # type="cit:CI_Citation_Type">
                  # the internal object is an array so wrapping it.
                  hAdditionalDoc[:citation] = [Citation.unpack(xAdditionalDoc, hResponseObj)]

                  if hAdditionalDoc[:citation].empty?
                     msg = 'WARNING: ISO19115-3 reader: element \'CI_Citation\''\
                     'is missing in mri:additionalDocumentation'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # TODO: when needed...
                  # resourceTypes: []

                  hAdditionalDoc
               end
            end
         end
      end
   end
end
