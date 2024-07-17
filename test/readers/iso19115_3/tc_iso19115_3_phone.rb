# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_phone

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_phone'
require_relative 'iso19115_3_test_parent'
require 'debug'

class TestReaderIso191153Telephone < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Telephone

   def test_phone_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//cit:phone')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_nil(hDictionary[:phoneName])
      assert_equal('907-786-7000', hDictionary[:phoneNumber])
      assert_equal(['voice'], hDictionary[:phoneServiceTypes])
   end
end
