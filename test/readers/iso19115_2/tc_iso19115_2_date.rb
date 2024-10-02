# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_date

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_date'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152Date < TestReaderIso191152Parent
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152::Date

   def test_date_complete
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:date')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal(DateTime.iso8601('2017-01-01T00:00:00+00:00'), hDictionary[:date])
      assert_equal('Y', hDictionary[:dateResolution])
      assert_equal('publication', hDictionary[:dateType])
   end

   def test_no_ci_date
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_no_cit_ci_date.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:date')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      _hDictionary = @@nameSpace.unpack(xIn, hResponse)

      assert_equal(["WARNING: ISO19115-2 reader: element 'gmd:CI_Date' is missing in 'date'"],
                   hResponse[:readerExecutionMessages])
      # TODO: assert true b/c we commented out readerExecutionPass
      # https://github.com/GSA/mdTranslator/blob/iso19115-2-to-dcatus-landingpage/lib/adiwg/mdtranslator/readers/iso19115_2/modules/module_date.rb#L30
      assert_equal(true, hResponse[:readerExecutionPass])
   end

   def test_no_date_date
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_no_date_date.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:date')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      _hDictionary = @@nameSpace.unpack(xIn, hResponse)

      assert_equal(["WARNING: ISO19115-3 reader: element 'gmd:CI_Date' is missing a date element"],
                   hResponse[:readerExecutionMessages])
      assert_equal(false, hResponse[:readerExecutionPass])
   end

   def test_no_date_datetype
      xDoc = TestReaderIso191152Parent.get_xml('iso19115-2_no_date_datetype.xml')
      TestReaderIso191152Parent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:date')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      _hDictionary = @@nameSpace.unpack(xIn, hResponse)

      assert_equal(["WARNING: ISO19115-3 reader: element 'gmd:dateType//gmd:CI_DateTypeCode' is missing in gmd:CI_Date"],
                   hResponse[:readerExecutionMessages])
      assert_equal(false, hResponse[:readerExecutionPass])
   end
end
