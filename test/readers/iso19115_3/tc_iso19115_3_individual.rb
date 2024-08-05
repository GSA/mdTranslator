# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_individual

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_individual'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Individual < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Individual

   def test_individual_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//cit:party')[9]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash

      assert_equal(false, hDictionary[:isOrganization])
      assert_equal('Jordan S Read', hDictionary[:name])
      refute_empty hDictionary[:externalIdentifier]
      assert_equal('Civil Engineer', hDictionary[:positionName])
      refute_empty hDictionary[:phones]
      assert_equal(2, hDictionary[:phones].size)
      refute_empty hDictionary[:addresses]
      assert hDictionary[:addresses].instance_of? Array
      assert_equal(3, hDictionary[:addresses].size)
      assert_equal(['jread@usgs.gov'], hDictionary[:eMailList])
      assert_equal('Originator', hDictionary[:contactType])
   end
end
