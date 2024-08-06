# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_order

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_order'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Order < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Order

   def test_order_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mrd:distributionOrderProcess')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert hDictionary.instance_of? Hash
      assert_equal('no charge', hDictionary[:fees])
      assert_equal({ dateTime: DateTime.iso8601('2018-02-05T00:00:00+00:00'), dateResolution: 'YMDhms' },
                   hDictionary[:plannedAvailability])
      assert_equal('ordering instructions', hDictionary[:orderingInstructions])
      assert_equal('one week turnaround', hDictionary[:turnaround])
   end
end
