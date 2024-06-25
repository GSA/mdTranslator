# MdTranslator - minitest of
# readers / iso19115-3 / module_identification

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_identification'
require_relative 'iso19115_3_test_parent'

class TestReaderIso19115_3Identification < TestReaderIso19115_3Parent

   @@xDoc = TestReaderIso19115_3Parent.get_XML('iso19115-3.xml')
   @@NameSpace = ADIWG::Mdtranslator::Readers::Iso19115_3::Identification

   def test_identification_complete

      TestReaderIso19115_3Parent.set_xDoc(@@xDoc)

      xIn = @@xDoc.xpath('mdb:MD_Metadata')
      hResponse = Marshal::load(Marshal.dump(@@hResponseObj))
      hDictionary = @@NameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary

      assert_equal('57d97341e4b090824ffb0e6f',hDictionary[:identifier])
      assert_equal('gov.sciencebase.catalog',hDictionary[:namespace])
      assert_equal('USGS ScienceBase Identifier',hDictionary[:description])

   end

end
