# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_format

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_format'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152Format < TestReaderIso191152Parent
   @@xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_format.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::Format

   def test_format_complete
      TestReaderIso191152Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//gmd:distributorFormat')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      refute_empty hDictionary[:formatSpecification]
      assert hDictionary[:formatSpecification].instance_of? Hash
   end
end
