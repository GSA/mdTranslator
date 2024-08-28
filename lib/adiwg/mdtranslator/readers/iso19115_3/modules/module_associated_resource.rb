# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_citation'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module AssociatedResource
               @@associatedResourceXPath = 'mri:MD_AssociatedResource'
               @@associationTypeXPath = 'mri:associationType//mri:DS_AssociationTypeCode'
               @@initiativeTypeXPath = 'mri:initiativeType//mri:DS_InitiativeTypeCode'
               @@nameXPath = 'mri:name'
               def self.unpack(xAssociatedResourceParent, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hAssociatedResource = intMetadataClass.newAssociatedResource

                  xAssociatedResource = xAssociatedResourceParent.xpath(@@associatedResourceXPath)[0]

                  return nil if xAssociatedResource.nil?

                  # dcatus writer needs these

                  # :associationType (required)
                  # <element name="associationType" type="mri:DS_AssociationTypeCode_PropertyType">
                  xAssociatedType = xAssociatedResource.xpath(@@associationTypeXPath)[0]
                  if xAssociatedType.nil?
                     msg = 'WARNING: ISO19115-3 reader: element \'mri:DS_AssociationTypeCode\' '\
                        'is missing in mri:MD_AssociatedResource'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return nil
                  end

                  hAssociatedResource[:associationType] = xAssociatedType.attr('codeListValue')

                  # :initiativeType (optional)
                  # <element minOccurs="0" name="initiativeType"
                  # type="mri:DS_InitiativeTypeCode_PropertyType">
                  xInitiativeType = xAssociatedResource.xpath(@@initiativeTypeXPath)[0]
                  hAssociatedResource[:initiativeType] =
                     xInitiativeType.nil? ? nil : xInitiativeType.attr('codeListValue')

                  # :resourceCitation (optional)
                  # <element minOccurs="0" name="name" type="mcc:Abstract_Citation_PropertyType">
                  xName = xAssociatedResource.xpath(@@nameXPath)[0]
                  hAssociatedResource[:resourceCitation] = xName.nil? ? nil : Citation.unpack(xName, hResponseObj)

                  # TODO: remaining when needed...
                  # resourceTypes: [],
                  # metadataCitation: {}

                  hAssociatedResource
               end
            end
         end
      end
   end
end
