# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_metadata

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_metadata'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovMetadata < TestReaderIso191152datagovParent
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::Metadata

  def test_metadata_complete
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')

    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('gmi:MI_Metadata')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert hDictionary.instance_of? Hash
    refute_empty hDictionary[:resourceInfo]
    assert hDictionary[:resourceInfo].instance_of? Hash
  end

  def test_missing_id_info
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_idinfo.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('gmi:MI_Metadata')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    expected = ["WARNING: ISO19115-2 reader: element 'gmd:identificationInfo' is missing in MI_Metadata",
                "INFO: ISO19115-2 reader: element 'contact' contains acceptable nilReason: 'unknown'"]

    assert_equal(expected,
                 hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_no_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_metadata_no_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('gmi:MI_Metadata')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    warnings = [
      "WARNING: ISO19115-2 reader: element 'identificationInfo' is missing valid nil reason within 'MI_Metadata'",
      "INFO: ISO19115-2 reader: element 'contact' contains acceptable nilReason: 'unknown'"
    ]

    assert_equal(warnings, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_yes_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_metadata_yes_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('gmi:MI_Metadata')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    infos = ["INFO: ISO19115-2 reader: element 'identificationInfo' contains acceptable nilReason: 'missing'",
             "INFO: ISO19115-2 reader: element 'contact' contains acceptable nilReason: 'unknown'"]

    assert_equal(infos, hResponse[:readerValidationMessages])
    assert_equal(true, hResponse[:readerValidationPass])
  end
end
