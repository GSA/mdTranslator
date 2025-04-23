# frozen_string_literal: true

# MdTranslator - minitest of
# adiwg / mdtranslator / mdReaders / iso19115-2 reader & dcatus writer

require 'minitest/autorun'
require 'nokogiri'
require 'json'
require 'adiwg/mdtranslator'
require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_iso19115_2'
require 'adiwg/mdtranslator/writers/dcat_us/sections/dcat_us_dcat_us'

# these tests are organized according to how data is processed in
# the dcat_us writer lib/adiwg/mdtranslator/writers/dcat_us/sections/dcat_us_dcat_us.rb

class TestIso191152datagovDcatusTranslation < Minitest::Test
  @@hResponseObj = {
    readerExecutionPass: true,
    readerExecutionMessages: [],
    readerStructurePass: true,
    readerStructureMessages: [],
    readerValidationPass: true,
    readerValidationMessages: [],
    writerPass: true,
    writerMessages: []
  }
  # keeping these here for now. TODO: will add more files to test against
  @@file = File.join(File.dirname(__FILE__), 'testData', 'iso19115-2_datagov.xml')
  @@fileData = File.read(@@file)
  @@xml = Nokogiri::XML(@@fileData)

  @@xIn = @@xml.xpath('gmi:MI_Metadata')[0]
  @@hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
  @@iso191152NS = ADIWG::Mdtranslator::Readers::Iso191152datagov::Iso191152datagov

  def test_citation_title
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    expected = 'ISO19115-2 citation title test 123456'

    assert_equal(expected, intMetadata[:metadata][:resourceInfo][:citation][:title])
  end

  def test_description
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Description
    res = dcatusNS.build(intMetadata)

    assert_equal('abstract', res)
  end

  def test_keyword
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Keyword
    res = dcatusNS.build(intMetadata)

    assert_equal(%w[biota farming], res)
  end

  def test_modified
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Modified
    res = dcatusNS.build(intMetadata)

    assert_equal(DateTime.iso8601('2023-11-22T00:00:00+00:00'), res)
  end

  def test_publisher
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Publisher
    res = dcatusNS.build(intMetadata).target!

    expected = '{"@type":"org:Organization","name":"Office of National Marine Sanctuaries"}'
    assert_equal(expected, res)
  end

  def test_distribution
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)
    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Distribution

    res = dcatusNS.build(intMetadata)

    expected = [{ '@type' => 'dcat:Distribution', 'description' => 'online resource description',
                  'downloadURL' => 'online resource URL', 'mediaType' => 'placeholder/value',
                  'title' => 'online resource name' }]
    assert_equal(expected, res)
  end

  def test_contact_point
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    res = ADIWG::Mdtranslator::Writers::Dcat_us.startWriter(intMetadata, @@hResponse)
    data = JSON.parse res

    expected = JSON.parse '{"@type":"vcard:Contact", "fn":"test person test name", "hasEmail":"mailto:whatever@gmail.com"}'
    assert_equal(expected, data['contactPoint'])
  end

  def test_access_level
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::AccessLevel
    res = dcatusNS.build(intMetadata)
    assert_equal('non-public', res)
  end

  def test_spatial
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Spatial
    res = dcatusNS.build(intMetadata)

    expected = '-74.0,24.0,-166.0,71.0'
    assert_equal(expected, res)
  end

  def test_temporal
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Temporal
    res = dcatusNS.build(intMetadata)

    expected = '2017-12-01T00:00:00+00:00/2023-12-01T00:00:00+00:00'
    assert_equal(expected, res)
  end

  def test_issued
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Issued
    res = dcatusNS.build(intMetadata)

    assert_equal(DateTime.iso8601('2017-01-01T00:00:00+00:00'), res)
  end

  def test_language
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Language
    res = dcatusNS.build(intMetadata)
    assert_equal(%w[eng], res)
  end

  def test_described_by
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::DescribedBy
    res = dcatusNS.build(intMetadata)

    assert_equal('https://datadictionaryhost.gov', res)
  end

  def test_identifier
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Identifier
    res = dcatusNS.build(intMetadata)

    assert_equal('ISO19115-2-ID-123456', res)
  end

  def test_rights
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Rights
    res = dcatusNS.build(intMetadata, 'non-public')

    assert_equal('access constraint, classification, restricted', res)
  end

  def test_is_part_of
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::IsPartOf
    res = dcatusNS.build(intMetadata)

    assert_equal('associated resource title 1', res)
  end

  def test_system_of_records
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::SystemOfRecords
    res = dcatusNS.build(intMetadata)

    assert_equal('aggregate_information_online_resources', res)
  end

  def test_described_by_type
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::DescribedByType
    res = dcatusNS.build(intMetadata)

    assert_equal('HTTPS', res)
  end

  def test_theme
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::Theme
    res = dcatusNS.build(intMetadata)
    assert_equal(%w[biota farming], res)
  end

  def test_references
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::References

    # add a duplicate to check against uniqueness in the output
    dup = intMetadata[:metadata][:associatedResources][0][:resourceCitation][:onlineResources][0]
    intMetadata[:metadata][:associatedResources][0][:resourceCitation][:onlineResources] << dup

    res = dcatusNS.build(intMetadata)

    expected = ['aggregate_information_online_resources',
                'aggregate_information_online_resources 12309u',
                'https://aggregation_info_sample_url.gov']

    assert_equal(expected, res)
  end

  def test_landing_page
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::LandingPage
    res = dcatusNS.build(intMetadata)

    assert_equal('https://online_resource_url.gov', res)
  end

  def test_primaryitinvestmentuii
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::PrimaryITInvestmentUII
    res = dcatusNS.build(intMetadata)

    assert_nil res
  end

  def test_accrual_periodicity
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::AccrualPeriodicity
    res = dcatusNS.build(intMetadata)

    assert_equal('R/P1M', res)
  end

  def test_license
    intMetadata = @@iso191152NS.unpack(@@xIn, @@hResponse)

    dcatusNS = ADIWG::Mdtranslator::Writers::Dcat_us::License
    res = dcatusNS.build(intMetadata)
    # TODO: default used. reference https://github.com/GSA/data.gov/issues/4883 for notes
    assert_equal('https://creativecommons.org/publicdomain/zero/1.0/', res)
  end

  def test_valid_full_translate
    metadata = ADIWG::Mdtranslator.translate(
      file: @@fileData, reader: 'iso19115_2_datagov', writer: 'dcat_us'
    )

    f = File.join(File.dirname(__FILE__), 'testData', 'iso19115-2-datagov-to-dcatus.json')
    expected = File.open(f).read

    assert_equal('iso19115_2_datagov', metadata[:readerRequested])
    assert_equal('dcat_us', metadata[:writerRequested])
    assert_equal(true, metadata[:readerStructurePass])
    assert_equal(true, metadata[:readerValidationPass])
    assert_equal(true, metadata[:readerExecutionPass])
    assert_equal(true, metadata[:writerPass])
    assert_equal(expected.gsub(/\s/, ''), metadata[:writerOutput].gsub(/\s/, ''))
  end

  def test_invalid_full_translate
    file = File.join(File.dirname(__FILE__), 'testData', 'invalid_iso19115_2_datagov.xml')
    fileData = File.read(file)

    metadata = ADIWG::Mdtranslator.translate(
      file: fileData, reader: 'iso19115_2_datagov', writer: 'dcat_us'
    )

    assert_equal('iso19115_2_datagov', metadata[:readerRequested])
    assert_equal('dcat_us', metadata[:writerRequested])
    assert_equal(true, metadata[:readerStructurePass])
    assert_equal(false, metadata[:readerValidationPass])
    assert_equal(true, metadata[:readerExecutionPass])
    assert_equal(true, metadata[:writerPass])

    expected = 'WARNING: ISO19115-2 reader: Element gml:endPosition or gml:end ' \
    "is missing valid nilReason within 'TimePeriod'"

    metadata[:readerValidationMessages].include? expected
  end
end
