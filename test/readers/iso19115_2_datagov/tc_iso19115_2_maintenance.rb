# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_maintenance

require 'adiwg/mdtranslator/readers/iso19115_2/modules/module_maintenance'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovMaintenance < TestReaderIso191152datagovParent
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::Maintenance

   def test_maintenance_complete
      xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
      TestReaderIso191152datagovParent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:metadataMaintenance')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary
      assert_equal('monthly', hDictionary[:frequency])
   end

   def test_maintenance_no_frequency
      xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_frequency.xml')
      TestReaderIso191152datagovParent.set_xdoc(xDoc)

      xIn = xDoc.xpath('.//gmd:metadataMaintenance')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      _hDictionary = @@nameSpace.unpack(xIn, hResponse)

      assert_equal(["WARNING: ISO19115-2 reader: element 'gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode' is missing in MD_MaintenanceInformation"],
                   hResponse[:readerExecutionMessages])
      assert_equal(false, hResponse[:readerExecutionPass])
   end
end
