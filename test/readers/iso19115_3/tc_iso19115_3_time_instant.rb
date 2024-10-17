# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_time_instant

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_time_instant'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153TimeInstant < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::TimeInstant

   def test_time_instant_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//gml:TimeInstant')[0]

      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert_equal('d5078594e416a1056031', hDictionary[:timeId])
      assert_equal('description of time instant', hDictionary[:description])
      assert_equal('test-identifier', hDictionary[:identifier])
      assert_equal(['time instant name 1', 'time instant name 2'], hDictionary[:instantNames])
      assert_equal({ dateTime: '12:00:00', dateResolution: 'hms' }, hDictionary[:timeInstant])
   end
end
