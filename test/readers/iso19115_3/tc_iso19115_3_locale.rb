# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_locale

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_locale'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Locale < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Locale

   def test_citation_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('mdb:MD_Metadata')
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary

      assert_equal('eng', hDictionary[:languageCode])
      assert_equal('USA', hDictionary[:countryCode])
      assert_equal('UTF-8', hDictionary[:characterEncoding])
   end
end
