# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_time_period

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_time_period'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153TimePeriod < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::TimePeriod

   def test_time_period_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//gml:TimePeriod')[0]

      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert_equal('d5078594e414a1056030', hDictionary[:timeId])
      assert_equal('time period description', hDictionary[:description])
      assert_equal('time period identifier', hDictionary[:identifier])
      assert_equal(['time period name 1', 'time period name 2'], hDictionary[:periodNames])
      assert_equal({ dateTime: '2000-01-01T00:00:00+00:00', dateResolution: 'YMDhmsZ' },
                   hDictionary[:startDateTime])
      assert_equal({ dateTime: '2000-12-31T00:00:00+00:00', dateResolution: 'YMDhmsZ' },
                   hDictionary[:endDateTime])
      assert_equal({ interval: '1.0', units: 'second' }, hDictionary[:timeInterval])
      assert_equal(
         { 'sign' => 'P', 'years' => '1', 'months' => '2', 'days' => '3', 'hours' => '10', 'minutes' => nil,
           'seconds' => nil }, hDictionary[:duration]
      )
   end
end
