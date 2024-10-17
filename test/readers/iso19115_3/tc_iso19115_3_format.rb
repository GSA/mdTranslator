# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_format

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_format'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Format < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Format

   def test_format_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mrd:distributionFormat')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      refute_empty hDictionary[:formatSpecification]
      assert hDictionary[:formatSpecification].instance_of? Hash
   end
end
