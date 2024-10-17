# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_locale

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_locale'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152Locale < TestReaderIso191152Parent
   @@xDoc = TestReaderIso191152Parent.get_xml('iso19115-2.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::Locale

   def test_default_locale_complete
      TestReaderIso191152Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('gmi:MI_Metadata//gmd:locale')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal('eng', hDictionary[:languageCode])
   end

end
