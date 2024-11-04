# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_keyword

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_keyword'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovKeyword < TestReaderIso191152datagovParent
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::Keyword

  def test_keyword_complete
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:descriptiveKeywords')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert hDictionary.instance_of? Hash

    refute_empty hDictionary[:thesaurus]

    expected = [{ keyword: 'biota', keywordId: nil }, { keyword: 'farming', keywordId: nil }]
    assert_equal(expected, hDictionary[:keywords])
  end

  def test_no_keyword_keyword
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_keyword_keyword.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:descriptiveKeywords')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    assert_equal(["WARNING: ISO19115-2 reader: element 'gmd:keyword' is missing in 'MD_Keywords'"],
                 hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_no_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_keyword_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:descriptiveKeywords')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    warnings = [
      "WARNING: ISO19115-2 reader: element 'gmd:keyword' is missing in 'MD_Keywords'"
    ]

    assert_equal(warnings, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_yes_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_keyword_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:descriptiveKeywords')[1]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    infos = [
      "INFO: ISO19115-2 reader: element 'keyword' contains acceptable nilReason: 'missing'"
    ]

    assert_equal(infos, hResponse[:readerValidationMessages])
    assert_equal(true, hResponse[:readerValidationPass])
  end
end
