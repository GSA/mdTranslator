# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_resource_info

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_data_identification'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovDataIdentification < TestReaderIso191152datagovParent
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::DataIdentification

  def test_resource_info_complete
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:identificationInfo')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert hDictionary.instance_of? Hash
    refute_empty hDictionary[:citation]
    assert hDictionary[:citation].instance_of? Hash
    assert_equal('abstract', hDictionary[:abstract])
  end

  def test_no_citation
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_cit_dataid.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:identificationInfo')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    assert_equal("WARNING: ISO19115-2 reader: element 'gmd:citation' is missing in MD_DataIdentification",
                 hResponse[:readerValidationMessages][0])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_no_abstract
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_abstract_dataid.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:identificationInfo')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    expected = "WARNING: ISO19115-2 reader: element 'gmd:abstract'"\
    ' is missing in MD_DataIdentification'
    assert_equal([expected],
                 hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_data_identification_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:identificationInfo')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    warnings = [
      "WARNING: ISO19115-2 reader: element 'citation' is missing valid nil " \
      "reason within 'MD_DataIdentification'",
      "WARNING: ISO19115-2 reader: element 'abstract' is missing valid nil " \
      "reason within 'MD_DataIdentification'"
    ]
    assert_equal(warnings, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_yes_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_data_identification_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:identificationInfo')[1]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    infos = [
      "INFO: ISO19115-2 reader: element 'citation' contains acceptable nilReason: 'unavailable'",
      "INFO: ISO19115-2 reader: element 'abstract' contains acceptable nilReason: 'other:ab128e018h'"
    ]

    assert_equal(infos, hResponse[:readerValidationMessages])
    assert_equal(true, hResponse[:readerValidationPass])
  end
end
