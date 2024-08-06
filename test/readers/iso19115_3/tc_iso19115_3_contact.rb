# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_contact

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_contact'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Contact < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Contact

   def test_address_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//cit:contactInfo')[3]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash

      refute_empty hDictionary[:phones]
      assert hDictionary[:phones].instance_of? Array
      assert_equal(1, hDictionary[:phones].size)

      refute_empty hDictionary[:addresses]
      assert hDictionary[:addresses].instance_of? Array
      assert_equal(1, hDictionary[:addresses].size)
      assert_equal(['email@address.com', 'another@address.com'], hDictionary[:eMailList])

      assert_equal('Monday - Friday 8:00am - 5:00pm', hDictionary[:hoursOfService])
      assert_equal('contact by phone', hDictionary[:contactInstructions])
      assert_equal('federal', hDictionary[:contactType])

      refute_empty hDictionary[:onlineResources]
      assert hDictionary[:onlineResources].instance_of? Array
      assert_equal(1, hDictionary[:onlineResources].size)
   end
end
