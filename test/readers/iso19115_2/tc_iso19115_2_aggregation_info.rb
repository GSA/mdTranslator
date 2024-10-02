# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_aggregation_info

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_aggregation_info'
require_relative 'iso19115_2_test_parent'
require 'debug'

class TestReaderIso191152AggregationInformation < TestReaderIso191152Parent
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::AggregationInformation

   def test_aggregation_info_complete
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:aggregationInfo')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      refute_empty hDictionary[:resourceCitation]
   end
end
