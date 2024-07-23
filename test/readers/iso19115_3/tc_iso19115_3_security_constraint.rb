# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_security_constraint

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_security_constraint'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153SecurityConstraint < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::SecurityConstraint

   def test_security_constraint_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mcc:imageConstraints')[2]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal('unclassified', hDictionary[:classCode])
      assert_equal('user note on image security constraint', hDictionary[:userNote])
      assert_equal('system 1.56A', hDictionary[:classSystem])
      assert_equal('handle with care', hDictionary[:handling])
   end
end
