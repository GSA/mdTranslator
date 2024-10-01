require 'jbuilder'
require_relative 'dcat_us_keyword'
require_relative 'dcat_us_publisher'
require_relative 'dcat_us_contact_point'
require_relative 'dcat_us_identifier'
require_relative 'dcat_us_distribution'
require_relative 'dcat_us_spatial'
require_relative 'dcat_us_temporal'
require_relative 'dcat_us_modified'
require_relative 'dcat_us_access_level'
require_relative 'dcat_us_rights'
require_relative 'dcat_us_license'
require_relative 'dcat_us_issued'
require_relative 'dcat_us_described_by'
require_relative 'dcat_us_is_part_of'
require_relative 'dcat_us_theme'
require_relative 'dcat_us_references'
require_relative 'dcat_us_landing_page'
require_relative 'dcat_us_system_of_records'
require_relative 'dcat_us_description'
require_relative 'dcat_us_described_by_type'
require_relative 'dcat_us_accrualPeriodicity'
require_relative 'dcat_us_language'
require_relative 'dcat_us_primaryITInvestmentUII'
require_relative 'dcat_us_program_code'
require_relative 'dcat_us_bureau_code'

module ADIWG
   module Mdtranslator
      module Writers
         module Dcat_us
            def self.build(intObj, responseObj)
               @contacts = intObj[:contacts]

               metadataInfo = intObj[:metadata][:metadataInfo]
               resourceInfo = intObj[:metadata][:resourceInfo]
               citation = resourceInfo[:citation]

               title = citation[:title]
               description = Description.build(intObj)
               keyword = Keyword.build(intObj)
               modified = Modified.build(intObj)
               publisher = Publisher.build(intObj)
               contactPoint = ContactPoint.build(intObj)
               accessLevel = AccessLevel.build(intObj)
               identifier = Identifier.build(intObj)
               distribution = Distribution.build(intObj)
               rights = Rights.build(intObj, accessLevel)
               spatial = Spatial.build(intObj)
               temporal = Temporal.build(intObj)
               license = License.build(intObj)
               issued = Issued.build(intObj)
               language = Language.build(intObj)
               describedBy = DescribedBy.build(intObj)
               isPartOf = IsPartOf.build(intObj)
               theme = Theme.build(intObj)
               references = References.build(intObj)
               landingPage = LandingPage.build(intObj)
               systemOfRecords = SystemOfRecords.build(intObj)
               describedByType = DescribedByType.build(intObj)
               accrualPeriodicity = AccrualPeriodicity.build(intObj)
               primaryITInvestmentUII = PrimaryITInvestmentUII.build(intObj)
               programCode = ProgramCode.build(intObj)
               bureauCode = BureauCode.build(intObj)

               @Namespace = ADIWG::Mdtranslator::Writers::Dcat_us

               Jbuilder.new do |json|
                  json.set!('@type', 'dcat:Dataset')
                  json.set!('title', title)
                  json.set!('description', description)
                  json.set!('keyword', keyword)
                  json.set!('modified', modified)
                  json.set!('publisher', publisher)
                  json.set!('contactPoint', contactPoint)
                  json.set!('identifier', identifier)
                  json.set!('accessLevel', accessLevel)
                  json.set!('bureauCode', bureauCode)
                  json.set!('programCode', programCode)
                  json.set!('distribution', distribution)

                  json.set!('license', license)
                  json.set!('rights', rights)
                  json.set!('spatial', spatial)
                  json.set!('temporal', temporal)

                  json.set!('issued', issued)
                  json.set!('accrualPeriodicity', accrualPeriodicity)
                  json.set!('language', language)
                  # json.set!('dataQuality', metadataInfo[:metadataMaintenance][:maintenanceNote])
                  json.set!('theme', theme)
                  json.set!('references', references)
                  json.set!('landingPage', landingPage)
                  json.set!('isPartOf', isPartOf)
                  json.set!('systemOfRecords', systemOfRecords)
                  json.set!('primaryITInvestmentUII', primaryITInvestmentUII)
                  json.set!('describedBy', describedBy)
                  json.set!('describedByType', describedByType)
                  # json.set!('conformsTo', metadataInfo[:metadataStandards][0][:standardName])
               end
            end

            # find contact in contact array and return the contact hash
            def self.get_contact_by_index(contactIndex)
               return @contacts[contactIndex] if @contacts[contactIndex]

               {}
            end

            # find contact in contact array and return the contact hash
            def self.get_contact_by_id(contactId)
               @contacts.each do |hContact|
                  return hContact if hContact[:contactId] == contactId
               end
               {}
            end

            # find contact in contact array and return the contact index
            def self.get_contact_index_by_id(contactId)
               @contacts.each_with_index do |hContact, index|
                  return index if hContact[:contactId] == contactId
               end
               {}
            end

            # ignore jBuilder object mapping when array is empty
            def self.json_map(collection = [], _class)
               return nil if collection.nil? || collection.empty?

               collection.map { |item| _class.build(item).attributes! }
            end

            # find all nested objects in 'obj' that contain the element 'ele'
            def self.nested_objs_by_element(obj, ele, excludeList = [])
               aCollected = []
               obj.each do |key, value|
                  skipThisOne = false
                  excludeList.each do |exclude|
                     skipThisOne = true if key == exclude.to_sym
                  end
                  next if skipThisOne

                  if key == ele.to_sym
                     aCollected << obj
                  elsif obj.is_a?(Array)
                     if key.respond_to?(:each)
                        aReturn = nested_objs_by_element(key, ele, excludeList)
                        aCollected = aCollected.concat(aReturn) unless aReturn.empty?
                     end
                  elsif obj[key].respond_to?(:each)
                     aReturn = nested_objs_by_element(value, ele, excludeList)
                     aCollected = aCollected.concat(aReturn) unless aReturn.empty?
                  end
               end
               aCollected
            end
         end
      end
   end
end
