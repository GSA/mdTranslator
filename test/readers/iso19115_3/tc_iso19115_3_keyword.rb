# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_keyword

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_keyword'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Keyword < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Keyword

   def test_keyword_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mri:descriptiveKeywords')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash

      assert_nil(hDictionary[:keywordType])
      refute_empty hDictionary[:thesaurus]
      assert_equal('Theme', hDictionary[:type])

      refute_empty hDictionary[:keywords]
      assert hDictionary[:keywords].instance_of? Array
      expectedKeywords = [{ keyword: 'water', keywordId: nil },
                          { keyword: 'temperate lakes', keywordId: nil },
                          { keyword: 'reservoirs', keywordId: nil },
                          { keyword: 'modeling', keywordId: nil },
                          { keyword: 'climate change', keywordId: nil },
                          { keyword: 'thermal profiles', keywordId: nil }]
      assert_equal(expectedKeywords, hDictionary[:keywords])
   end
end
