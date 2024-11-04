# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_metadata

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_metadata_info'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovMetadataInformation < TestReaderIso191152datagovParent
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::MetadataInformation

  def test_metadata_info_complete
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')

    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('gmi:MI_Metadata')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert hDictionary.instance_of? Hash

    assert_equal({ identifier: 'ISO19115-2-ID-123456' }, hDictionary[:metadataIdentifier])
    assert_equal({ identifier: [{ identifier: 'ISO19115-2-ID-123456-parent' }] },
                 hDictionary[:parentMetadata])
    refute_empty hDictionary[:metadataMaintenance]
    refute_empty hDictionary[:defaultMetadataLocale]
  end
end
