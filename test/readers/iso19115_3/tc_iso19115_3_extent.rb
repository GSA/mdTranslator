# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_extent

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_extent'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Extent < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Extent

   def test_responsibility_extent_complete # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//cit:CI_Responsibility')[0] # we want the first one
      xExtents = xIn.xpath('cit:extent')
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      extentArray = xExtents.map { |e| @@nameSpace.unpack(e, hResponse) }

      refute_empty extentArray
      assert_equal(4, extentArray.size)
      assert extentArray.instance_of? Array

      geoExtent, temporalExtent, vertExtent, multipleExtents = extentArray

      # :geographicExtents
      # TODO: bounding polygon!
      refute_empty geoExtent
      assert geoExtent.instance_of? Hash
      refute_empty geoExtent[:geographicExtents]
      assert geoExtent[:geographicExtents].instance_of? Array
      assert_equal(3, geoExtent[:geographicExtents].size)
      assert_equal('geographic extent description', geoExtent[:description])
      assert_empty geoExtent[:temporalExtents]
      assert geoExtent[:temporalExtents].instance_of? Array
      assert_empty geoExtent[:verticalExtents]
      assert geoExtent[:verticalExtents].instance_of? Array

      # :temporalExtents
      refute_empty temporalExtent
      assert temporalExtent.instance_of? Hash
      assert_equal('temporal extent description', temporalExtent[:description])

      assert_empty temporalExtent[:geographicExtents]
      assert temporalExtent[:geographicExtents].instance_of? Array
      assert_equal(0, temporalExtent[:geographicExtents].size)

      refute_empty temporalExtent[:temporalExtents]
      assert temporalExtent[:temporalExtents].instance_of? Array
      assert_equal(1, temporalExtent[:temporalExtents].size)

      assert_empty temporalExtent[:verticalExtents]
      assert temporalExtent[:verticalExtents].instance_of? Array
      assert_equal(0, temporalExtent[:verticalExtents].size)

      # :verticalExtents
      refute_empty vertExtent
      assert vertExtent.instance_of? Hash
      assert_equal('vertical extent description', vertExtent[:description])

      assert_empty vertExtent[:geographicExtents]
      assert vertExtent[:geographicExtents].instance_of? Array
      assert_equal(0, vertExtent[:geographicExtents].size)

      assert_empty vertExtent[:temporalExtents]
      assert vertExtent[:temporalExtents].instance_of? Array
      assert_equal(0, vertExtent[:temporalExtents].size)

      refute_empty vertExtent[:verticalExtents]
      assert vertExtent[:verticalExtents].instance_of? Array
      assert_equal(1, vertExtent[:verticalExtents].size)

      # various extents
      refute_empty multipleExtents
      assert multipleExtents.instance_of? Hash

      refute_empty multipleExtents[:geographicExtents]
      assert multipleExtents[:geographicExtents].instance_of? Array
      assert_equal(1, multipleExtents[:geographicExtents].size)

      refute_empty multipleExtents[:temporalExtents]
      assert multipleExtents[:temporalExtents].instance_of? Array
      assert_equal(1, multipleExtents[:temporalExtents].size)

      refute_empty multipleExtents[:verticalExtents]
      assert multipleExtents[:verticalExtents].instance_of? Array
      assert_equal(1, multipleExtents[:verticalExtents].size)

      # add more assertions here...
   end
end
