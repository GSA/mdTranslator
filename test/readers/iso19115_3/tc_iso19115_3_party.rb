# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_party

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_party'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Party < TestReaderIso191153Parent
   # TODO: the Party module needs to be revisited.
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Party

   def test_party_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//cit:CI_Responsibility//cit:party')[1]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
   end
end
