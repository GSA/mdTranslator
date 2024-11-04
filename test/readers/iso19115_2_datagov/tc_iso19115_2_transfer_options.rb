# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_transfer

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_transfer'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovTransfer < TestReaderIso191152datagovParent
  @@xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_transferOptions.xml')
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::Transfer

  def test_transfer_complete
    TestReaderIso191152datagovParent.set_xdoc(@@xDoc)

    xIn = @@xDoc.xpath('.//gmd:distributorTransferOptions')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert hDictionary.instance_of? Hash
    refute_empty hDictionary[:onlineOptions]
    assert hDictionary[:onlineOptions].instance_of? Array
    assert_equal(1, hDictionary[:onlineOptions].size)
    assert_equal('http://adiwg.org/1', hDictionary.dig(:onlineOptions, 0, :olResURI))
    assert_equal('online resource name', hDictionary.dig(:onlineOptions, 0, :olResName))
    assert_equal('online resource description', hDictionary.dig(:onlineOptions, 0, :olResDesc))
    assert_equal('protocol', hDictionary.dig(:onlineOptions, 0, :olResProtocol))
  end
end
