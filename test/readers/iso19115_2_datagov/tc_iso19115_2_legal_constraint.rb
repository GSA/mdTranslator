# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_legal_constraint

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_legal_constraint'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovLegalConstraint < TestReaderIso191152datagovParent
   @@xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::LegalConstraint

   def test_legal_constraint_complete
      TestReaderIso191152datagovParent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//gmd:resourceConstraints')[0]
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
