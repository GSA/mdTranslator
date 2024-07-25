# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_bounding_box

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_bounding_box'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153BoundingBox < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::BoundingBox

   def test_bounding_box_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//gex:geographicElement')[2] # we want the first one
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert_equal(-148.87, hDictionary[:westLongitude])
      assert_equal(-148.35, hDictionary[:eastLongitude])
      assert_equal(63.95, hDictionary[:southLatitude])
      assert_equal(64.24, hDictionary[:northLatitude])
      assert_nil hDictionary[:minimumAltitude]
      assert_nil hDictionary[:maximumAltitude]
      assert_nil hDictionary[:unitsOfAltitude]
   end
end
