# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_common_constraint

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_common_constraint'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153CommonConstraint < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::CommonConstraint

   def test_common_constraint_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mco:MD_Constraints')[1]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal('use', hDictionary[:type])
      assert_equal(2, hDictionary[:useLimitation].size)
      expectedLimitations = ['Disclaimer - While every effort has been made to ensure...', 'Other Disclaimer']
      assert_equal(expectedLimitations, hDictionary[:useLimitation])
      refute_empty hDictionary[:scope]

      assert hDictionary[:graphic].instance_of? Array
      assert_equal(1, hDictionary[:graphic].size)

      refute_empty hDictionary[:reference]
      assert hDictionary[:reference].instance_of? Array

      refute_empty hDictionary[:releasability]
      assert hDictionary[:releasability].instance_of? Hash

      refute_empty hDictionary[:responsibleParty]
      assert hDictionary[:responsibleParty].instance_of? Array
      assert_equal(1, hDictionary[:responsibleParty].size)
   end
end
