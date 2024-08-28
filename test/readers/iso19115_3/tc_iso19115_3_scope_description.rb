# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_scope_description

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_scope_description'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153ScopeDescription < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::ScopeDescription

   def test_scope_description_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mcc:levelDescription')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal('ClrOLR*', hDictionary[:dataset])
      assert_equal('various attributes', hDictionary[:attributes])
      assert_equal('swaths, grids', hDictionary[:features])
      assert_equal('Zambia field study 2007', hDictionary[:other])
   end
end
