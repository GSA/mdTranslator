# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_bounding_box

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_bounding_box'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovBoundingBox < TestReaderIso191152datagovParent
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::BoundingBox

   def test_bounding_box_complete
      xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
      TestReaderIso191152datagovParent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:geographicElement')[0]
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
      xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_spatial_boundingbox.xml')
      TestReaderIso191152datagovParent.set_xdoc(xDoc)

      warnings = [
         "WARNING: ISO19115-2 reader: element 'gmd:westBoundLongitude' is missing in gmd:EX_GeographicBoundingBox",
         "WARNING: ISO19115-2 reader: element 'gmd:eastBoundLongitude' is missing in gmd:EX_GeographicBoundingBox",
         "WARNING: ISO19115-2 reader: element 'gmd:southBoundLatitude' is missing in gmd:EX_GeographicBoundingBox",
         "WARNING: ISO19115-2 reader: element 'gmd:northBoundLatitude' is missing in gmd:EX_GeographicBoundingBox"
      ]

      xDoc.xpath('.//gmd:geographicElement').each_with_index do |xIn, index|
         hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
         hDictionary = @@nameSpace.unpack(xIn, hResponse)

         assert_equal([warnings[index]], hResponse[:readerExecutionMessages])
         assert_equal(false, hResponse[:readerExecutionPass])
      end
   end
end
