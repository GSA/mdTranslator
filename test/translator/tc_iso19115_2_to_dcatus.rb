# frozen_string_literal: true

# MdTranslator - minitest of
# adiwg / mdtranslator / mdReaders / iso19115-2 reader & dcatus writer

require 'minitest/autorun'
require 'nokogiri'
require 'json'
require 'adiwg/mdtranslator'
require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_iso19115_2'
require 'adiwg/mdtranslator/writers/dcat_us/sections/dcat_us_dcat_us'

# these tests are organized according to how data is processed in
# the dcat_us writer lib/adiwg/mdtranslator/writers/dcat_us/sections/dcat_us_dcat_us.rb

class TestIso191152DcatusTranslation < Minitest::Test
   @@hResponseObj = {
      readerExecutionPass: true,
      readerExecutionMessages: [],
      readerStructurePass: true,
      readerStructureMessages: []
   }
   # keeping these here for now. TODO: will add more files to test against
   @@file = File.join(File.dirname(__FILE__), 'testData', 'iso19115-2.xml')
   @@fileData = File.read(@@file)
   @@xml = Nokogiri::XML(@@fileData)

   @@xIn = @@xml.xpath('gmi:MI_Metadata')[0]
   @@hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
   @@iso191152NS = ADIWG::Mdtranslator::Readers::Iso191152::Iso191152

   @@intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

   def test_citation_title
      expected = 'ISO19115-2 citation title test 123456'

      assert_equal(expected, @@intMetadata[:metadata][:resourceInfo][:citation][:title])
   end

   def test_description
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Description
      res = dcatusNS.build(@@intMetadata)

      assert_equal('abstract', res)
   end

   def test_keyword
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Keyword
      res = dcatusNS.build(@@intMetadata)

      assert_equal(%w[biota farming], res)
   end

   def test_modified
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Modified
      res = dcatusNS.build(@@intMetadata)

      assert_equal(DateTime.iso8601('2023-11-22T00:00:00+00:00'), res)
   end

   def test_publisher
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Publisher
      res = dcatusNS.build(@@intMetadata).target!

      expected = '{"@type":"org:Organization","name":"citation organization name"}'
      assert_equal(expected, res)
   end

   def test_contact_point
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::ContactPoint
      res = dcatusNS.build(@@intMetadata).target!

      expected = '{"@type":"vcard:Contact","fn":"test person test name","hasEmail":"whatever@gmail.com"}'
      assert_equal(expected, res)
   end

   def test_access_level
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::AccessLevel
      res = dcatusNS.build(@@intMetadata)
      assert_equal('non-public', res)
   end

   def test_spatial
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Spatial
      res = dcatusNS.build(@@intMetadata)

      expected = '-74.0,24.0,-166.0,71.0'
      assert_equal(expected, res)
   end

   def test_temporal
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Temporal
      res = dcatusNS.build(@@intMetadata)

      expected = '2017-12-01T00:00:00+00:00/2023-12-01T00:00:00+00:00'
      assert_equal(expected, res)
   end

   def test_issued
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Issued
      res = dcatusNS.build(@@intMetadata)

      assert_equal(DateTime.iso8601('2017-01-01T00:00:00+00:00'), res)
   end

   def test_identifier
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Identifier
      res = dcatusNS.build(@@intMetadata)

      assert_equal('ISO19115-2-ID-123456', res)
   end

   def test_rights
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Rights
      res = dcatusNS.build(@@intMetadata, 'non-public')

      assert_equal('use constraint limitation value 123 use constraint limitation abc', res)
   end

   def test_is_part_of
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::IsPartOf
      res = dcatusNS.build(@@intMetadata)

      assert_equal('ISO19115-2-ID-123456-parent', res)
   end

   def test_system_of_records
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::SystemOfRecords
      res = dcatusNS.build(@@intMetadata)

      assert_equal('aggregate_information_online_resources', res)
   end

   def test_theme
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Theme
      res = dcatusNS.build(@@intMetadata)
      assert_equal('biota farming', res)
   end

   def test_references
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::References
      res = dcatusNS.build(@@intMetadata)

      expected = 'aggregate_information_online_resources,aggregate_information_online_resources 12309u,https://aggregation_info_sample_url.gov'
      assert_equal(expected, res)
   end

   def test_landing_page
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::IsPartOf
      res = dcatusNS.build(@@intMetadata)

      assert_equal('ISO19115-2-ID-123456-parent', res)
   end

   def test_primaryitinvestmentuii
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::PrimaryITInvestmentUII
      res = dcatusNS.build(@@intMetadata)

      assert_equal('ISO19115-2-ID-123456', res)
   end

   def test_accrual_periodicity
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::AccrualPeriodicity
      res = dcatusNS.build(@@intMetadata)

      assert_equal('R/P1M', res)
   end

end
