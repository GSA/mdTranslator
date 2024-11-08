# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_online_resource

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_online_resource'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovOnlineResource < TestReaderIso191152datagovParent
  @@xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_onlineResource.xml')
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::OnlineResource

  def test_online_resource_complete
    TestReaderIso191152datagovParent.set_xdoc(@@xDoc)

    # first resource
    xIn = @@xDoc.xpath('.//gmd:onlineResource')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    onlineResource = @@nameSpace.unpack(xIn, hResponse)
    refute_empty onlineResource
    assert onlineResource.instance_of? Hash

    assert_equal('http://online.adiwg.org/1', onlineResource[:olResURI])
    assert_equal('online resource name', onlineResource[:olResName])
    assert_equal('online resource description', onlineResource[:olResDesc])
    assert_equal('online resource function', onlineResource[:olResFunction])
    assert_equal('application profile', onlineResource[:olResApplicationProfile])
    assert_equal('protocol', onlineResource[:olResProtocol])

    # second resource
    xIn = @@xDoc.xpath('.//gmd:onlineResource')[1]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    onlineResource = @@nameSpace.unpack(xIn, hResponse)
    refute_empty onlineResource
    assert onlineResource.instance_of? Hash

    assert_equal('http://online.adiwg.org/1', onlineResource[:olResURI])
    assert_nil(onlineResource[:olResName])
    assert_nil(onlineResource[:olResDesc])
    assert_nil(onlineResource[:olResFunction])
    assert_nil(onlineResource[:olResApplicationProfile])
    assert_nil(onlineResource[:olResProtocol])
  end

  def test_missing_linkage
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_onlineResource.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:onlineResource')[2]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    assert_equal(["WARNING: ISO19115-2 reader: element 'gmd:linkage' is missing in CI_OnlineResource"],
                 hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_no_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_onlineResource.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:onlineResource')[3]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    warnings = [
      "WARNING: ISO19115-2 reader: element 'linkage' is missing valid nil " \
      "reason within 'CI_OnlineResource'"
    ]

    assert_equal(warnings, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_yes_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_onlineResource.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:onlineResource')[4]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    infos = [
      "INFO: ISO19115-2 reader: element 'linkage' contains acceptable nilReason: 'other:ab'"
    ]

    assert_equal(infos, hResponse[:readerValidationMessages])
    assert_equal(true, hResponse[:readerValidationPass])
  end
end
