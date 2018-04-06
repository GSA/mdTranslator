# unpack taxonomic classification
# Reader - ADIwg JSON to internal data structure

# History:
#  Stan Smith 2018-04-06 renamed taxonomicRank to taxonomicLevel
#  Stan Smith 2018-04-06 renamed latinName to taxonomicName
#  Stan Smith 2018-02-19 refactored error and warning messaging
#  Stan Smith 2017-01-31 added taxonomicSystemId
#  Stan Smith 2016-10-22 original script

require_relative 'module_taxonomicClassification'

module ADIWG
   module Mdtranslator
      module Readers
         module MdJson

            module TaxonomicClassification

               def self.unpack(hTaxClass, responseObj)

                  # return nil object if input is empty
                  if hTaxClass.empty?
                     responseObj[:readerExecutionMessages] <<
                        'WARNING: mdJson reader: taxonomic classification object is empty'
                     return nil
                  end

                  # instance classes needed in script
                  intMetadataClass = InternalMetadata.new
                  intTaxClass = intMetadataClass.newTaxonClass

                  # taxonomic classification - system ID
                  if hTaxClass.has_key?('taxonomicSystemId')
                     unless hTaxClass['taxonomicSystemId'] == ''
                        intTaxClass[:taxonId] = hTaxClass['taxonomicSystemId']
                     end
                  end

                  # taxonomic classification - taxon level (required)
                  # renamed from 'taxonomicRank'
                  if hTaxClass.has_key?('taxonomicLevel')
                     intTaxClass[:taxonRank] = hTaxClass['taxonomicLevel']
                  end
                  # support deprecation until schema version 3.0
                  if hTaxClass.has_key?('taxonomicRank')
                     intTaxClass[:taxonRank] = hTaxClass['taxonomicRank']
                     responseObj[:readerExecutionMessages] <<
                        'NOTICE: mdJson reader: taxonomic classification taxonomicRank is deprecated, use taxonomicLevel'
                  end
                  if intTaxClass[:taxonRank].nil? || intTaxClass[:taxonRank] == ''
                     responseObj[:readerExecutionMessages] <<
                        'ERROR: mdJson reader: taxonomic classification level is missing'
                     responseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # taxonomic classification - taxonomic name (required)
                  # renamed from 'latinName'
                  if hTaxClass.has_key?('taxonomicName')
                     intTaxClass[:taxonValue] = hTaxClass['taxonomicName']
                  end
                  # support deprecation until schema version 3.0
                  if hTaxClass.has_key?('latinName')
                     intTaxClass[:taxonValue] = hTaxClass['latinName']
                     responseObj[:readerExecutionMessages] <<
                        'NOTICE: mdJson reader: taxonomic classification latinName is deprecated, use taxonomicName'
                  end
                  if intTaxClass[:taxonValue].nil? || intTaxClass[:taxonValue] == ''
                     responseObj[:readerExecutionMessages] <<
                        'ERROR: mdJson reader: taxonomic classification name is missing'
                     responseObj[:readerExecutionPass] = false
                     return nil
                  end

                  # taxonomic classification - common name []
                  if hTaxClass.has_key?('commonName')
                     hTaxClass['commonName'].each do |item|
                        unless item == ''
                           intTaxClass[:commonNames] << item
                        end
                     end
                  end

                  # taxonomic classification - taxonomic classification [taxonomicClassification]
                  if hTaxClass.has_key?('subClassification')
                     aItems = hTaxClass['subClassification']
                     aItems.each do |item|
                        hReturn = TaxonomicClassification.unpack(item, responseObj)
                        unless hReturn.nil?
                           intTaxClass[:subClasses] << hReturn
                        end
                     end
                  end

                  return intTaxClass

               end

            end

         end
      end
   end
end
