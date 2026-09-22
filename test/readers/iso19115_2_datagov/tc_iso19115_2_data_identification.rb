# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_resource_info

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_data_identification'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovDataIdentification < TestReaderIso191152datagovParent
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::DataIdentification

  def test_resource_info_complete
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:identificationInfo')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert hDictionary.instance_of? Hash
    refute_empty hDictionary[:citation]
    assert hDictionary[:citation].instance_of? Hash
    assert_equal('abstract', hDictionary[:abstract])
  end

  def test_no_citation
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_cit_dataid.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:identificationInfo')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    assert_equal("WARNING: ISO19115-2 reader: element 'gmd:citation' is missing in MD_DataIdentification",
                 hResponse[:readerValidationMessages][0])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_no_abstract
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_no_abstract_dataid.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:identificationInfo')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    expected = "WARNING: ISO19115-2 reader: element 'gmd:abstract'"\
    ' is missing in MD_DataIdentification'
    assert_equal([expected],
                 hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_data_identification_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:identificationInfo')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    warnings = [
      "WARNING: ISO19115-2 reader: element 'citation' is missing valid nil " \
      "reason within 'MD_DataIdentification'",
      "WARNING: ISO19115-2 reader: element 'abstract' is missing valid nil " \
      "reason within 'MD_DataIdentification'"
    ]
    assert_equal(warnings, hResponse[:readerValidationMessages])
    assert_equal(false, hResponse[:readerValidationPass])
  end

  def test_yes_nilreasons
    xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_data_identification_nilreasons.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:identificationInfo')[1]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    _hDictionary = @@nameSpace.unpack(xIn, hResponse)

    infos = [
      "INFO: ISO19115-2 reader: element 'citation' contains acceptable nilReason: 'unavailable'",
      "INFO: ISO19115-2 reader: element 'abstract' contains acceptable nilReason: 'other:ab128e018h'"
    ]

    assert_equal(infos, hResponse[:readerValidationMessages])
    assert_equal(true, hResponse[:readerValidationPass])
  end

  def test_service_identification_parsing
    # Test that srv:SV_ServiceIdentification elements are parsed correctly
    xDoc = TestReaderIso191152datagovParent.get_xml('service_identification_example.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    # Parse identification info
    xIn = xDoc.xpath('.//gmd:identificationInfo')[0]
    refute_nil(xIn, 'identificationInfo element should exist')

    # Create response object
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))

    # Unpack identification - should NOT return nil for service identification
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_nil(hDictionary, 'Service identification should parse successfully')

    # Verify citation was extracted
    refute_nil(hDictionary[:citation], 'Citation should be extracted')
    assert_equal('Test Web Service', hDictionary[:citation][:title])

    # Verify abstract was extracted
    assert_includes(
      hDictionary[:abstract],
      'test web service',
      'Abstract should be extracted'
    )

    # Verify keywords were extracted
    refute_empty(hDictionary[:keywords], 'Keywords should be extracted')
    assert_equal(2, hDictionary[:keywords][0][:keywords].size, 'Should have 2 keywords')

    # Verify validation passed
    assert(hResponse[:readerValidationPass], 'Validation should pass')
  end

  def test_census_tiger_service_real_world
    # Test parsing real Census TIGER/Line REST service metadata
    xDoc = TestReaderIso191152datagovParent.get_xml('census_tiger_service.xml')
    TestReaderIso191152datagovParent.set_xdoc(xDoc)

    xIn = xDoc.xpath('.//gmd:identificationInfo')[0]
    refute_nil(xIn, 'identificationInfo element should exist in Census TIGER file')

    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_nil(hDictionary, 'Census TIGER service identification should parse successfully')

    # Verify real-world metadata was extracted
    refute_nil(hDictionary[:citation], 'Citation should be extracted from Census TIGER')
    refute_empty(hDictionary[:citation][:title], 'Title should not be empty')
    puts "\n  Census TIGER Title: #{hDictionary[:citation][:title]}"

    refute_nil(hDictionary[:abstract], 'Abstract should be extracted')
    refute_empty(hDictionary[:abstract], 'Abstract should not be empty')
    puts "  Abstract length: #{hDictionary[:abstract].length} characters"

    # Verify it's recognized as a service
    assert_includes(
      "#{hDictionary[:citation][:title].downcase} #{hDictionary[:abstract].downcase}",
      'service',
      'Should contain "service" in title or abstract'
    )
  end
end
