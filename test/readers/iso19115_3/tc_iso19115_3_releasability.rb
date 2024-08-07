# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_releasability

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_releasability'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Releasability < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Releasability

   def test_releasability_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mco:releasability')[1]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal(1, hDictionary[:addressee].size)
      assert_equal('statement', hDictionary[:statement])
      assert_equal(%w[topSecret superSecret], hDictionary[:disseminationConstraint])
   end
end
