# adiwg mdTranslator

# version 2 history
# 2.9.0 2018-02-01 added fgdc writer distribution information section
# 2.9.0 2018-01-26 deprecate dictionaryFormat in favor of dictionaryFunctionalLanguage
# 2.9.0 2018-01-25 added fgdc writer entity and attribute section
# 2.8.0 2018-01-17 added fgdc writer spatial reference section
# 2.7.1 2018-01-05 fix issue #171, fully implement deprecation of topicCategories[]
# 2.7.0 2017-12-28 reinstate schema validation checks for schema 2.4.1
# 2.7.0 2017-12-26 add fgdc writer identification info section
# 2.7.0 2017-12-26 add fgdc writer data quality info section
# 2.7.0 2017-12-26 add fgdc writer spatial domain info section
# 2.6.1 2017-11-30 add agreement number to sbJson budget facet
# 2.6.1 2017-11-30 add metadataOnlineResources and citation onlineResources to sbJson
# 2.6.1 2017-11-30 remove duplicate citation identifiers from sbJson
# 2.6.1 2017-11-30 handle keywords greater than 80 characters in sbJson
# 2.6.1 2017-11-30 do not import short abstract in sbJson
# 2.6.0 2017-11-09 add metadataIdentifier to sbJson identifier
# 2.6.0 2017-11-09 added data dictionary description
# 2.6.0 2017-11-09 added readers and writers for geologic age
# 2.5.0 2017-11-03 bug fix, add test to verify mdJson reader version is compatible with schema version
# 2.5.0 2017-11-03 added support for additional fgdc and bio data dictionary element
# 2.4.1 2017-11-02 refactored mdJson writer for added entity, attribute, and domain elements
# 2.4.1 2017-10-31 fix issue with computation of federal fiscal year in sbJson budget writer
# 2.4.1 2017-10-30 refactored fgdc reader for added entity, attribute, and domain elements
# 2.4.0 2017-10-25 added html writers for reference system parameter set
# 2.4.0 2017-10-24 added mdJson writers for reference system parameter set
# 2.4.0 2017-10-19 added mdJson reader for geographicResolution
# 2.4.0 2017-10-19 added mdJson reader for bearingDistanceResolution
# 2.4.0 2017-10-19 added mdJson reader for coordinateResolution
# 2.4.0 2017-10-19 added fgdc readers for spatial reference
# 2.3.6 2017-10-24 fix bug that returns first identifier if no SB namespace is found
# 2.3.5 2017-10-17 fixed problem with adding technical prerequisite to nil distribution description
# 2.3.5 2017-10-13 trap missing topology level in html writer vectorRepresentation
# 2.3.4 2017-10-12 drop harvest set tag if repository citation is missing
# 2.3.3 2017-10-03 modify sbJson reader execution fail tests
# 2.3.2 2017-09-14 add associationType to sbJson relatedItems
# 2.3.2 2017-09-14 add contacts to resource citation
# 2.3.1 2017-09-13 fixed fgdc reader: removed conversion of hash to json
# 2.3.0 2017-09-11 add fgdc 1998 CSDGM reader
# 2.2.0 2017-08-31 refactor for schema changes to Lineage and Funding
# 2.1.2 2017-08-24 remove schema version from sbJson
# 2.1.0 2017-08-10 revisions to sbJson reader
# 2.0.0 2017-06-28 added sbJson reader
# 2.0.0rc13 2017-06-16 apply changes to sbJson writer after fourth review session
# 2.0.0rc12 2017-06-14 apply changes to sbJson writer after third review session
# 2.0.0rc11 2017-06-08 apply changes to sbJson writer after second review session
# 2.0.0rc10 2017-06-05 apply changes to sbJson writer after review
# 2.0.0rc9 2017-05-26 allow choice of which dictionary to translate
#                 ... fix bug when no dictionary is provided in mdJson
#                 ... add sbJson writer
# 2.0.0rc6 2017-05-24 move geometries to real world if in -1 or +1 world
#                 --- removed special characters from ids for gml:id= in iso writers
# 2.0.0rc5 2017-05-20 Fixed bug with no writer provided
# 2.0.0rc4 2017-05-19 bump mdJson schema version to 2.1.2
# 2.0.0rc3 2017-05-16 removed topicCategory from schema and manage as keyword
# 2.0.0rc2 2017-04-21 removed inline CSS option from CLI
# 2.0.0rc1 2017-04-09 release candidate 1
# 2.0.0    2016-10-01 start of version 2

