# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_feature_catalog_description

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_feature_catalog_description'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovFeatureCatalogDescription < TestReaderIso191152datagovParent
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::FeatureCatalogDescription

  def test_feature_catalog_description_complete
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:contentInfo')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert hDictionary.instance_of? Hash
    refute_empty hDictionary[:citation]

    assert hDictionary[:includedWithDataset]
  end

  def test_no_dataset_included
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_dataset_included.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:contentInfo')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    expected = "WARNING: ISO19115-2 reader: element 'MD_FeatureCatalogueDescription' " \
    'is missing gmd:includedWithDataset'

    assert_equal(expected, hResponse[:readerValidationMessages][0])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_no_feat_catalog_cit
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_feat_catalog_cit.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:contentInfo')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    expected = ["WARNING: ISO19115-2 reader: element 'gmd:featureCatalogueCitation' " \
    'is missing MD_FeatureCatalogueDescription']

    assert_equal(expected, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_no_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_feat_catalog_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:contentInfo')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    warnings = [
      "WARNING: ISO19115-2 reader: element 'includedWithDataset' is missing valid nil " \
      "reason within 'MD_FeatureCatalogueDescription'",
      "WARNING: ISO19115-2 reader: element 'featureCatalogueCitation' is missing valid " \
      "nil reason within 'MD_FeatureCatalogueDescription'"
    ]

    assert_equal(warnings, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_yes_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_feat_catalog_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:contentInfo')[1]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    infos = [
      "INFO: ISO19115-2 reader: element 'includedWithDataset' contains acceptable nilReason: 'unavailable'",
      "INFO: ISO19115-2 reader: element 'featureCatalogueCitation' contains acceptable nilReason: 'missing'"
    ]

    assert_equal(infos, hResponse[:readerValidationMessages])
    assert_equal(true, hResponse[:readerValidationPass])
  end
end
