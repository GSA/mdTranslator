# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_citation

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_citation'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovCitation < TestReaderIso191152datagovParent
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::Citation

  def test_citation_complete
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:citation')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert hDictionary.instance_of? Hash
    assert_equal('ISO19115-2 citation title test 123456', hDictionary[:title])
    assert_equal(3, hDictionary[:dates].size)
    assert_equal(1, hDictionary[:responsibleParties].size)
  end

  def test_no_citation_title
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_cit_title.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:citation')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    assert_equal("WARNING: ISO19115-2 reader: element 'gmd:title' is missing in 'CI_Citation'",
                 hResponse[:readerValidationMessages][0])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_no_citation_date
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_cit_date.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:citation')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    assert_equal(["WARNING: ISO19115-2 reader: element 'gmd:date' is missing in 'CI_Citation'"],
                 hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_no_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_citation_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:citation')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    warnings = [
      "WARNING: ISO19115-2 reader: element 'title' is missing " \
      "valid nil reason within 'CI_Citation'",
      "WARNING: ISO19115-2 reader: element 'gmd:date' is missing " \
      "valid nil reason within 'CI_Citation'"
    ]

    assert_equal(warnings, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_yes_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_citation_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:citation')[1]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    infos = [
      "INFO: ISO19115-2 reader: element 'title' contains acceptable nilReason: 'unavailable'",
      "INFO: ISO19115-2 reader: element 'date' contains acceptable nilReason: 'missing'"
    ]

    assert_equal(infos, hResponse[:readerValidationMessages])
    assert_equal(true, hResponse[:readerValidationPass])
  end
end