module ADIWG
   module Mdtranslator
      # current mdtranslator version
      VERSION = "2.9.0"
   end
end

# version 1 history
# 1.0.0rc1 2015-02-27 schema 1.0 support
# 1.1.0 2015-04-13 added html writer
# 1.2.0 2015-06-12 added mdCodes for source of codelists
#              --- added comments to XML headers for citation of ADIwg
#              --- added reader and writer names to CLI help
#              --- added check in responsibleParty for valid contactId
#              --- added characterSets to resource and metadata, updated iso19115_2 and html writers
# 1.3.0 2015-06-22 removed global variables for the response object
#              --- removed global for show all tags and placed in response object
#              --- removed global for counter for missing ISO IDs and placed in response object
#              --- removed global pointers to contacts and domain arrays and point to @intObj
# 1.3.0 2015-07-14 removed global namespaces for readers and writers
# 1.3.0 2015-07-16 added version number management for readers and writers
#              --- moved module_coordinates to internal
# 1.3.0 2015-07-17 suppress minor section anchor links when no section data available is in html writer
#              --- added meta tags to the html writer
#              --- added --css and --cssLink method_options to CLI
# 1.3.0 2015-07-20 moved mdTranslator logo to css so it can be replaced using user provided css
# 1.3.0 2015-07-30 added locale to metadata info and resource info
# 1.3.0 2015-07-31 added grid information to resource info
# 1.3.0 2015-08-19 added coverageInfo, imageInfo, sensorInfo, coverageItem, classifiedData, and classedDataItem


# # version 0 history
# 0.8.0 2014-09-26 first version to release
# 0.8.1 2014-10-06 used uri from first onlineResource of the resource citation
#              ... as source for datasetURI in iso19115-2 writer
#              ... removed resourceURI from resourceInfo section of adiwgJson
# 0.8.2 2014-10-09 added the 'version' command to the CLI for returning the
#              ... mdTranslator version number
# 0.8.3 2014-10-10 added readme files in kramdown format for each reader and writer
# 0.8.4 2014-10-10 modified writers to pass minimum metadata input test
#              ... test were added to handle a missing metadata > metadataInfo
#              ... block in the input.
# 0.8.5 2014-10-11 added methods to pass content of readme files
# 0.8.6 2014-10-15 added cli option to return entire content mdTranslator response
# 0.8.7 2014-10-29 added support for resource time period
# 0.9.0 2014-11-06 added resourceType to associatedResource and additionalInformation
#              ... moved resourceType from metadataInfo to resourceInfo in json
# 0.9.1 2014-12-01 changed adiwgJson to mdJson
# 0.9.2 2014-12-01 added data dictionary support
# 0.10.0 2014-12-01 added ISO 19110 writer
# 0.10.1 2014-12-04 fixed problem with messages not returned in an array
# 0.10.2 2014-12-05
# 0.11.0 2014-12-15 refactored code managing the readers and writers
#               ... added namespaces to readers and writers
# 0.11.1 2014-12-16 fixed problem of rails not access reader and writer readme files
#               ... changed mdReader and mdWriter to use requested reader and writer
#               ... names to resolved require and call statements
# 0.11.2 2014-12-29 fixed problem with handling xml builder object rather than output
#               ... output string created by builder
# 0.11.3 2015-01-14 change return type from false to $response when writer name is invalid
# 0.12.0 2015-01-16 changed translate entry point method to use keyword parameters
#               ... must now be ruby version 2.0.0 or higher
# 0.12.1 2015-01-21 fixed problem with crash on writer = ''
# 0.13.0 2015-01-28 made data dictionary an array
#               ... added alias to entity and attribute
#               ... added local names to iso 19110 writer
