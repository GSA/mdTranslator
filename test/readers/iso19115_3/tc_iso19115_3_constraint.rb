# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_constraint

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_constraint'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Constraint < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Constraint
end
