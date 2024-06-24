# MdTranslator - minitest of
# readers / iso19115-3 / module_citation

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_citation'
require_relative 'iso19115_3_test_parent'

class TestReaderIso19115_3Citation < TestReaderIso19115_3Parent

    @@xDoc = TestReaderIso19115_3Parent.get_XML('iso19115-3.xml')
    @@NameSpace = ADIWG::Mdtranslator::Readers::Iso19115_3::Citation

   def test_citation_complete

      TestReaderIso19115_3Parent.set_xDoc(@@xDoc)

      xIn = @@xDoc.xpath('mdb:MD_Metadata')
      hResponse = Marshal::load(Marshal.dump(@@hResponseObj))
      hDictionary = @@NameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary

      assert_equal('U.S. Geological Survey ScienceBase parent identifier',hDictionary[:title])
      refute_empty hDictionary[:identifiers] 

      assert_equal('USGS ScienceBase Identifier',hDictionary[:description])
      
   end

end
