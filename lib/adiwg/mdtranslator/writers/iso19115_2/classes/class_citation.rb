# ISO <<Class>> CI_Citation
# 19115-2 writer output in XML

# History:
#   Stan Smith 2016-11-29 refactored for mdTranslator/mdJson 2.0
#   Stan Smith 2015-08-28 added alternate title
#   Stan Smith 2015-07-14 refactored to eliminate namespace globals $WriterNS and $IsoNS
#   Stan Smith 2015-07-14 refactored to make iso19110 independent of iso19115_2 classes
#   Stan Smith 2015-06-22 replace global ($response) with passed in object (hResponseObj)
#   Stan Smith 2015-06-11 change all codelists to use 'class_codelist' method
#   Stan Smith 2014-12-15 refactored to handle namespacing readers and writers
#   Stan Smith 2014-08-18 process isbn and ISSN from identifier section per 0.6.0
#   Stan Smith 2014-08-18 modify identifier section for schema 0.6.0
#   Stan Smith 2014-07-08 modify require statements to function in RubyGem structure
#   Stan Smith 2014-05-28 modified for json schema 0.5.0
#   Stan Smith 2014-05-16 added MD_Identifier
#   Stan Smith 2014-05-16 modified for JSON schema 0.4.0
# 	Stan Smith 2013-12-30 added ISBN, ISSN
# 	Stan Smith 2013-08-26 original script

require_relative 'class_codelist'
require_relative 'class_responsibleParty'
require_relative 'class_date'
require_relative 'class_mdIdentifier'
require_relative 'class_series'

module ADIWG
    module Mdtranslator
        module Writers
            module Iso19115_2

                class CI_Citation

                    def initialize(xml, hResponseObj)
                        @xml = xml
                        @hResponseObj = hResponseObj
                    end

                    def writeXML(hCitation)

                        # classes used
                        codelistClass =  MD_Codelist.new(@xml, @hResponseObj)
                        rPartyClass =  CI_ResponsibleParty.new(@xml, @hResponseObj)
                        dateClass =  CI_Date.new(@xml, @hResponseObj)
                        idClass =  MD_Identifier.new(@xml, @hResponseObj)
                        seriesClass =  CI_Series.new(@xml, @hResponseObj)

                        @xml.tag!('gmd:CI_Citation') do

                            # citation - title (required)
                            s = hCitation[:title]
                            if s.nil?
                                @xml.tag!('gmd:title', {'gco:nilReason' => 'missing'})
                            else
                                @xml.tag!('gmd:title') do
                                    @xml.tag!('gco:CharacterString', s)
                                end
                            end

                            # citation - alternate title []
                            aTitles = hCitation[:alternateTitles]
                            aTitles.each do |title|
                                @xml.tag!('gmd:alternateTitle') do
                                    @xml.tag!('gco:CharacterString', title)
                                end
                            end
                            if aTitles.empty? && @hResponseObj[:writerShowTags]
                                @xml.tag!('gmd:alternateTitle')
                            end

                            # citation - date [] (required)
                            aDate = hCitation[:dates]
                            aDate.each do |hDate|
                                @xml.tag!('gmd:date') do
                                    dateClass.writeXML(hDate)
                                end
                            end
                            if aDate.empty?
                                @xml.tag!('gmd:date', {'gco:nilReason' => 'missing'})
                            end

                            # citation - edition
                            s = hCitation[:edition]
                            unless s.nil?
                                @xml.tag!('gmd:edition') do
                                    @xml.tag!('gco:CharacterString', s)
                                end
                            end
                            if s.nil? && @hResponseObj[:writerShowTags]
                                @xml.tag!('gmd:edition')
                            end

                            # citation - resource identifier []
                            # do not process ISBN and ISSN as MD_identifier(s)
                            # ... these are written separately in ISO 19115-x
                            isbn = ''
                            issn = ''
                            aIds = hCitation[:identifiers]
                            aIds.each do |hIdentifier|
                                if hIdentifier[:namespace].downcase == 'isbn'
                                    isbn = hIdentifier[:identifier]
                                elsif hIdentifier[:namespace].downcase == 'issn'
                                    issn = hIdentifier[:identifier]
                                else
                                    @xml.tag!('gmd:identifier') do
                                        idClass.writeXML(hIdentifier)
                                    end
                                end
                            end
                            if aIds.empty? && @hResponseObj[:writerShowTags]
                                @xml.tag!('gmd:identifier')
                            end

                            # citation - cited responsible party [{CI_ResponsibleParty}]
                            # contacts are grouped by role in the internal object
                            # output a separate <gmd:contact> for each role:contact pairing
                            aRParties = hCitation[:responsibleParties]
                            aRParties.each do |hRParty|
                                role = hRParty[:roleName]
                                aParties = hRParty[:party]
                                aParties.each do |hParty|
                                    @xml.tag!('gmd:citedResponsibleParty') do
                                        rPartyClass.writeXML(role, hParty)
                                    end
                                end
                            end
                            if aRParties.empty?
                                @xml.tag!('gmd:citedResponsibleParty', {'gco:nilReason' => 'missing'})
                            end

                            # citation - presentation forms [{CI_PresentationFormCode}]
                            aPresForms = hCitation[:presentationForms]
                            aPresForms.each do |presForm|
                                @xml.tag!('gmd:presentationForm') do
                                    codelistClass.writeXML('iso_presentationForm', presForm)
                                end
                            end
                            if aPresForms.empty? && @hResponseObj[:writerShowTags]
                                @xml.tag!('gmd:presentationForm')
                            end

                            # citation - series {CI_Series}
                            hSeries = hCitation[:series]
                            unless hSeries.empty?
                                @xml.tag!('gmd:series') do
                                    seriesClass.writeXML(hSeries)
                                end
                            end
                            if hSeries.empty? && @hResponseObj[:writerShowTags]
                                @xml.tag!('gmd:series')
                            end

                            # citation - other citation details
                            aOther = hCitation[:otherDetails]
                            unless aOther.empty?
                                other = aOther[0]
                                @xml.tag!('gmd:otherCitationDetails') do
                                    @xml.tag!('gco:CharacterString', other)
                                end
                            end
                            if aOther.empty? && @hResponseObj[:writerShowTags]
                                @xml.tag!('gmd:otherCitationDetails')
                            end

                            # citation - ISBN
                            unless isbn == ''
                                @xml.tag!('gmd:ISBN') do
                                    @xml.tag!('gco:CharacterString', s)
                                end
                            end
                            if isbn == '' && @hResponseObj[:writerShowTags]
                                @xml.tag!('gmd:ISBN')
                            end

                            # citation - ISSN
                            unless issn == ''
                                @xml.tag!('gmd:ISSN') do
                                    @xml.tag!('gco:CharacterString', s)
                                end
                            end
                            if issn == '' && @hResponseObj[:writerShowTags]
                                @xml.tag!('gmd:ISSN')
                            end

                        end # CI_Citation tag
                    end # writeXML
                end # CI_Citation class

            end
        end
    end
end
