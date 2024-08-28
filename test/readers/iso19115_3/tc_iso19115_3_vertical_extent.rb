# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_vertical_extent

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_vertical_extent'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153VerticalExtent < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::VerticalExtent

   def test_vertical_extent_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//gex:verticalElement')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash

      assert_equal(-1000, hDictionary[:minValue])
      assert_equal(1000, hDictionary[:maxValue])

      refute_empty hDictionary[:crsId]
   end
end
