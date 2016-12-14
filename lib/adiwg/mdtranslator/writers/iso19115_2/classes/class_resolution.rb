# ISO <<Class>> MD_Resolution
# 19115-2 writer output in XML

# History:
#   Stan Smith 2016-12-12 refactored for mdTranslator/mdJson 2.0
#   Stan Smith 2015-07-14 refactored to eliminate namespace globals $WriterNS and $IsoNS
#   Stan Smith 2015-07-14 refactored to make iso19110 independent of iso19115_2 classes
#   Stan Smith 2015-06-22 replace global ($response) with passed in object (hResponseObj)
#   Stan Smith 2014-12-12 refactored to handle namespacing readers and writers
# 	Stan Smith 2013-11-19 original script

require_relative 'class_measure'
require_relative 'class_fraction'

module ADIWG
    module Mdtranslator
        module Writers
            module Iso19115_2

                class MD_Resolution

                    def initialize(xml, hResponseObj)
                        @xml = xml
                        @hResponseObj = hResponseObj
                    end

                    def writeXML(hResolution)

                        # classes used
                        measureClass = Measure.new(@xml, @hResponseObj)
                        fractionClass = MD_RepresentativeFraction.new(@xml, @hResponseObj)

                        @xml.tag!('gmd:MD_Resolution') do

                            type = hResolution[:type]

                            # spatial resolution - equivalent scale
                            if type == 'scaleFactor'
                                unless hResolution[:scaleFactor].nil?
                                    @xml.tag!('gmd:equivalentScale') do
                                        fractionClass.writeXML(hResolution[:scaleFactor])
                                    end
                                end
                            end

                            # spatial resolution - distance
                            if type == 'measure'
                                hMeasure = hResolution[:measure]
                                unless hMeasure.empty?
                                    measureClass.writeXML(hMeasure)
                                end
                            end

                        end # gmd:MD_Resolution tag
                    end # writeXML
                end # Measure class

            end
        end
    end
end
