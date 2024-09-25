# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_bounding_box

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_bounding_box'
require_relative 'iso19115_2_test_parent'
require 'debug'
class TestReaderIso191152BoundingBox < TestReaderIso191152Parent
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::BoundingBox

   def test_bounding_box_complete
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:geographicElement')[2]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert_equal(-166.0, hDictionary[:westLongitude])
      assert_equal(-74.0, hDictionary[:eastLongitude])
      assert_equal(24.0, hDictionary[:southLatitude])
      assert_equal(71.0, hDictionary[:northLatitude])
      assert_nil hDictionary[:minimumAltitude]
      assert_nil hDictionary[:maximumAltitude]
      assert_nil hDictionary[:unitsOfAltitude]
   end

   def test_no_boundingbox_boundlatitude
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_no_spatial_boundlatitude.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:geographicElement')[1]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      assert_equal(["WARNING: ISO19115-2 reader: element 'gmd:westBoundLongitude' is missing in gmd:EX_GeographicBoundingBox"],
                   hResponse[:readerExecutionMessages])
      assert_equal(false, hResponse[:readerExecutionPass])
   end

end
