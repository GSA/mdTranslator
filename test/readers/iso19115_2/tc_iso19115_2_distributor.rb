# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_distributor

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_distributor'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152Distributor < TestReaderIso191152Parent
   @@xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_distributor.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::Distributor

   def test_distributor_complete
      TestReaderIso191152Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//gmd:distributor')[1]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      refute_empty hDictionary[:transferOptions]
      assert hDictionary[:transferOptions].instance_of? Array
      assert_equal(1, hDictionary[:transferOptions].size)
      refute_empty hDictionary[:transferOptions][0][:distributionFormats]
      assert hDictionary[:transferOptions][0][:distributionFormats].instance_of? Array
      assert_equal(1, hDictionary[:transferOptions][0][:distributionFormats].size)
      assert hDictionary[:transferOptions][0][:distributionFormats][0][:formatSpecification].instance_of? Hash
      assert_equal('format specification', hDictionary[:transferOptions][0][:distributionFormats][0][:formatSpecification][:title])
   end
end
