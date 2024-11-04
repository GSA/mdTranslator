# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_aggregation_info

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_aggregation_info'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovAggregationInformation < TestReaderIso191152datagovParent
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::AggregationInformation

  def test_aggregation_info_complete
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:aggregationInfo')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert hDictionary.instance_of? Hash
    refute_empty hDictionary[:resourceCitation]
  end
end
