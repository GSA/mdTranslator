# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_responsibility

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_responsibility'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152Responsibility < TestReaderIso191152Parent
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::Responsibility

   def test_responsibility_complete
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

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
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_rp_no_rolecode.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:citedResponsibleParty')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      _hDictionary = @@nameSpace.unpack(xIn, hResponse)

      expected = ["WARNING: ISO19115-2 reader: element 'gmd:role//gmd:CI_RoleCode' is missing in 'CI_ResponsibleParty'"]

      assert_equal(expected, hResponse[:readerExecutionMessages])
      assert_equal(false, hResponse[:readerExecutionPass])
   end

   def test_responsibility_no_ind_or_org
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_rp_no_ind_or_org.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:citedResponsibleParty')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      _hDictionary = @@nameSpace.unpack(xIn, hResponse)

      expected = "WARNING: ISO19115-2 reader: 'gmd:CI_ResponsibleParty' must have "\
      'at least an individual or organization. neither are present.'

      assert_equal([expected], hResponse[:readerExecutionMessages])
      assert_equal(false, hResponse[:readerExecutionPass])
   end
end
