# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_extent

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_geographic_extent'
require_relative 'iso19115_2_test_parent'
class TestReaderIso191152Extent < TestReaderIso191152Parent
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::GeographicExtent

   def test_geographic_extent_complete 
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:geographicElement')
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary[:boundingBox]
      assert_equal("true", hDictionary[:containsData])

   end
end
