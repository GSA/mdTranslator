# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_Keyword

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_Keyword'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152Keyword < TestReaderIso191152Parent
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::Keyword

   def test_keyword_complete
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:descriptiveKeywords')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash

      refute_empty hDictionary[:thesaurus]

      expected = [{ keyword: 'biota', keywordId: nil }, { keyword: 'farming', keywordId: nil }]
      assert_equal(expected, hDictionary[:keywords])
   end

   def test_no_keyword_keyword
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_no_keyword_keyword.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:descriptiveKeywords')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      _hDictionary = @@nameSpace.unpack(xIn, hResponse)

      assert_equal(["ERROR: ISO19115-2 reader: element 'gmd:keyword//gco:CharacterString' is missing in MD_Keywords"],
                   hResponse[:readerExecutionMessages])
      assert_equal(false, hResponse[:readerExecutionPass])
   end
end
