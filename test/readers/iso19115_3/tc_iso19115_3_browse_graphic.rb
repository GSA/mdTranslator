# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_browse_graphic

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_browse_graphic'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153BrowseGraphic < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::BrowseGraphic

   def test_browse_graphic_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//cit:logo')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal('example_data.png', hDictionary[:graphicName])
      assert_equal('description of example.png', hDictionary[:graphicDescription])
      assert_equal('png', hDictionary[:graphicType])
   end
end
