# ISO 19115-1 <<Class>> MD_Metadata
# 19115-1 writer output in XML.

# History:
# 	Stan Smith 2019-03-12 original script

require 'uuidtools'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative '../iso19115_1_writer'
require_relative 'class_codelist'
require_relative 'class_identifier'
require_relative 'class_citation'
require_relative 'class_responsibility'
require_relative 'class_date'
require_relative 'class_locale'
require_relative 'class_onlineResource'
require_relative 'class_coverageDescription'
require_relative 'class_imageDescription'
require_relative 'class_distribution'
require_relative 'class_lineage'
require_relative 'class_constraint'
require_relative 'class_dataIdentification'
require_relative 'class_maintenance'

module ADIWG
   module Mdtranslator
      module Writers
         module Iso19115_1

            class MD_Metadata

               def initialize(xml, hResponseObj)
                  @xml = xml
                  @hResponseObj = hResponseObj
                  @NameSpace = ADIWG::Mdtranslator::Writers::Iso19115_1
               end

               def writeXML(intObj)

                  # classes used
                  intMetadataClass = InternalMetadata.new
                  codelistClass = MD_Codelist.new(@xml, @hResponseObj)
                  identifierClass = MD_Identifier.new(@xml, @hResponseObj)
                  citationClass = CI_Citation.new(@xml, @hResponseObj)
                  responsibilityClass = CI_Responsibility.new(@xml, @hResponseObj)
                  dateClass = CI_Date.new(@xml, @hResponseObj)
                  localeClass = PT_Locale.new(@xml, @hResponseObj)
                  onlineClass = CI_OnlineResource.new(@xml, @hResponseObj)
                  dataIdClass = MD_DataIdentification.new(@xml, @hResponseObj)
                  coverageClass = MD_CoverageDescription.new(@xml, @hResponseObj)
                  imageClass = MD_ImageDescription.new(@xml, @hResponseObj)
                  distributionClass = MD_Distribution.new(@xml, @hResponseObj)
                  lineageClass = LI_Lineage.new(@xml, @hResponseObj)
                  constraintClass = Constraint.new(@xml, @hResponseObj)
                  maintenanceClass = MD_MaintenanceInformation.new(@xml, @hResponseObj)

                  # create shortcuts to sections of internal object
                  hMetadata = intObj[:metadata]
                  hMetaInfo = hMetadata[:metadataInfo]
                  hResInfo = hMetadata[:resourceInfo]
                  aDistributions = hMetadata[:distributorInfo]
                  aLineage = hMetadata[:lineageInfo]
                  version = @hResponseObj[:translatorVersion]

                  # document head
                  metadata = @xml.instruct! :xml, encoding: 'UTF-8'
                  @xml.comment!('ISO 19115-1 METADATA')
                  @xml.comment!('The following metadata file was constructed using the ADIwg mdTranslator, http://mdtranslator.adiwg.org')
                  @xml.comment!('mdTranslator software is an open-source project of the Alaska Data Integration working group (ADIwg)')
                  @xml.comment!('mdTranslator and other metadata tools are available at https://github.com/adiwg')
                  @xml.comment!('ADIwg is not responsible for the content of this metadata record')
                  @xml.comment!('This metadata record was generated by mdTranslator ' + version + ' at ' + Time.now.to_s)

                  # schema locations
                  # set to 'remoteSchema' before publishing
                  localSchema = 'C:\Users\StanSmith\Projects\ISO\19115\-3\mdt\1.0\mdt.xsd'
                  remoteSchema = '???'

                  # MD_Metadata
                  @xml.tag!('mdb:MD_Metadata',
                            {'xmlns:gml' => 'www.opengis.net/gml.3.2',
                             'xmlns:mdb' => 'http://standards.iso.org/iso/19115/-3/mdb/1.0',
                             'xmlns:gco' => 'http://standards.iso.org/iso/19115/-3/gco/1.0',
                             'xmlns:mcc' => 'http://standards.iso.org/iso/19115/-3/mcc/1.0',
                             'xmlns:lan' => 'http://standards.iso.org/iso/19115/-3/lan/1.0',
                             'xmlns:cit' => 'http://standards.iso.org/iso/19115/-3/cit/1.0',
                             'xmlns:gex' => 'http://standards.iso.org/iso/19115/-3/gex/1.0',
                             'xmlns:mco' => 'http://standards.iso.org/iso/19115/-3/mco/1.0',
                             'xmlns:mri' => 'http://standards.iso.org/iso/19115/-3/mri/1.0',
                             'xmlns:mrc' => 'http://standards.iso.org/iso/19115/-3/mrc/1.0',
                             'xmlns:mrd' => 'http://standards.iso.org/iso/19115/-3/mrd/1.0',
                             'xmlns:mda' => 'http://standards.iso.org/iso/19115/-3/mda/1.0',
                             'xmlns:mrl' => 'http://standards.iso.org/iso/19115/-3/mrl/1.0',
                             'xmlns:mrs' => 'http://standards.iso.org/iso/19115/-3/mrs/1.0',
                             'xmlns:msr' => 'http://standards.iso.org/iso/19115/-3/msr/1.0',
                             'xmlns:mmi' => 'http://standards.iso.org/iso/19115/-3/mmi/1.0',
                             'xmlns:srv' => 'http://standards.iso.org/iso/19115/-3/srv/2.0',
                             'xmlns:gfc' => 'http://standards.iso.org/iso/19110/gfc/1.1',
                             'xmlns:fcc' => 'http://standards.iso.org/iso/19110/fcc/1.0',
                             'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                             'xsi:schemaLocation' => "http://standards.iso.org/iso/19115/-3/mdt/1.0 #{localSchema}"}) do

                     # metadata information - metadata identifier {MD_Identifier} (default: UUID)
                     hMetadataId = hMetaInfo[:metadataIdentifier]
                     if hMetadataId.empty?
                        hMetadataId = intMetadataClass.newIdentifier
                        hMetadataId[:identifier] = UUIDTools::UUID.random_create.to_s
                        hMetadataId[:namespace] = 'UUID'
                     end
                     @xml.tag!('mdb:metadataIdentifier') do
                        identifierClass.writeXML(hMetadataId, 'metadata identifier')
                     end

                     # metadata information - default locale {PT_Locale} (default: USA, English, UTF-8)
                     hDefLocale = hMetaInfo[:defaultMetadataLocale]
                     if hDefLocale.empty?
                        hDefLocale = intMetadataClass.newLocale
                        hDefLocale[:languageCode] = 'eng'
                        hDefLocale[:countryCode] = 'USA'
                        hDefLocale[:characterEncoding] = 'UTF-8'
                     end
                     @xml.tag!('mdb:defaultLocale') do
                        localeClass.writeXML(hDefLocale, 'metadata default locale')
                     end

                     # metadata information - parent metadata {CI_Citation}
                     unless hMetaInfo[:parentMetadata].empty?
                        @xml.tag!('mdb:parentMetadata') do
                           citationClass.writeXML(hMetaInfo[:parentMetadata], 'metadata information')
                        end
                     end
                     if hMetaInfo[:parentMetadata].empty? && @hResponseObj[:writerShowTags]
                        @xml.tag!('mdb:parentMetadata')
                     end

                     # metadata information - metadata scope [] {MD_MetadataScope}
                     aScope = hResInfo[:resourceTypes]
                     aScope.each do |hScope|
                        unless hScope[:type].nil?
                           @xml.tag!('mdb:metadataScope') do
                              @xml.tag!('mdb:MD_MetadataScope') do
                                 @xml.tag!('mdb:resourceScope') do
                                    codelistClass.writeXML('mcc', 'iso_scope', hScope[:type])
                                 end
                              end
                           end
                        end
                        if hScope[:type].nil?
                           @NameSpace.issueWarning(390, 'mdb:metadataScope', 'resource information')
                        end
                     end
                     if aScope.empty? && @hResponseObj[:writerShowTags]
                        @xml.tag!('mdb:metadataScope')
                     end

                     # metadata information - contact [] {CI_ResponsibleParty} (required)
                     aContacts = hMetaInfo[:metadataContacts]
                     aContacts.each do |hContact|
                        unless hContact.empty?
                           @xml.tag!('mdb:contact') do
                              responsibilityClass.writeXML(hContact, 'metadata information')
                           end
                        end
                     end
                     if aContacts.empty?
                        @NameSpace.issueWarning(240, 'mdb:contact', 'metadata information')
                     end

                     # metadata information - date info [] {CI_Date} (required)
                     # 'creation' date is required - default: now()
                     aDates = hMetaInfo[:metadataDates]
                     haveCreation = false
                     aDates.each do |hDate|
                        if hDate[:dateType] == 'creation'
                           haveCreation = true
                        end
                     end
                     unless haveCreation
                        hCreateDate = {}
                        hCreateDate[:date] = DateTime.now
                        hCreateDate[:dateResolution] = 'YMD'
                        aDates.insert(0, hCreateDate)
                     end
                     aDates.each do |hDate|
                        @xml.tag!('mdb:dateInfo') do
                           dateClass.writeXML(hDate, 'metadata information')
                        end
                     end

                     # metadata information - metadata standard [] {CI_Citation} (auto fill)
                     hStandard = intMetadataClass.newCitation
                     hStandard[:title] = 'ISO 19115-3'
                     @xml.tag!('mdb:metadataStandard') do
                        citationClass.writeXML(hStandard, 'metadata standard')
                     end

                     # metadata information - metadata profile [] {CI_Citation} (auto fill)
                     hProfile = intMetadataClass.newCitation
                     hProfile[:title] = 'ISO 19115-1:2014-04-01'
                     @xml.tag!('mdb:metadataStandard') do
                        citationClass.writeXML(hProfile, 'metadata profile')
                     end

                     # metadata information - alternate metadata reference [] {CI_Citation}
                     aAlternates = hMetaInfo[:alternateMetadataReferences]
                     aAlternates.each do |hAlternate|
                        @xml.tag!('mdb:alternativeMetadataReference') do
                           citationClass.writeXML(hAlternate, 'metadata alternate')
                        end
                     end
                     if aAlternates.empty? && @hResponseObj[:writerShowTags]
                        @xml.tag!('mdb:alternativeMetadataReference')
                     end

                     # metadata information - other locale [] {PT_Locale}
                     aLocales = hMetaInfo[:otherMetadataLocales]
                     aLocales.each do |hLocale|
                        @xml.tag!('mdb:otherLocale') do
                           localeClass.writeXML(hLocale, 'other metadata locale')
                        end
                     end
                     if aLocales.empty? && @hResponseObj[:writerShowTags]
                        @xml.tag!('mdb:otherLocale')
                     end

                     # metadata information - metadata linkage [] {CI_OnlineResource}
                     aLinks = hMetaInfo[:metadataLinkages]
                     aLinks.each do |hLink|
                        @xml.tag!('mdb:metadataLinkage') do
                           onlineClass.writeXML(hLink, 'metadata online resource')
                        end
                     end
                     if aLinks.empty? && @hResponseObj[:writerShowTags]
                        @xml.tag!('mdb:metadataLinkage')
                     end

                     # metadata information - spatial representation []
                     # {MD_GridSpatialRepresentation | MD_VectorSpatialRepresentation}
                     # {MD_Georeferenceable | MD_Georectified }

                     # metadata information - reference system info [] {MD_ReferenceSystem}

                     # ###################### Begin Data Identification #####################

                     # metadata information - data identification info - required
                     unless hResInfo.empty?
                        @xml.tag!('mdb:identificationInfo') do
                           dataIdClass.writeXML(hMetadata)
                        end
                     end
                     if hResInfo.empty?
                        @NameSpace.issueWarning(241, 'mdb:identificationInfo')
                     end

                     # ###################### End Data Identification #######################

                     # metadata information - content information []
                     # FC_FeatureCatalogue not implemented
                     aCoverages = hResInfo[:coverageDescriptions]
                     aCoverages.each do |hCoverage|
                        unless hCoverage.empty?
                           @xml.tag!('mdb:contentInfo') do
                              haveImage = hCoverage[:imageDescription].empty?
                              if haveImage
                                 imageClass.writeXML(hCoverage)
                              else
                                 coverageClass.writeXML(hCoverage)
                              end
                           end
                        end
                     end
                     if aCoverages.empty? && @hResponseObj[:writerShowTags]
                        @xml.tag!('mdb:contentInfo')
                     end

                     # metadata information - distribution info [] {MD_Distribution}
                     aDistributions.each do |hDistribution|
                        unless hDistribution.empty?
                           @xml.tag!('mrd:distributionInfo') do
                              distributionClass.writeXML(hDistribution)
                           end
                        end
                     end
                     if aDistributions.empty? && @hResponseObj[:writerShowTags]
                        @xml.tag!('mrd:distributionInfo')
                     end

                     # metadata information - resource lineage [] {LI_Lineage}
                     aLineage.each do |hLineage|
                        @xml.tag!('mdb:resourceLineage') do
                           lineageClass.writeXML(hLineage)
                        end
                     end
                     if aLineage.empty? && @hResponseObj[:writerShowTags]
                        @xml.tag!('mdb:resourceLineage')
                     end

                     # metadata information - metadata constraints {}
                     aConstraint = hMetaInfo[:metadataConstraints]
                     aConstraint.each do |hCon|
                        @xml.tag!('mdb:metadataConstraints') do
                           constraintClass.writeXML(hCon, 'metadata information')
                        end
                     end
                     if aConstraint.empty? && @hResponseObj[:writerShowTags]
                        @xml.tag!('mdb:metadataConstraints')
                     end

                     # metadata information - metadata maintenance
                     hMaintenance = hMetaInfo[:metadataMaintenance]
                     unless hMaintenance.empty?
                        @xml.tag!('mdb:metadataMaintenance') do
                           maintenanceClass.writeXML(hMaintenance, 'metadata maintenance')
                        end
                     end
                     if hMaintenance.empty? && @hResponseObj[:writerShowTags]
                        @xml.tag!('mdb:metadataMaintenance')
                     end

                  end # mdb:MD_Metadata tag

                  return metadata

               end # writeXML
            end # MI_Metadata class

         end
      end
   end
end
