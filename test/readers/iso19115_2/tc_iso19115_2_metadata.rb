# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_metadata

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_metadata'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152Metadata < TestReaderIso191152Parent
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::Metadata

   def test_metadata_complete
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2.xml')

      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('gmi:MI_Metadata')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      refute_empty hDictionary[:resourceInfo]
      assert hDictionary[:resourceInfo].instance_of? Hash
   end

   def test_missing_id_info
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_no_idinfo.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('gmi:MI_Metadata')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      _hDictionary = @@nameSpace.unpack(xIn, hResponse)

      assert_equal(["ERROR: ISO19115-2 reader: element 'gmd:identificationInfo' is missing in MI_Metadata"],
                   hResponse[:readerExecutionMessages])
      assert_equal(false, hResponse[:readerExecutionPass])
   end

   def test_missing_data_id
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_no_dataid.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('gmi:MI_Metadata')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      _hDictionary = @@nameSpace.unpack(xIn, hResponse)

      assert_equal(["ERROR: ISO19115-2 reader: element 'gmd:MD_DataIdentification' is missing in identificationInfo"],
                   hResponse[:readerExecutionMessages])
      assert_equal(false, hResponse[:readerExecutionPass])
   end
end
