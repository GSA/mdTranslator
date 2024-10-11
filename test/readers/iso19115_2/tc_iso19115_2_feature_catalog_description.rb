# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_feature_catalog_description

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_feature_catalog_description'
require_relative 'iso19115_2_test_parent'
require 'debug'

class TestReaderIso191152FeatureCatalogDescription < TestReaderIso191152Parent
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::FeatureCatalogDescription

   def test_feature_catalog_description_complete
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:contentInfo')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      refute_empty hDictionary[:citation]

      assert hDictionary[:includedWithDataset]
   end

   def test_no_dataset_included
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_no_dataset_included.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:contentInfo')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      _hDictionary = @@nameSpace.unpack(xIn, hResponse)

      expected = ["WARNING: ISO19115-2 reader: element 'MD_FeatureCatalogueDescription' " \
      'is missing gmd:includedWithDataset//gco:Boolean']

      assert_equal(expected, hResponse[:readerExecutionMessages])
      assert_equal(false, hResponse[:readerExecutionPass])
   end

   def test_no_feat_catalog_cit
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_no_feat_catalog_cit.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:contentInfo')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      _hDictionary = @@nameSpace.unpack(xIn, hResponse)

      expected = ["WARNING: ISO19115-2 reader: element 'gmd:featureCatalogueCitation' " \
      'is missing MD_FeatureCatalogueDescription']

      assert_equal(expected, hResponse[:readerExecutionMessages])
      assert_equal(false, hResponse[:readerExecutionPass])
   end
end
