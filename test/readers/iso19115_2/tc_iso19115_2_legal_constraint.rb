# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_legal_constraint

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_legal_constraint'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152LegalConstraint < TestReaderIso191152Parent
   @@xDoc = TestReaderIso191152Parent.get_xml('iso19115-2.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::LegalConstraint

   def test_legal_constraint_complete
      TestReaderIso191152Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//gmd:MD_LegalConstraints')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal('legal', hDictionary[:type])

      hLegalConstraint = hDictionary[:legalConstraint]
      assert_equal(['access constraint'], hLegalConstraint[:accessCodes])
      assert_equal(['use constraint'], hLegalConstraint[:useCodes])
      assert_equal(['other constraint'], hLegalConstraint[:otherCons])
   end
end
