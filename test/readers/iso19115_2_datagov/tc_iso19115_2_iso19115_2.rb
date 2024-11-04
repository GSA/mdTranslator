# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_iso19115_2'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovIso191152 < TestReaderIso191152datagovParent
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::Iso191152datagov

  # read the ISO 19115-2 file
  @@xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')

  def test_iso191152_complete
    xMetadata = @@xDoc.xpath('gmi:MI_Metadata')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    intObj = @@nameSpace.unpack(xMetadata, hResponse)

    refute_empty intObj
    assert intObj.instance_of? Hash
    refute_empty intObj[:schema]
    assert intObj[:schema].instance_of? Hash
    assert_equal 'iso19115_2', intObj[:schema][:name]
    refute_empty intObj[:metadata]
  end
end
