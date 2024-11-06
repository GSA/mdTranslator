# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_responsibility

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_responsibility'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovResponsibility < TestReaderIso191152datagovParent
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::Responsibility

  def test_responsibility_complete
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:citedResponsibleParty')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert hDictionary.instance_of? Hash
    assert_equal('publisher', hDictionary[:roleName])
    assert_equal(1, hDictionary[:parties].size)

    party = hDictionary[:parties][0]
    assert_equal(true, party[:isOrganization])
    assert_equal('citation organization name', party[:name])
    assert_equal('organization', party[:contactType])
    assert_equal('citation organization name', party[:contactName])

    assert_equal(['test@gmail.com'], party[:eMailList])
  end

  def test_responsibility_no_role_code
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_rp_no_rolecode.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:citedResponsibleParty')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    expected = ["WARNING: ISO19115-2 reader: element 'gmd:role' is missing in 'CI_ResponsibleParty'"]

    assert_equal(expected, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_no_nil_reasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_responsibility_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:citedResponsibleParty')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    warnings = [
      "WARNING: ISO19115-2 reader: element 'role' is missing valid " \
    "nil reason within 'CI_ResponsibleParty'"
    ]

    assert_equal(warnings, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_yes_nil_reasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_responsibility_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:citedResponsibleParty')[1]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    infos = ["INFO: ISO19115-2 reader: element 'role' contains acceptable nilReason: 'missing'"]

    assert_equal(infos, hResponse[:readerValidationMessages])
    assert_equal(true, hResponse[:readerValidationPass])
  end
end
