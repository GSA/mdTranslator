# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_online_resource

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_online_resource'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153OnlineResource < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::OnlineResource

   def test_online_resource_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//cit:CI_Contact//cit:onlineResource')[1]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      onlineResource = @@nameSpace.unpack(xIn, hResponse)

      refute_empty onlineResource
      assert onlineResource.instance_of? Hash

      assert_equal('http://onlineresourceexample.com', onlineResource[:olResURI])
      assert_equal('online resource name', onlineResource[:olResName])
      assert_equal('online resource description', onlineResource[:olResDesc])
      assert_equal('online information about the resource', onlineResource[:olResFunction])
      assert_equal('application-profile-example', onlineResource[:olResApplicationProfile])
      assert_equal('http', onlineResource[:olResProtocol])
      assert_equal('protocol request example', onlineResource[:olResProtocolRequest])
   end
end
