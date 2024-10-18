# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_online_resource

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_online_resource'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovOnlineResource < TestReaderIso191152datagovParent
   @@xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_onlineResource.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::OnlineResource

   def test_online_resource_complete
      TestReaderIso191152datagovParent.set_xdoc(@@xDoc)

      # first resource
      xIn = @@xDoc.xpath('.//gmd:onlineResource')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      onlineResource = @@nameSpace.unpack(xIn, hResponse)
      refute_empty onlineResource
      assert onlineResource.instance_of? Hash

      assert_equal('http://online.adiwg.org/1', onlineResource[:olResURI])
      assert_equal('online resource name', onlineResource[:olResName])
      assert_equal('online resource description', onlineResource[:olResDesc])
      assert_equal('online resource function', onlineResource[:olResFunction])
      assert_equal('application profile', onlineResource[:olResApplicationProfile])
      assert_equal('protocol', onlineResource[:olResProtocol])

      # second resource
      xIn = @@xDoc.xpath('.//gmd:onlineResource')[1]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      onlineResource = @@nameSpace.unpack(xIn, hResponse)
      refute_empty onlineResource
      assert onlineResource.instance_of? Hash

      assert_equal('http://online.adiwg.org/1', onlineResource[:olResURI])
      assert_nil(onlineResource[:olResName])
      assert_nil(onlineResource[:olResDesc])
      assert_nil(onlineResource[:olResFunction])
      assert_nil(onlineResource[:olResApplicationProfile])
      assert_nil(onlineResource[:olResProtocol])
   end
end
