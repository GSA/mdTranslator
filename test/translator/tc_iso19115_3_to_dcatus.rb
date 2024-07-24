# MdTranslator - minitest of
# adiwg / mdtranslator / mdReaders / fgdc_reader

# History:
#   Stan Smith 2017-08-14 original script

require 'minitest/autorun'
require 'nokogiri'
require 'adiwg/mdtranslator'
require 'debug'
require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_iso19115_3'
require 'adiwg/mdtranslator/writers/dcat_us/sections/dcat_us_access_level'

class TestIso191153DcatusTranslation < Minitest::Test
   @@hResponseObj = {
      readerExecutionPass: true,
      readerExecutionMessages: []
   }
   def test_access_level_translate
      file = File.join(File.dirname(__FILE__), 'testData', 'iso19115-3.xml')
      xml = Nokogiri::XML(File.read(file))

      xIn = xml.xpath('mdb:MD_Metadata')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))

      metadataNs = ADIWG::Mdtranslator::Readers::Iso191153::Iso191153
      intMetadata = metadataNs.unpack(xIn, hResponse)

      accessLevelNS = ADIWG::Mdtranslator::Writers::Dcat_us::AccessLevel
      sAccessLevel = accessLevelNS.build(intMetadata)

      assert_equal('non-public', sAccessLevel)
   end
end
