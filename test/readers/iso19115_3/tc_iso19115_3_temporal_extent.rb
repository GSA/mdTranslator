# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_temporal_extent

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_temporal_extent'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153TemporalExtent < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::TemporalExtent

   def test_temporal_extent_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//gex:EX_Extent')[1] # second one is temporal

      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hArray = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hArray
      assert_equal(1, hArray.size)

      extArray = hArray[0]

      refute_empty extArray[:timeInstant]
      refute_empty extArray[:timePeriod]
   end
end
