# MdTranslator - minitest of
# readers / iso19115-3 

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_iso19115_3'
require_relative 'iso19115_3_test_parent'

class TestReaderIso19115_3Iso19115_3 < TestReaderIso19115_3Parent

   @@NameSpace = ADIWG::Mdtranslator::Readers::Iso19115_3::Iso19115_3

   # read the ISO 19115-3 file
   @@xDoc = TestReaderIso19115_3Parent.get_XML('iso19115-3.xml')

   def test_metadata_complete

      hResponse = Marshal::load(Marshal.dump(@@hResponseObj))
      intObj = @@NameSpace.unpack(@@xDoc, hResponse)
            
      refute_empty intObj
      refute_empty intObj[:schema]
      assert_equal 'iso19115_3', intObj[:schema][:name]
      refute_empty intObj[:metadata]

      hMetadata = intObj[:metadata]
      refute_empty hMetadata[:metadataInfo]

      # add more content here over time...

   end

end