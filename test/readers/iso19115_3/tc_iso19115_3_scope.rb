# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_scope

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_scope'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Scope < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Scope
   def test_scope_is_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mco:constraintApplicationScope')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal('dataset', hDictionary[:scopeCode])

      refute_empty hDictionary[:scopeDescriptions]
      assert hDictionary[:scopeDescriptions].instance_of? Array
      assert_equal(1, hDictionary[:scopeDescriptions].size)

      refute_empty hDictionary[:extents]
      assert hDictionary[:extents].instance_of? Array
      assert_equal(1, hDictionary[:extents].size)
   end
end
