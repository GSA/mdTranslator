# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_maintenance

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_maintenance'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovMaintenance < TestReaderIso191152datagovParent
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::Maintenance

  def test_maintenance_complete
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:metadataMaintenance')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert_equal('monthly', hDictionary[:frequency])
  end

  def test_maintenance_no_frequency
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_frequency.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:metadataMaintenance')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    expected = ['WARNING: ISO19115-2 reader: element ' \
    "'gmd:maintenanceAndUpdateFrequency' is missing in MD_MaintenanceInformation"]

    assert_equal(expected,
                 hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_no_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_maintenance_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:metadataMaintenance')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    warnings = [
      "WARNING: ISO19115-2 reader: element 'maintenanceAndUpdateFrequency' is missing " \
      "valid nil reason within 'MD_MaintenanceInformation'"
    ]

    assert_equal(warnings, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_yes_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_maintenance_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:metadataMaintenance')[1]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    infos = [
      "INFO: ISO19115-2 reader: element 'maintenanceAndUpdateFrequency' contains " \
      "acceptable nilReason: 'test:uripath'"
    ]

    assert_equal(infos, hResponse[:readerValidationMessages])
    assert_equal(true, hResponse[:readerValidationPass])
  end
end
