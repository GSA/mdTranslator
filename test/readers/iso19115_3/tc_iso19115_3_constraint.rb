# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_constraint

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_constraint'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Constraint < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Constraint
   # TODO: revisit constraints
   def test_constraint_is_common
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mcc:imageConstraints')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      assert_equal('use', hDictionary[:type])
   end
end
