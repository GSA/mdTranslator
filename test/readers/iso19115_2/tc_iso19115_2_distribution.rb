# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_security_constraint

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_security_constraint'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152Distribution < TestReaderIso191152Parent
   @@xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_distribution.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::Distribution

   def test_distribution
      TestReaderIso191152Parent.set_xdoc(@@xDoc)
      # first block
      xIn = @@xDoc.xpath('.//gmd:distributionInfo')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash

      hTransferOptions = hDictionary.dig(:distributor, 0, :transferOptions, 0)
      hOnlineOptions = hTransferOptions.dig(:onlineOptions, 0)
      assert_equal('online resource URL', hOnlineOptions[:olResURI])
      assert_equal('online resource name', hOnlineOptions[:olResName])
      assert_equal('online resource description', hOnlineOptions[:olResDesc])
      assert_equal('download', hOnlineOptions[:olResFunction])
      assert_equal('protocol', hOnlineOptions[:olResProtocol])

      hDistributionFormatSpec = hTransferOptions.dig(:distributionFormats, 0, :formatSpecification)
      assert_equal('format specification', hDistributionFormatSpec[:title])

      # second block
      xIn = @@xDoc.xpath('.//gmd:distributionInfo')[1]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      hTransferOptions = hDictionary.dig(:distributor, 0, :transferOptions)
      assert_equal(1, hTransferOptions.length)
      assert_nil(hTransferOptions[0])
      assert_empty(hTransferOptions.compact)
   end

end
