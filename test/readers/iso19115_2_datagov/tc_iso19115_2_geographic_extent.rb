# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_extent

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_geographic_extent'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovGeographicExtent < TestReaderIso191152datagovParent
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::GeographicExtent

  def test_geographic_extent_complete
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:geographicElement')
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary[:boundingBox]
    assert_equal('true', hDictionary[:containsData])
  end
end
