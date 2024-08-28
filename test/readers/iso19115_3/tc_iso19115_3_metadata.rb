# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_metadata

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_metadata'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Metadata < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Metadata

   def test_metadata_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('mdb:MD_Metadata')
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      refute_empty hDictionary[:metadataInfo]

      # add more content here over time...
   end
end
