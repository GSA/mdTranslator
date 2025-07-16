# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_utils

require 'minitest/autorun'
require 'adiwg/mdtranslator/internal/module_utils'
require 'nokogiri'
require 'date'

class TestDateTimeFun < Minitest::Test
  def test_reconcile_hashes
    # input is 2 hashes; expected is 1
    tests = [

      [[{ a: nil, b: false }, { a: 'test', b: 'apple', c: 'desk' }],
       { a: 'test', b: 'apple', c: 'desk' }],

      [[{ a: {}, b: [], c: 'other' }, { a: 'test', b: 'apple' }],
       { a: 'test', b: 'apple', c: 'other' }],

      [[{ a: { z: 'test' }, b: [1] }, { c: 'test' }],
       { a: { z: 'test' }, b: [1], c: 'test' }]

    ]

    tests.each do |test|
      assert_equal(test[1], AdiwgUtils.reconcile_hashes(*test[0]))
    end
  end

  def test_consolidate_iso191152_rparties
    # in practice, the ints are hashes
    tests = [
      [[{ roleName: 'a', parties: [1, 2], roleExtents: [] }, { roleName: 'a', parties: [3, 4], roleExtents: [8] },
        { roleName: 'b', parties: [8], roleExtents: [] }],
       [{ roleName: 'a', parties: [1, 2, 3, 4], roleExtents: [8] },
        { roleName: 'b', parties: [8], roleExtents: [] }]],

      [[{ roleName: 'c', parties: [9, 3], roleExtents: [6, 7] }],
       [{ roleName: 'c', parties: [9, 3], roleExtents: [6, 7] }]],

      [[], []]
    ]

    tests.each do |test|
      assert_equal(test[1], AdiwgUtils.consolidate_iso191152_rparties(test[0]))
    end
  end

  def test_nil_reason_checker
    tests = [
      ['<foo gco:nilReason="inapplicable"></foo>', [true, 'inapplicable']],
      ['<foo gco:nilReason="missing"></foo>', [true, 'missing']],
      ['<foo gco:nilReason="template"></foo>', [true, 'template']],
      ['<foo gco:nilReason="unknown"></foo>', [true, 'unknown']],
      ['<foo gco:nilReason="withheld"></foo>', [true, 'withheld']],
      ['<foo gco:nilReason="unavailable"></foo>', [true, 'unavailable']],
      ['<foo gco:nilReason="other:ab"></foo>', [true, 'other:ab']],
      ['<foo gco:nilReason="https://john.doe@www.example.com:1234"></foo>',
       [true, 'https://john.doe@www.example.com:1234']],
      ['<foo indeterminatePosition="now"></foo>', [true, 'now']],
      ['<foo gco:nilReason="bad value"></foo>', [false, 'bad value']],
      ['<foo></foo>', [false, nil]]
    ]

    tests.each do |test|
      expected = test[1]
      elem = Nokogiri::XML(test[0]).child
      assert_equal(expected, AdiwgUtils.check_nil_reason(elem))
    end
  end

  def test_valid_nil_reason
    responseObj = { readerValidationMessages: [] }
    tests = [
      [
        Nokogiri::XML('<foo gco:nilReason="inapplicable"></foo>').child,
        true,
        Marshal.load(Marshal.dump(responseObj)),
        ["INFO: ISO19115-2 reader: element 'foo' contains acceptable nilReason: 'inapplicable'"]
      ],
      [
        Nokogiri::XML('<foo></foo>').child,
        false,
        Marshal.load(Marshal.dump(responseObj)),
        nil # failed nil check doesn't produce a log
      ]
    ]

    tests.each do |test|
      elem, expected, responseObj = test
      assert_equal(expected, AdiwgUtils.valid_nil_reason(elem, responseObj))
    end
  end

  def test_namespace_configuration
    file = File.join(File.dirname(__FILE__), 'testData', 'tl_2013_72_sldu.shp.xml')
    xDoc = File.open(file) { |f| Nokogiri::XML(f, &:strict) }

    # throws an exception because of misconfigured namespaces
    begin
      xDoc.xpath('gmi:MI_Metadata | gmd:MD_Metadata')
    rescue StandardError => e
      assert_equal('ERROR: Undefined namespace prefix: gmi:MI_Metadata | gmd:MD_Metadata', e.message)
    end

    AdiwgUtils.add_iso19115_namespaces(xDoc) # registers in-place

    # no longer throws an exception because we registered the namespaces
    xDoc.xpath('gmi:MI_Metadata | gmd:MD_Metadata')
    assert true
  end

  def test_empty_string_to_nil
    # these dtypes should cover our bases
    tests = [[10, 10], # floats and ints are Numeric types
             [false, false],
             %w[test test], # text
             [{}, {}],
             [[], []],
             %i[something something], # symbol
             [DateTime.new(2001, 2, 3, 4, 5, 6), DateTime.new(2001, 2, 3, 4, 5, 6)],
             ['', nil]] # this is what we're looking for
    tests.each do |test|
      value, expected = test
      assert_equal(expected, AdiwgUtils.empty_string_to_nil(value))
    end
  end
end
