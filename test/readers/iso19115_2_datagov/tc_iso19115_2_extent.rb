# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_extent

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_extent'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovExtent < TestReaderIso191152datagovParent
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::Extent

   def test_extent_complete
      xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
      TestReaderIso191152datagovParent.set_xdoc(xDoc)

      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))

      xIn = xDoc.xpath('.//gmd:extent')[0]
      hDictionary = @@nameSpace.unpack(xIn, hResponse)
      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal(1, hDictionary[:geographicExtents].size)
      assert_equal(1, hDictionary[:temporalExtents].size)
   end
end
