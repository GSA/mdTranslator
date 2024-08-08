# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_maintenance

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_maintenance'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Maintenance < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Maintenance

   def test_maintenance_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mdb:metadataMaintenance')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal('bimonthly', hDictionary[:frequency])
   end
end
