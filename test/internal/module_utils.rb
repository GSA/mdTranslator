# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_utils

require 'minitest/autorun'
require 'adiwg/mdtranslator/internal/module_utils'
require 'nokogiri'

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
      ['<foo gco:nilReason="test:uri"></foo>', [true, 'test:uri']],
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
end
