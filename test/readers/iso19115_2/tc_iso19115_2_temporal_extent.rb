# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_temporal_extent

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_temporal_extent'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152TemporalExtent < TestReaderIso191152Parent
   @@xDoc = TestReaderIso191152Parent.get_xml('iso19115-2.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::TemporalExtent

   def test_temporal_extent_complete
      TestReaderIso191152Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//gmd:temporalElement')[1]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      refute_empty hDictionary[:timePeriod]
   end
end
