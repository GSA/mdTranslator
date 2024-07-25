# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_iso19115_3_identification

require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_metadata_info'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153MetadataInformation < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::MetadataInformation

   def test_metadatainfo_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('mdb:MD_Metadata')
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      refute_empty hDictionary[:metadataIdentifier]
      refute_empty hDictionary[:parentMetadata]
      refute_empty hDictionary[:defaultMetadataLocale]
      refute_empty hDictionary[:otherMetadataLocales]

      # add more content here over time...
   end

   def test_no_contact
      xDoc = TestReaderIso191153Parent.get_xml('iso19115-3_no_md_id.xml')
      TestReaderIso191153Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('mdb:MD_Metadata')
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      expectedMsg = 'ERROR: ISO19115-3 reader: element \'mdb:contact\' is missing in mdb:MD_Metadata'
      refute_empty hDictionary
      assert hResponse[:readerExecutionMessages][0] == expectedMsg
   end
end
