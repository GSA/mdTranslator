# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_security_constraint

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_security_constraint'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152SecurityConstraint < TestReaderIso191152Parent
   @@xDoc = TestReaderIso191152Parent.get_xml('iso19115-2.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::SecurityConstraint

   def test_security_constraint_complete
      TestReaderIso191152Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//gmd:MD_SecurityConstraints')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)
            
      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal('security', hDictionary[:type])

      hSecurityConstraint = hDictionary[:securityConstraint]
      assert_equal('classification', hSecurityConstraint[:classCode])
      assert_equal('user note', hSecurityConstraint[:userNote])
      assert_equal('classification system', hSecurityConstraint[:classSystem])
      assert_equal('handling instructions', hSecurityConstraint[:handling])
   end

   def test_no_sec_const_class
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_no_sec_const_class.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:MD_DataIdentification')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      _hDictionary = @@nameSpace.unpack(xIn, hResponse)

      assert_equal(['WARNING: ISO19115-2 reader: element \'gmd:classification\' '\
                     'is missing in gmd:MD_SecurityConstraints'],
                   hResponse[:readerExecutionMessages])
      assert_equal(false, hResponse[:readerExecutionPass])
   end   
end
