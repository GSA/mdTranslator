# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_responsibility

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_responsibility'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Responsibility < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Responsibility

   def test_responsibility_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('mdb:MD_Metadata')
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hArray = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hArray
      assert hArray.instance_of? Array
      assert_equal(2, hArray.size)

      responsibility = hArray[0]
      assert_equal('pointOfContact', responsibility[:roleName])

      responsibility = hArray[1]
      assert_equal('author', responsibility[:roleName])

      # add more assertions as more content is complete...
   end
end
