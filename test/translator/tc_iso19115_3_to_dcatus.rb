# frozen_string_literal: true

# MdTranslator - minitest of
# adiwg / mdtranslator / mdReaders / iso19115-3 reader & dcatus writer

require 'minitest/autorun'
require 'nokogiri'
require 'adiwg/mdtranslator'
require 'debug'
require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_iso19115_3'
require 'adiwg/mdtranslator/writers/dcat_us/sections/dcat_us_dcat_us'

# these tests are organized according to how data is processed in
# the dcat_us writer lib/adiwg/mdtranslator/writers/dcat_us/sections/dcat_us_dcat_us.rb

class TestIso191153DcatusTranslation < Minitest::Test
   @@hResponseObj = {
      readerExecutionPass: true,
      readerExecutionMessages: [],
      readerStructurePass: true,
      readerStructureMessages: []
   }
   # keeping these here for now. TODO: will add more files to test against
   @@file = File.join(File.dirname(__FILE__), 'testData', 'iso19115-3.xml')
   @@xml = Nokogiri::XML(File.read(@@file))

   @@xIn = @@xml.xpath('mdb:MD_Metadata')[0]
   @@hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
   @@iso191153NS = ADIWG::Mdtranslator::Readers::Iso191153::Iso191153

   @@intMetadata = @@iso191153NS.unpack(@@xIn, @@hResponse)

   def test_citation_title
      expected = 'Spatial data: A large-scale database of modeled ' \
      'contemporary and future water temperature data for 10,774 ' \
      'Michigan, Minnesota and Wisconsin Lakes'

      assert_equal(expected, @@intMetadata[:metadata][:resourceInfo][:citation][:title])
   end

   def test_description
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Description
      res = dcatusNS.build(@@intMetadata)

      assert !res.nil?
   end

   def test_keywords
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Keyword
      res = dcatusNS.build(@@intMetadata)

      expected = ['water',
                  'temperate lakes',
                  'reservoirs',
                  'modeling',
                  'climate change',
                  'thermal profiles',
                  'environment',
                  'inlandWaters',
                  '007',
                  '012',
                  'Illinois',
                  'Indiana',
                  'Iowa',
                  'Michigan',
                  'Minnesota',
                  'South Dakota',
                  'Wisconsin',
                  'United States',
                  'US',
                  'Illinois',
                  'IL',
                  'Indiana',
                  'IN',
                  'Iowa',
                  'IA',
                  'Michigan',
                  'MI',
                  'Minnesota',
                  'MN',
                  'South Dakota',
                  'SD',
                  'Wisconsin',
                  'WI',
                  'Northeast CSC',
                  'Rivers, Streams and Lakes',
                  'Fish',
                  'Climate and Ecosystem Modeling']

      assert_equal(expected, res)
   end

   def test_access_level_translate
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::AccessLevel
      res = dcatusNS.build(@@intMetadata)

      assert_equal('non-public', res)
   end
end
