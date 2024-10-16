# HTML writer
# keywords

# History:
#  Stan Smith 2017-03-29 refactored for mdTranslator 2.0
#  Stan Smith 2015-07-16 refactored to remove global namespace $HtmlNS
# 	Stan Smith 2015-03-23 original script

require_relative 'html_citation'

module ADIWG
   module Mdtranslator
      module Writers
         module Simple_html

            class Html_Keyword

               def initialize(html)
                  @html = html
               end

               def writeHtml(hKeyword)

                  # classes used
                  citationClass = Html_Citation.new(@html)

                  # keywords - type
                  @html.div do
                     type = hKeyword[:keywordType]
                     if type.nil?
                        type = 'Unclassified'
                     end
                     @html.h5(type, {'class' => 'h5'})
                     @html.div(:class => 'block') do
                        
                        # thesaurus
                        unless hKeyword[:thesaurus].empty?
                           @html.div do
                              @html.h5('Thesaurus', {'class' => 'h5'})
                              @html.div(:class => 'block') do
                                 citationClass.writeHtml(hKeyword[:thesaurus])
                              end
                           end
                        end

                        # keywords
                        hKeyword[:keywords].each do |hKeyword|
                           unless hKeyword[:keyword].nil?
                              keyword = hKeyword[:keyword]
                              unless hKeyword[:keywordId].nil?
                                 keyword += ' (ID: ' + hKeyword[:keywordId].to_s + ')'
                              end
                              @html.div('Keyword:' + keyword)
                           end
                        end

                     end
                  end

               end # writeHtml
            end # Html_Keyword

         end
      end
   end
end
