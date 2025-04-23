require 'jbuilder'

module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module Theme
          def self.build(intObj)
            resourceInfo = intObj[:metadata][:resourceInfo]
            keywords_str = []

            resourceInfo[:keywords].each do |keyword_group|
              next unless keyword_group[:thesaurus][:title] == 'ISO Topic Categories'

              keyword_group[:keywords].each do |keyword_obj|
                keywords_str << keyword_obj[:keyword]
              end
            end

            return nil if keywords_str.empty?

            keywords_str.reject(&:empty?)
          end
        end
      end
    end
  end
end
