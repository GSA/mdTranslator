# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_address

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_address'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Address < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Address

   def test_address_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//cit:CI_Contact')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hArray = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hArray
      assert_equal(2, hArray.size)

      # physical address
      phyAddress = hArray[0]
      refute_empty phyAddress
      assert_equal(2, phyAddress.size)

      physAddress1 = phyAddress[0]
      refute_empty physAddress1
      assert physAddress1.instance_of? Hash
      assert_equal(['4210 University Drive'], physAddress1[:deliveryPoints])
      assert_equal('Anchorage', physAddress1[:city])
      assert_equal('AK', physAddress1[:adminArea])
      assert_equal('99508', physAddress1[:postalCode])
      assert_equal('USA', physAddress1[:country])

      physAddress2 = phyAddress[1]
      refute_empty physAddress2
      assert physAddress2.instance_of? Hash

      # this situation is when there's only an email address so everything else is blank
      expected = { addressTypes: [], description: nil, deliveryPoints: [], city: nil, adminArea: nil,
                   postalCode: nil, country: nil }
      assert_equal(expected, physAddress2)

      # email address
      emailAddress = hArray[1]
      refute_empty emailAddress
      assert_equal(1, emailAddress.size)
      assert_equal(['ascweb@usgs.gov'], emailAddress)
   end
end
