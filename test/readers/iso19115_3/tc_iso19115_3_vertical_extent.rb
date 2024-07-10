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

      xIn = @@xDoc.xpath('.//gex:EX_Extent')[2] # we want the first 2nd one
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hArray = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hArray
      assert hArray.instance_of? Array

      vertExtent = hArray[0]

      assert_equal(-1000, vertExtent[:minValue])
      assert_equal(1000, vertExtent[:maxValue])

      crsId = vertExtent[:crsId]

      refute_empty crsId
   end
end
