# frozen_string_literal: true

# MdTranslator - minitest of
# adiwg / mdtranslator / mdReaders / iso19115-3 reader & dcatus writer

require 'minitest/autorun'
require 'nokogiri'
require 'json'
require 'adiwg/mdtranslator'
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
  @@fileData = File.read(@@file)
  @@xml = Nokogiri::XML(@@fileData)

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

  # TODO: fix and add back this test
  #    def test_description
  #       dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Description
  #       res = dcatusNS.build(@@intMetadata)

  #       expected = 'Climate change has been shown to influence lake ' \
  #       'temperatures globally. To better understand the diversity of lake ' \
  #       'responses to climate change and give managers tools to manage individual ' \
  #       'lakes, we modelled daily water temperature profiles for 10,774 lakes in ' \
  #       'Michigan, Minnesota and Wisconsin for contemporary (1979-2015) and future ' \
  #       '(2020-2040 and 2080-2100) time periods with climate models based on the ' \
  #       'Representative Concentration Pathway 8.5, the worst-case emission scenario.'

  #       assert_equal(expected, res)
  #    end

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

  def test_publisher_translate
    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Publisher
    res = dcatusNS.build(@@intMetadata).target!

    expected = '{"@type":"org:Organization","name":"U.S. Geological Survey, Alaska Science Center"}'
    assert_equal(expected, res)
  end

  # TODO: fix and add back this test
  #    def test_contact_point_translate
  #       dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::ContactPoint
  #       res = dcatusNS.build(@@intMetadata).target!

  #       expected = '{"@type":"vcard:Contact","fn":"Robert G Test","hasEmail":"email@address.com"}'
  #       assert_equal(expected, res)
  #    end

  def test_access_level_translate
    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::AccessLevel
    res = dcatusNS.build(@@intMetadata)

    assert_equal('non-public', res)
  end

  # TODO: fix and add back this test
  #    def test_identifier_translate
  #       dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Identifier
  #       res = dcatusNS.build(@@intMetadata)

  #       assert_equal('57d97341e4b090824ffb0e6f', res)
  #    end

  def test_distribution_translate
    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Distribution
    res = dcatusNS.build(@@intMetadata)

    refute_empty res
    assert res.instance_of? Array
    assert_equal(1, res.size)

    dist = res[0]
    assert_equal('dcat:Distribution', dist['@type'])
    assert_equal('description of the online resource via transfer options', dist['description'])
    assert_equal('https://distributiontransfer.com/onlineresource.png', dist['downloadURL'])
    assert_equal('format specification', dist['mediaType'])
    assert_equal('name test 123', dist['title'])
  end

  # TODO: fix and add back this test
  #    def test_rights_translate
  #       dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Rights
  #       accessLevelNS = ADIWG::Mdtranslator::Writers::Dcat_us::AccessLevel
  #       accessLevel = accessLevelNS.build(@@intMetadata)
  #       res = dcatusNS.build(@@intMetadata, accessLevel)

  #       expected = 'Common constraint for use of this thing Important Disclaimer'
  #       assert_equal(expected, res)
  #    end

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

  # def test_is_part_of_translate
  #    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::IsPartOf
  #    res = dcatusNS.build(@@intMetadata)

  #    assert_equal('http://resource.associated.org/10/F7DV1H10', res)
  # end

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
    'http://as0d1028h3.associated.org/10/F7DV1H10,'\
    'http://dx.doi.org/10.5066/F7DV1H10,http://additional.doc/10/F7DV1H10,' \
    'http://additional.doc/56/data.json'

    assert_equal(expected, res)
  end

  # def test_landing_page_translate
  #    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::LandingPage
  #    res = dcatusNS.build(@@intMetadata)

  #    assert_equal('http://dx.doi.org/10.5066/F7DV1H10', res)
  # end

  def test_system_of_records_translate
    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::SystemOfRecords
    res = dcatusNS.build(@@intMetadata)

    assert_equal('http://as0d1028h3.associated.org/10/F7DV1H10', res)
  end

  def test_describe_by_type_translate
    # describebytype returns the protocol of the first non-empty url str
    # that doesnt end with '.html' which can produce nils. odd.
    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::DescribedByType
    res = dcatusNS.build(@@intMetadata)

    assert_equal('https', res)
  end

  # def test_accrual_periodicity_translate
  #    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::AccrualPeriodicity
  #    res = dcatusNS.build(@@intMetadata)

  #    assert_equal('R/P2M or R/P0.5M', res)
  # end

  def test_primaryit_investment_uii_translate
    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::PrimaryITInvestmentUII
    res = dcatusNS.build(@@intMetadata)

    assert_equal('57d97341e4b090824ffb0e6f', res)
  end

  # skipping program code and bureau code...

  # TODO: fix and add back this test
  #    def test_complete_translate
  #       metadata = ADIWG::Mdtranslator.translate(
  #          file: @@fileData, reader: 'iso19115_3', writer: 'dcat_us'
  #       )

  #       f = File.join(File.dirname(__FILE__), 'testData', 'iso19115-3-to-dcatus.json')
  #       expected = File.open(f).read

  #       assert_equal('iso19115_3', metadata[:readerRequested])
  #       assert_equal('dcat_us', metadata[:writerRequested])
  #       assert_equal(true, metadata[:readerStructurePass])
  #       assert_equal(true, metadata[:readerValidationPass])
  #       assert_equal(true, metadata[:readerExecutionPass])
  #       assert_equal(true, metadata[:writerPass])
  #       assert_equal(expected.gsub(/\s+/, ''), metadata[:writerOutput].gsub(/\s+/, ''))
  #    end
end
