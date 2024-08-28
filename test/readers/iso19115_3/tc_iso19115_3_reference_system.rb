# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_reference_system

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_reference_system'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153ReferenceSystem < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::ReferenceSystem

   def test_reference_system_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//gex:verticalCRSId')[0] # we want the first one
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal('test', hDictionary[:systemType])

      sysId = hDictionary[:systemIdentifier]

      refute_empty sysId
      assert_equal('WGS 84 (EPSG:4326)', sysId[:identifier])
      assert_equal('EPSG', sysId[:namespace])
      assert_equal('8.6', sysId[:version])
      refute_empty sysId[:citation]
   end
end
