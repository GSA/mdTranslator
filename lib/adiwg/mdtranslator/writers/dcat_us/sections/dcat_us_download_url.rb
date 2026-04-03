require 'jbuilder'
require 'adiwg/mdtranslator/internal/module_utils'

module ADIWG
  module Mdtranslator
    module Writers
      module Dcat_us
        module DownloadURL
          def self.download_url?(option)
            # avoid comparing the file extension to a limited set of values (e.g. .json, .xml, .rdf, etc...)
            path = AdiwgUtils.normalized_path(option[:olResURI])
            !File.extname(path).empty?
          end
        end
      end
    end
  end
end
