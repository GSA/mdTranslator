# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_associated_resource

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_associated_resource'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153AssociatedResource < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::AssociatedResource

   def test_associated_resource_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mri:associatedResource')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal('collectiveTitle', hDictionary[:associationType])
      assert_equal('collection', hDictionary[:initiativeType])
      refute_empty hDictionary[:resourceCitation]
      assert hDictionary[:resourceCitation].instance_of? Hash
   end
end
