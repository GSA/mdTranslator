# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_geographic_desc

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_geographic_desc'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153GeographicDescription < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::GeographicDescription

   def test_geographic_desc_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//gex:geographicElement')[1]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal('Australia', hDictionary[:identifier])
   end
end
