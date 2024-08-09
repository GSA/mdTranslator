require 'jbuilder'
require_relative 'version'
require_relative 'sections/dcat_us_dcat_us'

module ADIWG
   module Mdtranslator
      module Writers
         module Dcat_us

            def self.startWriter(intObj, responseObj)
               # set the contact array for use by the writer
               # @contacts = intObj[:contacts]

               # set output flag for null properties
               Jbuilder.ignore_nil(!responseObj[:writerShowTags])

               # set the format of the output file based on the writer specified
               responseObj[:writerOutputFormat] = 'json'
               responseObj[:writerVersion] = ADIWG::Mdtranslator::Writers::Dcat_us::VERSION

               # write the dcat_us metadata record
               metadata = Dcat_us.build(intObj, responseObj)

               # set writer pass to true if no messages
               # false or warning state will be set by writer code
               responseObj[:writerPass] = true if responseObj[:writerMessages].empty?

               # encode the metadata target as JSON
               metadata.target!
            end

         end
      end
   end
end
