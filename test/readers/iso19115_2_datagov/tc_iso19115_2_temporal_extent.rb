# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_temporal_extent

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_temporal_extent'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovTemporalExtent < TestReaderIso191152datagovParent
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::TemporalExtent

   def test_temporal_extent_complete
      xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
      TestReaderIso191152datagovParent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:temporalElement')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      refute_empty hDictionary[:timePeriod]
   end

   def test_no_extent
      xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_temporal_extent.xml')
      TestReaderIso191152datagovParent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:temporalElement')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      assert_equal(['ERROR: ISO19115-2 reader: Element gmd:extent is missing in gmd:EX_TemporalExtent'],
                   hResponse[:readerExecutionMessages])
      assert_equal(false, hResponse[:readerExecutionPass])
   end
end
