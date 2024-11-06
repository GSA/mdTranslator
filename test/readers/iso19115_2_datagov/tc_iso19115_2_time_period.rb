# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_time_period

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_time_period'
require_relative 'iso19115_2_test_parent'
require 'debug'

class TestReaderIso191152datagovTimePeriod < TestReaderIso191152datagovParent
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::TimePeriod

  def test_time_period_complete
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('//gmd:EX_TemporalExtent/gmd:extent')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert_equal({ dateTime: '2017-12-01T00:00:00+00:00', dateResolution: 'YMDhms' },
                 hDictionary[:startDateTime])
    assert_equal({ dateTime: '2023-12-01T00:00:00+00:00', dateResolution: 'YMDhms' },
                 hDictionary[:endDateTime])
  end

  def test_no_time_period_begin
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_temporal_timeperiod.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:extent')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    assert_equal(['WARNING: ISO19115-2 reader: Element gml:beginPosition or gml:begin is missing in gml:TimePeriod'],
                 hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_no_time_period_end
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_temporal_timeperiod.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:extent')[1]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    assert_equal(['WARNING: ISO19115-2 reader: Element gml:endPosition or gml:end is missing in gml:TimePeriod'],
                 hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_no_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_time_period_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:extent')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    warnings = [
      'WARNING: ISO19115-2 reader: Element gml:beginPosition or gml:begin is missing ' \
      "valid nilReason within 'TimePeriod'",
      'WARNING: ISO19115-2 reader: Element gml:endPosition or gml:end is missing ' \
      "valid nilReason within 'TimePeriod'"
    ]

    assert_equal(warnings, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_yes_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_time_period_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:extent')[1]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    infos = [
      "INFO: ISO19115-2 reader: element 'begin' contains acceptable nilReason: 'missing'",
      "INFO: ISO19115-2 reader: element 'end' contains acceptable nilReason: 'now'"
    ]
    assert_equal(infos, hResponse[:readerValidationMessages])
    assert_equal(true, hResponse[:readerValidationPass])
  end
end
