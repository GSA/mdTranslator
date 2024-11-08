# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_time_instant

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_time_instant'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovTimeInstant < TestReaderIso191152datagovParent
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::TimeInstant

  def test_time_instant_complete
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('//gmd:EX_TemporalExtent/gmd:extent')[1]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert_equal('boundingTemporalExtent-1-1', hDictionary[:timeId])
    assert_equal({ dateTime: '2013-01-30T00:00:00+00:00', dateResolution: 'YMD' },
                 hDictionary[:timeInstant])
  end

  def test_no_id_attr
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_time_instant.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('//gmd:EX_TemporalExtent/gmd:extent')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hResponse
    assert_equal(false, hResponse[:readerValidationPass])

    warnings = [
      "WARNING: ISO19115-2 reader: element 'gml:TimeInstant' is missing valid gml:id"
    ]

    assert_equal(warnings, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_no_time_positjon
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_time_instant.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('//gmd:EX_TemporalExtent/gmd:extent')[1]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    warnings = [
      "WARNING: ISO19115-2 reader: element 'gml:timePosition' is missing in 'TimeInstant'"
    ]

    assert_equal(warnings, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_yes_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_time_instant.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('//gmd:EX_TemporalExtent/gmd:extent')[2]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    warnings = [
      'WARNING: ISO19115-2 reader: Element gml:timePosition is missing ' \
      "valid nilReason within 'TimeInstant'"
    ]

    assert_equal(warnings, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_no_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_time_instant.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('//gmd:EX_TemporalExtent/gmd:extent')[3]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    warnings = [
      'WARNING: ISO19115-2 reader: Element gml:timePosition is missing '\
      "valid nilReason within 'TimeInstant'"
    ]

    assert_equal(warnings, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end
end
