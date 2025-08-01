# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_metadata

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_metadata_info'
require 'date'
require 'adiwg/mdtranslator/internal/module_utils'
require_relative 'iso19115_2_test_parent'

# monkey patch fetch_doc
module AdiwgUtils
  def self.fetch_doc(_url)
    # we're only using this for following element xlink:hrefs
    # so for now just return the same fixture. consider adding an arg
    # for other test cases to return different things
    File.read(File.join(File.dirname(__FILE__), 'testData', 'xlinkhref.xml'))
  end
end

class TestReaderIso191152datagovMetadataInformation < TestReaderIso191152datagovParent
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::MetadataInformation

  def test_metadata_info_complete
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')

    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('gmi:MI_Metadata')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert hDictionary.instance_of? Hash

    assert_equal({ identifier: 'ISO19115-2-ID-123456' }, hDictionary[:metadataIdentifier])
    assert_equal({ identifier: [{ identifier: 'ISO19115-2-ID-123456-parent' }] },
                 hDictionary[:parentMetadata])
    assert_equal(DateTime.new(2023, 6, 23), hDictionary[:metadataDates][0][:date])
    refute_empty hDictionary[:metadataMaintenance]
    refute_empty hDictionary[:defaultMetadataLocale]
  end

  def test_missing_datestamp
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_datestamp.xml')

    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('gmi:MI_Metadata')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    @@nameSpace.unpack(xIn, hResponse)

    expected = ["INFO: ISO19115-2 reader: element 'contact' contains acceptable nilReason: 'unknown'",
                "WARNING: ISO19115-2 reader: element 'gmd:dateStamp' is missing in MI_Metadata"]
    assert_equal(hResponse[:readerValidationMessages], expected)
  end

  def test_valid_nilreason_datestamp
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_datestamp_nilreason.xml')

    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('gmi:MI_Metadata')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    @@nameSpace.unpack(xIn, hResponse)

    expected = ["INFO: ISO19115-2 reader: element 'contact' contains acceptable nilReason: 'unknown'",
                "INFO: ISO19115-2 reader: element 'dateStamp' contains acceptable nilReason: 'unknown'"]
    assert_equal(hResponse[:readerValidationMessages], expected)
  end

  def test_invalid_nilreason_datestamp
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_datestamp_no_nilreason.xml')

    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('gmi:MI_Metadata')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    @@nameSpace.unpack(xIn, hResponse)

    expected = ["INFO: ISO19115-2 reader: element 'contact' contains acceptable nilReason: 'unknown'",
                "WARNING: ISO19115-2 reader: element 'gmd:dateStamp' is missing valid nil reason within 'MI_Metadata'"]
    assert_equal(hResponse[:readerValidationMessages], expected)
  end

  def test_missing_contact
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_metatadata_missing_contact.xml')

    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('gmi:MI_Metadata')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    @@nameSpace.unpack(xIn, hResponse)

    expected = ["WARNING: ISO19115-2 reader: element 'gmd:contact' is missing in MI_Metadata"]
    assert_equal(hResponse[:readerValidationMessages], expected)
  end

  # we don't need a test_valid_nilreason_contact because the above
  # tests assert that works correctly
  def test_invalid_nilreason_contact
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_metatadata_contact_no_nilreason.xml')

    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('gmi:MI_Metadata')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    @@nameSpace.unpack(xIn, hResponse)

    expected = ["WARNING: ISO19115-2 reader: element 'gmd:contact' is missing valid nil reason within 'MI_Metadata'"]
    assert_equal(hResponse[:readerValidationMessages], expected)
  end

  def test_get_contact_xlink_href
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_follow_xlinkhref.xml')

    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('gmi:MI_Metadata')[0]

    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    res = @@nameSpace.unpack(xIn, hResponse)

    expected = [{ roleName: 'custodian',
                  roleExtents: [],
                  parties: [{ contactType: 'organization',
                              contactName: 'xlink href document',
                              organizationMembers: [] }] }]

    # delete generated uuid and index
    res[:metadataContacts][0][:parties][0].delete(:contactId)
    res[:metadataContacts][0][:parties][0].delete(:contactIndex)

    assert_equal(expected, res[:metadataContacts])
  end
end
