# ISO <<Class>> TimePeriod
# 19115-2 writer output in XML

# History:
#   Stan Smith 2016-11-30 refactored for mdTranslator/mdJson 2.0
#   Stan Smith 2015-07-14 refactored to eliminate namespace globals $WriterNS and $IsoNS
#   Stan Smith 2015-07-14 refactored to make iso19110 independent of iso19115_2 classes
#   Stan Smith 2015-06-22 replace global ($response) with passed in object (hResponseObj)
#   Stan Smith 2014-12-12 refactored to handle namespacing readers and writers
#   Stan Smith 2014-07-08 modify require statements to function in RubyGem structure
# 	Stan Smith 2013-11-04 original script.

require_relative 'class_gmlIdentifier'

module ADIWG
    module Mdtranslator
        module Writers
            module Iso19115_2

                class TimePeriod

                    def initialize(xml, hResponseObj)
                        @xml = xml
                        @hResponseObj = hResponseObj
                    end

                    def writeXML(hPeriod)

                        # classes used
                        gmlClass =  GMLIdentifier.new(@xml, @hResponseObj)

                        # TimePeriod must have a uniqueID
                        timeID = hPeriod[:timeId]
                        if timeID.nil?
                            @hResponseObj[:writerMissingIdCount] = @hResponseObj[:writerMissingIdCount].succ
                            timeID = 'timePeriod' + @hResponseObj[:writerMissingIdCount]
                        end

                        @xml.tag!('gml:TimePeriod', {'gml:id' => timeID}) do

                            # time period - description
                            s = hPeriod[:description]
                            unless s.nil?
                                @xml.tag!('gml:description', s)
                            end
                            if s.nil? && @hResponseObj[:writerShowTags]
                                @xml.tag!('gml:description')
                            end

                            # time period - identifier {gmlIdentifier}
                            hGMLid = hPeriod[:identifier]
                            unless hGMLid.empty?
                                gmlClass.writeXML(hGMLid)
                            end
                            if hGMLid.empty? && @hResponseObj[:writerShowTags]
                                @xml.tag!('gml:identifier')
                            end

                            # time period - names []
                            aNames = hPeriod[:periodNames]
                            aNames.each do |name|
                                @xml.tag!('gml:name', name)
                            end
                            if aNames.empty? && @hResponseObj[:writerShowTags]
                                @xml.tag!('gml:name')
                            end

                            # time period - begin position
                            # tag required, however value may be empty
                            unless hPeriod[:startDateTime].empty?
                                hDateTime = hPeriod[:startDateTime]
                                dateTime = hDateTime[:dateTime]
                                timeResolution = hDateTime[:dateResolution]
                                dateStr = AdiwgDateTimeFun.stringDateTimeFromDateTime(dateTime, timeResolution)
                                @xml.tag!('gml:beginPosition', dateStr)
                            end
                            if hPeriod[:startDateTime].empty?
                                @xml.tag!('gml:beginPosition')
                            end

                            # time period - begin position
                            # tag required, however value may be empty
                            unless hPeriod[:endDateTime].empty?
                                hDateTime = hPeriod[:endDateTime]
                                dateTime = hDateTime[:dateTime]
                                timeResolution = hDateTime[:dateResolution]
                                dateStr = AdiwgDateTimeFun.stringDateTimeFromDateTime(dateTime, timeResolution)
                                @xml.tag!('gml:endPosition', dateStr)
                            end
                            if hPeriod[:endDateTime].empty?
                                @xml.tag!('gml:endPosition')
                            end

                        end # TimePeriod tag
                    end # writeXML
                end # TimePeriod class

            end
        end
    end
end
