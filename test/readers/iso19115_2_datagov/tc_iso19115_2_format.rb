# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_format

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_format'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovFormat < TestReaderIso191152datagovParent
  @@xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_format.xml')
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::Format

  def test_format_complete
    TestReaderIso191152datagovParent.set_xdoc(@@xDoc)

    xIn = @@xDoc.xpath('.//gmd:distributorFormat')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)
    refute_empty hDictionary
    assert hDictionary.instance_of? Hash
    refute_empty hDictionary[:formatSpecification]
    assert hDictionary[:formatSpecification].instance_of? Hash
    assert_equal('format specification', hDictionary[:formatSpecification][:title])
  end

  def test_no_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_format_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:distributorFormat')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    warnings = [
      "WARNING: ISO19115-2 reader: element 'name' is missing valid nil reason within 'MD_Format'"
    ]

    assert_equal(warnings, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_yes_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_format_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:distributorFormat')[1]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    infos = [
      "INFO: ISO19115-2 reader: element 'name' contains acceptable nilReason: 'test:uripath'"
    ]
    assert_equal(infos, hResponse[:readerValidationMessages])
    assert_equal(true, hResponse[:readerValidationPass])
  end
end
