# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_distributor

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_distributor'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Distributor < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Distributor

   def test_distributor_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mrd:distributor')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      refute_empty hDictionary[:contact]
      assert hDictionary[:contact].instance_of? Hash
      refute_empty hDictionary[:orderProcess]
      assert hDictionary[:orderProcess].instance_of? Array
      assert_equal(1, hDictionary[:orderProcess].size)
      refute_empty hDictionary[:transferOptions]
      assert hDictionary[:transferOptions].instance_of? Array
      assert_equal(1, hDictionary[:transferOptions].size)
   end
end
