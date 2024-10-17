# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_resource_info

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_resource_info'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152ResourceInformation < TestReaderIso191152Parent
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::ResourceInformation

   def test_resource_info_complete
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:MD_DataIdentification')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      refute_empty hDictionary[:citation]
      assert hDictionary[:citation].instance_of? Hash
      assert_equal('abstract', hDictionary[:abstract])
   end

   def test_no_citation
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_no_cit_dataid.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:MD_DataIdentification')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      _hDictionary = @@nameSpace.unpack(xIn, hResponse)

      assert_equal(["WARNING: ISO19115-2 reader: element 'gmd:citation' is missing in MD_DataIdentification"],
                   hResponse[:readerExecutionMessages])
      assert_equal(false, hResponse[:readerExecutionPass])
   end

   def test_no_abstract
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_no_abstract_dataid.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:MD_DataIdentification')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      _hDictionary = @@nameSpace.unpack(xIn, hResponse)

      expected = "WARNING: ISO19115-2 reader: element 'gmd:abstract//gco:CharacterString'"\
      ' is missing in MD_DataIdentification'
      assert_equal([expected],
                   hResponse[:readerExecutionMessages])
      assert_equal(false, hResponse[:readerExecutionPass])
   end
end
