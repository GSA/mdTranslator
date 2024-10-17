# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_iso19115_3'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Iso191153 < TestReaderIso191153Parent
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Iso191153

   # read the ISO 19115-3 file
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')

   def test_metadata_complete
      xMetadata = @@xDoc.xpath('mdb:MD_Metadata')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      intObj = @@nameSpace.unpack(xMetadata, hResponse)

      refute_empty intObj
      refute_empty intObj[:schema]
      assert_equal 'iso19115_3', intObj[:schema][:name]
      refute_empty intObj[:metadata]

      hMetadata = intObj[:metadata]
      refute_empty hMetadata[:metadataInfo]

      # add more content here over time...
   end
end
