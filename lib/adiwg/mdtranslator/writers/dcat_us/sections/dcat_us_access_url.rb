require 'jbuilder'
require 'adiwg/mdtranslator/internal/module_utils'

PAGE_EXTENSIONS = Set.new(%w[
                            .html .htm .xhtml .php .asp .aspx .jsp .cfm
                          ]).freeze

module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module AccessURL
          def self.access_url?(option)
            path = AdiwgUtils.normalized_path(option[:olResURI])
            ext = File.extname(path).downcase

            # if the path ends with '/', or it doesn't have a file extension, or it has a common page extension
            return true if path.end_with?('/') || ext.empty? || PAGE_EXTENSIONS.include?(ext)

            false
          end
        end
      end
    end
  end
end
