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

   def test_modified
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Modified
      res = dcatusNS.build(@@intMetadata)

      assert_equal(DateTime.iso8601('2017-04-06T20:04:58+00:00'), res)
   end

   # TODO: anything with parties/contacts needs to be revisited
   # TODO: see comment above
   # def test_publisher
   #    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Publisher
   # end

   # TODO: see comment above
   # contactPoint

   def test_access_level_translate
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::AccessLevel
      res = dcatusNS.build(@@intMetadata)

      assert_equal('non-public', res)
   end

   # TODO: the code looks a tad weird. gonna meet with johnathan.
   # identifier

   def test_distribution_translate
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Distribution
      res = dcatusNS.build(@@intMetadata)

      refute_empty res
      assert res.instance_of? Array
      assert_equal(1, res.size)

      dist = res[0]
      assert_equal('dcat:Distribution', dist['@type'])
      assert_equal('distribution description', dist['description'])
      assert_equal('https://distributiontransfer.com/onlineresource.png', dist['downloadURL'])
      assert_equal('format specification', dist['mediaType'])
      assert_equal('name test 123', dist['title'])
   end

   def test_rights_translate
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Rights
      accessLevelNS = ADIWG::Mdtranslator::Writers::Dcat_us::AccessLevel
      accessLevel = accessLevelNS.build(@@intMetadata)
      res = dcatusNS.build(@@intMetadata, accessLevel)

      expected = "this is a releasability statement. it's important topSecret superSecret"
      assert_equal(expected, res)
   end

   def test_spatial_translate
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Spatial
      res = dcatusNS.build(@@intMetadata)

      expected = '-83.0573307815185,41.7553570685206,-96.8589114267623,48.7289513243629'
      assert_equal(expected, res)
   end

   def test_temporal_translate
      # TODO: temporal only grabs the first extent in the array. odd.
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Temporal
      res = dcatusNS.build(@@intMetadata)

      assert_equal('1980-01-01T00:00:00+00:00/1995-12-31T00:00:00+00:00', res)
   end

   def test_license_translate
      # TODO: license only grabs the first constraint in the array. odd.
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::License
      res = dcatusNS.build(@@intMetadata)

      assert_equal('MD ID common constraint licence title', res)
   end

   def test_issued_translate
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Issued
      res = dcatusNS.build(@@intMetadata)

      assert_equal('2016-09-14T15:56:49+00:00', res.to_s)
   end

   def test_language_translate
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Language
      res = dcatusNS.build(@@intMetadata)

      assert_equal(%w[eng test_lang_code test_lang_code2], res)
   end

   def test_described_by_translate
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::DescribedBy
      res = dcatusNS.build(@@intMetadata)

      assert_equal('http://test.something.org/10/F7DV1H10', res)
   end

   def test_is_part_of_translate
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::IsPartOf
      res = dcatusNS.build(@@intMetadata)

      assert_equal('http://resource.associated.org/10/F7DV1H10', res)
   end

   def test_theme_translate
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Theme
      res = dcatusNS.build(@@intMetadata)

      expected = 'United States US Illinois IL Indiana IN Iowa IA Michigan '\
      'MI Minnesota MN South Dakota SD Wisconsin WI'

      assert_equal(expected, res)
   end

   def test_references_translate
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::References
      res = dcatusNS.build(@@intMetadata)

      expected = 'http://resource.associated.org/10/F7DV1H10,' \
      'http://dx.doi.org/10.5066/F7DV1H10,http://additional.doc/10/F7DV1H10,' \
      'http://additional.doc/56/data.json'

      assert_equal(expected, res)
   end
end
