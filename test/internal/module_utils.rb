# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_utils

require 'minitest/autorun'
require 'adiwg/mdtranslator/internal/module_utils'

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
end
