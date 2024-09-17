# frozen_string_literal: true

# MdTranslator - minitest of
# adiwg / mdtranslator / mdReaders / iso19115-2 reader & dcatus writer

require 'minitest/autorun'
require 'nokogiri'
require 'json'
require 'adiwg/mdtranslator'
require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_iso19115_2'
require 'adiwg/mdtranslator/writers/dcat_us/sections/dcat_us_dcat_us'
require 'debug'

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

      expected = '{"@type":"org:Organization","name":"organization name"}'
      assert_equal(expected, res)
   end

   def test_contact_point
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::ContactPoint
      res = dcatusNS.build(@@intMetadata).target!

      expected = '{"@type":"vcard:Contact","fn":"person name","hasEmail":"email@test.com"}'
      assert_equal(expected, res)
   end

   def test_access_level
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::AccessLevel
      res = dcatusNS.build(@@intMetadata)
      assert_equal('public', res)
   end

   def test_theme
      dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Theme
      res = dcatusNS.build(@@intMetadata)

      assert_equal('biota farming', res)
   end
end