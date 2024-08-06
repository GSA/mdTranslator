# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_date

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_date'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Date < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Date

   def test_date_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//cit:date')[6]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal(DateTime.iso8601('2016-09-14T15:56:49+00:00'), hDictionary[:date])
      assert_equal('YMDhmsZ', hDictionary[:dateResolution])
      assert_equal('creation', hDictionary[:dateType])
   end
end
