# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_legal_constraint

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_legal_constraint'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153LegalConstraint < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::LegalConstraint

   def test_legal_constraint_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mcc:imageConstraints')[1]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash

      assert_equal(%w[topSecret otherRestrictions], hDictionary[:accessCodes])
      assert_equal(['otherRestrictions'], hDictionary[:useCodes])
      assert_equal(['No condition applies'], hDictionary[:otherCons])
   end
end
