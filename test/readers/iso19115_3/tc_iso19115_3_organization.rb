# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_organization

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_organization'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Organization < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Organization

   def test_organization_complete # rubocop: disable Metrics/AbcSize
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//cit:party')[1]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal(true, hDictionary[:isOrganization])
      assert_equal('U.S. Geological Survey, Alaska Science Center', hDictionary[:name])

      refute_empty hDictionary[:externalIdentifier]
      assert hDictionary[:externalIdentifier].instance_of? Array
      assert_equal(1, hDictionary[:externalIdentifier].size)

      refute_empty hDictionary[:logos]
      assert hDictionary[:logos].instance_of? Array
      assert_equal(3, hDictionary[:logos].size)

      refute_empty hDictionary[:phones]
      assert hDictionary[:phones].instance_of? Array
      assert_equal(2, hDictionary[:phones].size)

      refute_empty hDictionary[:addresses]
      assert hDictionary[:addresses].instance_of? Array
      assert_equal(2, hDictionary[:addresses].size)

      refute_empty hDictionary[:eMailList]
      assert hDictionary[:eMailList].instance_of? Array
      assert_equal(['ascweb@usgs.gov'], hDictionary[:eMailList])
      assert_equal('federal', hDictionary[:contactType])
   end
end
