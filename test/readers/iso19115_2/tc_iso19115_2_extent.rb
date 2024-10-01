# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_extent

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_extent'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152Extent < TestReaderIso191152Parent
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::Extent

   def test_extent_complete 
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:extent')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal(1, hDictionary[:geographicExtents].size)
      assert_equal(1, hDictionary[:temporalExtents].size)

   end
end
