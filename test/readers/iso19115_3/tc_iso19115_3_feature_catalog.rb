# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_feature_catalog

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_feature_catalog'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153FeatureCatalog < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::FeatureCatalog

   def test_feature_catalog_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mdb:contentInfo')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal(false, hDictionary[:includedWithDataset])
      refute_empty hDictionary[:citation]
      assert hDictionary[:citation].instance_of? Hash
   end
end
