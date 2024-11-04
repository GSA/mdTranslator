# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_use_constraint

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_use_constraint'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovUseConstraint < TestReaderIso191152datagovParent
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::UseConstraint

  def test_use_constraint_complete
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:resourceConstraints')[3]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert hDictionary.instance_of? Hash
    assert_equal('use', hDictionary[:type])
    assert_equal(['use constraint limitation value 123', 'use constraint limitation abc'],
                 hDictionary[:useLimitation])
  end
end
