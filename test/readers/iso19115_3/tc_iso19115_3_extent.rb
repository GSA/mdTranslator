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

      extent = extentArray[0] # only one with geo data. will handle others later.

      # geo extent data
      geoExtent = extent[:geographicExtents] # TODO: this will eventually be an array

      # bounding box
      geoBoundingBox = geoExtent[:boundingBox]
      assert_equal(-148.87, geoBoundingBox[:westLongitude])
      assert_equal(-148.35, geoBoundingBox[:eastLongitude])
      assert_equal(63.95, geoBoundingBox[:southLatitude])
      assert_equal(64.24, geoBoundingBox[:northLatitude])

      # vertArray TODO
      # temporalArray TODO

      # add more assertions here...
   end
end
