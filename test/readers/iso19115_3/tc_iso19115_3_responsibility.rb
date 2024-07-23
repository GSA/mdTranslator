# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_responsibility

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_responsibility'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Responsibility < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Responsibility

   def test_responsibility_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('mdb:MD_Metadata//mdb:contact')
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal('pointOfContact', hDictionary[:roleName])
      refute_empty hDictionary[:roleExtents]
      assert_equal(4, hDictionary[:roleExtents].size)
      assert_equal(1, hDictionary[:parties].size)
      # add more assertions as more content is complete...
   end
end
