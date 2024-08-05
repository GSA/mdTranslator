# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_transfer

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_transfer'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Transfer < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Transfer

   def test_transfer_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mrd:distributorTransferOptions')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal('MB', hDictionary[:unitsOfDistribution])
      assert_equal('999', hDictionary[:transferSize])
      refute_empty hDictionary[:onlineOptions]
      assert hDictionary[:onlineOptions].instance_of? Array
      assert_equal(1, hDictionary[:onlineOptions].size)
      refute_empty hDictionary[:distributionFormats]
      assert hDictionary[:distributionFormats].instance_of? Array
      assert_equal(1, hDictionary[:distributionFormats].size)
   end
end
