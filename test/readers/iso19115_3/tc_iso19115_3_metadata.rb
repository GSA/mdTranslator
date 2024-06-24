# MdTranslator - minitest of
# readers / iso19115-3 / module_metadata

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_metadata'
require_relative 'iso19115_3_test_parent'

class TestReaderIso19115_3Metadata < TestReaderIso19115_3Parent

   @@xDoc = TestReaderIso19115_3Parent.get_XML('iso19115-3.xml')
   @@NameSpace = ADIWG::Mdtranslator::Readers::Iso19115_3::Metadata

   def test_metadata_complete

      TestReaderIso19115_3Parent.set_xDoc(@@xDoc)

      xIn = @@xDoc.xpath('mdb:MD_Metadata')
      hResponse = Marshal::load(Marshal.dump(@@hResponseObj))
      hDictionary = @@NameSpace.unpack(xIn, hResponse)
      
      refute_empty hDictionary
      refute_empty hDictionary[:metadataInfo]

      # add more content here over time...

   end

end
