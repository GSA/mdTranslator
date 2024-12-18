# HTML writer
# attribute group

# History:
#  Stan Smith 2017-04-02 refactored for mdTranslator 2.0
# 	Stan Smith 2015-08-21 original script

require_relative 'html_attribute'

module ADIWG
   module Mdtranslator
      module Writers
         module Simple_html

            class Html_AttributeGroup

               def initialize(html)
                  @html = html
               end

               def writeHtml(hGroup)

                  # classes used
                  attributeClass = Html_Attribute.new(@html)

                  # attribute group - content type [] {CoverageContentTypeCode}
                  hGroup[:attributeContentTypes].each do |type|
                     @html.em('Content Type: ')
                     @html.text!(type)
                     @html.br
                  end

                  # attribute group - attribute [] {attribute}
                  counter = 0
                  hGroup[:attributes].each do |hAttribute|
                     @html.div do
                        counter += 1
                        @html.h5('Attribute '+counter.to_s, {'class' => 'h5'})
                        @html.div(:class => 'block') do
                           attributeClass.writeHtml(hAttribute)
                        end
                     end
                  end

               end # writeHtml
            end # Html_AttributeGroup

         end
      end
   end
end
