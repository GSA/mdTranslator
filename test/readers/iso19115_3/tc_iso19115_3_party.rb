# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_organization

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_party'
require_relative 'iso19115_3_test_parent'
require 'debug'

class TestReaderIso191153Party < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Party

   def test_party_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//cit:CI_Responsibility')[2]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hArray = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hArray
      assert hArray.instance_of? Array
      assert_equal(2, hArray.size)
   end
end
