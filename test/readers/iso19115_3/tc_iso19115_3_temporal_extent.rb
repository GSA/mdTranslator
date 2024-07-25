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

      xIn = @@xDoc.xpath('.//gex:temporalElement')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      refute_empty hDictionary[:timeInstant]
      refute_empty hDictionary[:timePeriod]
   end
end
