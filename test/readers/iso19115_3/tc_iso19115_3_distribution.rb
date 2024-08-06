# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_distribution

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_distribution'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Distribution < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Distribution

   def test_distribution_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mdb:distributionInfo')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal('distribution description', hDictionary[:description])
      assert hDictionary[:distributor].instance_of? Array
      assert_equal(1, hDictionary[:distributor].size)
   end
end
