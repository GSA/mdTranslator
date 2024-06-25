# MdTranslator - minitest of
# readers / iso19115-3 / module_iso19115_3_identification

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_metadataInfo'
require_relative 'iso19115_3_test_parent'

class TestReaderIso19115_3MetadataInformation < TestReaderIso19115_3Parent

   @@xDoc = TestReaderIso19115_3Parent.get_XML('iso19115-3.xml')
   @@NameSpace = ADIWG::Mdtranslator::Readers::Iso19115_3::MetadataInformation

   def test_metadatainfo_complete

      TestReaderIso19115_3Parent.set_xDoc(@@xDoc)

      xIn = @@xDoc.xpath('mdb:MD_Metadata')
      hResponse = Marshal::load(Marshal.dump(@@hResponseObj))
      hDictionary = @@NameSpace.unpack(xIn, hResponse)
      
      refute_empty hDictionary
      refute_empty hDictionary[:metadataIdentifier]
      refute_empty hDictionary[:parentMetadata]


      # add more content here over time...

   end

end
