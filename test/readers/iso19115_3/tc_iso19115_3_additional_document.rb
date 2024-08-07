# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_additional_document

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_additional_document'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153AdditionalDocument < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::AdditionalDocument

   def test_additional_document_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mri:additionalDocumentation')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      refute_empty hDictionary[:citation]
      assert hDictionary[:citation].instance_of? Array
      assert_equal(1, hDictionary[:citation].size)
   end
end
