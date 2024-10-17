# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_scope_description'
require_relative 'module_extent'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Scope
               @@scopeXPath = 'mcc:MD_Scope'
               @@levelXPath = 'mcc:level//mcc:MD_ScopeCode'
               @@extentXPath = 'mcc:extent'
               @@scopeDescXPath = 'mcc:levelDescription'
               def self.unpack(xCommonConstraint, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hScope = intMetadataClass.newScope

                  xConstraintScope = xCommonConstraint.xpath(@@scopeXPath)[0]
                  nil unless xConstraintScope.nil?

                  # :scopeCode (required)
                  xLevel = xConstraintScope.xpath(@@levelXPath)
                  if xLevel.nil?
                     msg = 'ERROR: ISO19115-3 reader: element \'mcc:level\' is missing inside mcc:MD_Scope'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                  else
                     hScope[:scopeCode] = xLevel.attr('codeListValue').text
                  end

                  # :scopeDescriptions
                  xLevelDesc = xConstraintScope.xpath(@@scopeDescXPath)
                  hScope[:scopeDescriptions] = xLevelDesc.map { |d| ScopeDescription.unpack(d, hResponseObj) }

                  # :extents
                  xExtents = xConstraintScope.xpath(@@extentXPath)
                  hScope[:extents] = xExtents.map { |e| Extent.unpack(e, hResponseObj) }

                  hScope
               end
            end
         end
      end
   end
end
