# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_time_period

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_time_period'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152TimePeriod < TestReaderIso191152Parent
   @@xDoc = TestReaderIso191152Parent.get_xml('iso19115-2.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::TimePeriod

   def test_time_period_complete
      TestReaderIso191152Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//gml:TimePeriod')[0]

      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert_equal('timePeriod_001', hDictionary[:timeId])
      assert_equal({ dateTime: '2017-12-01T00:00:00+00:00', dateResolution: 'YMDhms' },
                   hDictionary[:startDateTime])
      assert_equal({ dateTime: 'unknown', dateResolution: 'indeterminate' },
                   hDictionary[:endDateTime])
   end
end
