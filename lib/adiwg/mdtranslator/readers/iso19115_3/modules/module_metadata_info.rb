# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_identification'
require_relative 'module_citation'
require_relative 'module_locale'
require_relative 'module_responsibility'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module MetadataInformation
               @@mdParentXpath = 'mdb:parentMetadata'
               @@mdIdentifier = 'mdb:metadataIdentifier'
               @@defaultLocaleXPath = 'mdb:defaultLocale'
               @@otherLocaleXPath = 'mdb:otherLocale'
               @@contactXPath = 'mdb:contact'
               def self.unpack(xMetadata, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  hMetadataInfo = intMetadataClass.newMetadataInfo

                  # :metadataIdentifier (optional)
                  xMetadataInfo = xMetadata.xpath(@@mdIdentifier)[0]
                  unless xMetadataInfo.nil?
                     hMetadataInfo[:metadataIdentifier] = Identification.unpack(xMetadataInfo, hResponseObj)[0]
                  end

                  # :parentMetadata (optional)
                  xMdParent = xMetadata.xpath(@@mdParentXpath)[0]
                  hMetadataInfo[:parentMetadata] = Citation.unpack(xMdParent, hResponseObj) unless xMdParent.nil?

                  # :defaultMetadataLocale (optional)
                  xDefaultLocale = xMetadata.xpath(@@defaultLocaleXPath)[0]
                  unless xDefaultLocale.nil?
                     hMetadataInfo[:defaultMetadataLocale] =
                        Locale.unpack(xDefaultLocale, hResponseObj)
                  end

                  # :otherMetadataLocales (optional)
                  xOtherLocales = xMetadata.xpath(@@otherLocaleXPath)
                  unless xOtherLocales.empty?
                     hMetadataInfo[:otherMetadataLocales] = xOtherLocales.map { |l| Locale.unpack(l, hResponseObj) }
                  end

                  # :metadataContacts (required)
                  xContacts = xMetadata.xpath(@@contactXPath)
                  if xContacts.empty?
                     msg = 'ERROR: ISO19115-3 reader: element \'mdb:contact\' is missing in mdb:MD_Metadata'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                  end

                  hMetadataInfo[:metadataContacts] = xContacts.map { |c| Responsibility.unpack(c, hResponseObj) }

                  # :metadataDates TODO
                  # :metadataLinkages TODO
                  # :metadataConstraints TODO
                  # :metadataMaintenance TODO
                  # :alternateMetadataReferences TODO
                  # :metadataStatus TODO
                  # :extensions TODO

                  hMetadataInfo
               end
            end
         end
      end
   end
end
