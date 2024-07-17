# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_extent

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_extent'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Extent < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Extent

   def test_responsibility_extent_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//cit:CI_Responsibility')[0] # we want the first one
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      extentArray = @@nameSpace.unpack(xIn, hResponse)

      refute_empty extentArray
      assert_equal(3, extentArray.size)

      geoExtent, temporalExtent, vertExtent = extentArray

      # :geographicExtents
      refute_empty geoExtent
      refute_empty geoExtent[:geographicExtents]
      assert geoExtent[:geographicExtents].instance_of? Array
      assert_equal('geographic extent description', geoExtent[:description])

      # :temporalExtents
      refute_empty temporalExtent
      refute_empty temporalExtent[:temporalExtents]
      assert temporalExtent[:temporalExtents].instance_of? Array
      assert_equal('temporal extent description', temporalExtent[:description])

      # :verticalExtents
      refute_empty vertExtent
      refute_empty vertExtent[:verticalExtents]
      assert vertExtent[:verticalExtents].instance_of? Array
      assert_equal('vertical extent description', vertExtent[:description])

      # add more assertions here...
   end
end
