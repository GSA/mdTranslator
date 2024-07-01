# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_locale

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_locale'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Locale < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Locale

   def test_default_locale_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('mdb:MD_Metadata')
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse, 'default')

      refute_empty hDictionary

      assert hDictionary.instance_of? Hash
      assert_equal('eng', hDictionary[:languageCode])
      assert_equal('USA', hDictionary[:countryCode])
      assert_equal('UTF-8', hDictionary[:characterEncoding])
   end

   def test_other_locale_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('mdb:MD_Metadata')
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hArray = @@nameSpace.unpack(xIn, hResponse, 'other')

      refute_empty hArray
      assert hArray.instance_of? Array
      assert_equal(2, hArray.size)

      hDictionary = hArray[0]
      assert_equal('test_lang_code', hDictionary[:languageCode])
      assert_equal('test_country', hDictionary[:countryCode])
      assert_equal('test_encoding', hDictionary[:characterEncoding])

      hDictionary = hArray[1]
      assert_equal('test_lang_code2', hDictionary[:languageCode])
      assert_equal('test_country2', hDictionary[:countryCode])
      assert_equal('test_encoding2', hDictionary[:characterEncoding])
   end
end
