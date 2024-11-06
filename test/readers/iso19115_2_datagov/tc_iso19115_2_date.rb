# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_date

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_date'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovDate < TestReaderIso191152datagovParent
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::Date

  def test_date_complete
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:date')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert hDictionary.instance_of? Hash
    assert_equal(DateTime.iso8601('2017-01-01T00:00:00+00:00'), hDictionary[:date])
    assert_equal('YMDhms', hDictionary[:dateResolution])
    assert_equal('publication', hDictionary[:dateType])
  end

  def test_no_date_date
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_date_date.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:date')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    assert_equal("WARNING: ISO19115-2 reader: element 'gmd:date' is missing in CI_Date",
                 hResponse[:readerValidationMessages][0])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_no_date_datetype
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_date_datetype.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:date')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    expected = ["WARNING: ISO19115-2 reader: element 'gmd:dateType' is missing in CI_Date"]

    assert_equal(expected,
                 hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_nilreason
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_date_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:date')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    warnings = [
      "WARNING: ISO19115-2 reader: element 'date' is missing valid nil reason " \
      "within 'CI_Date'",
      "WARNING: ISO19115-2 reader: element 'dateType' is missing valid nil reason " \
      "within 'CI_Date'"
    ]

    assert_equal(warnings, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_yes_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_date_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:date')[2]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    infos = [
      "INFO: ISO19115-2 reader: element 'date' contains acceptable nilReason: 'template'",
      "INFO: ISO19115-2 reader: element 'dateType' contains acceptable nilReason: 'withheld'"
    ]

    assert_equal(infos, hResponse[:readerValidationMessages])
    assert_equal(true, hResponse[:readerValidationPass])
  end
end
