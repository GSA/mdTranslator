# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_citation

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_citation'
require_relative 'iso19115_2_test_parent'
require 'debug'

class TestReaderIso191152Citation < TestReaderIso191152Parent
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::Citation

   def test_citation_complete
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:citation')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal('ISO19115-2 citation title test 123456', hDictionary[:title])
   end

   def test_no_citation_title
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_no_cit_title.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:citation')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      _hDictionary = @@nameSpace.unpack(xIn, hResponse)

      assert_equal(["WARNING: ISO19115-2 reader: element 'gmd:CI_Citation' is missing in 'citation'"],
                   hResponse[:readerExecutionMessages])
      assert_equal(false, hResponse[:readerExecutionPass])
   end
end
