require 'jbuilder'
require 'rubygems'
require_relative 'version'
require_relative 'sections/dcatusJson_dcatusJson'

module ADIWG
   module Mdtranslator
      module Writers
         module DcatusJson

            def self.startWriter(intObj, responseObj)

               @intObj = intObj

               # set output flag for null properties
               Jbuilder.ignore_nil(!responseObj[:writerShowTags])

               # set the format of the output file based on the writer specified
               responseObj[:writerOutputFormat] = 'json'

               # write the dcatusJson metadata record
               metadata = DcatusJson.build(intObj, responseObj)

               # encode the metadata target as JSON
               metadata.target!

            end

         end
      end
   end
end
