# MdTranslator - minitest of
# adiwg / mdtranslator / mdReaders / fgdc_reader

# History:
#   Stan Smith 2017-08-14 original script

require 'minitest/autorun'
require 'nokogiri'
require 'adiwg/mdtranslator'
require 'debug'
require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_iso19115_3'
require 'adiwg/mdtranslator/writers/dcat_us/sections/dcat_us_access_level'

class TestIso191153DcatusTranslation < Minitest::Test
   @@hResponseObj = {
      readerExecutionPass: true,
      readerExecutionMessages: []
   }
   def test_access_level_translate
      file = File.join(File.dirname(__FILE__), 'testData', 'iso19115-3.xml')
      xml = Nokogiri::XML(File.read(file))

      xIn = xml.xpath('mdb:MD_Metadata')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))

      metadataNs = ADIWG::Mdtranslator::Readers::Iso191153::Iso191153
      intMetadata = metadataNs.unpack(xIn, hResponse)

      accessLevelNS = ADIWG::Mdtranslator::Writers::Dcat_us::AccessLevel
      sAccessLevel = accessLevelNS.build(intMetadata)

      assert_equal('non-public', sAccessLevel)
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
end
