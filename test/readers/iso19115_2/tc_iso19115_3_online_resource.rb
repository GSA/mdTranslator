# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_online_resource

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_online_resource'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152OnlineResource < TestReaderIso191152Parent
   @@xDoc = TestReaderIso191152Parent.get_xml('iso19115-2.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::OnlineResource

   def test_online_resource_complete
      TestReaderIso191152Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('//gmd:MD_DataIdentification//gmd:CI_Citation//gmd:onlineResource')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      onlineResource = @@nameSpace.unpack(xIn, hResponse)
      refute_empty onlineResource
      assert onlineResource.instance_of? Hash

      assert_equal('https://online_resource_url.gov', onlineResource[:olResURI])
      assert_equal('online resource name', onlineResource[:olResName])
      assert_equal('online resource description', onlineResource[:olResDesc])
      assert_equal('information', onlineResource[:olResFunction])
      assert_equal('online resource application profile', onlineResource[:olResApplicationProfile])
      assert_equal('WWW:LINK-1.0-http--link', onlineResource[:olResProtocol])
      assert_equal('online resource protocol request', onlineResource[:olResProtocolRequest])
   end
end
