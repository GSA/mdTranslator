# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_dateTimeFun

require 'minitest/autorun'
require 'adiwg/mdtranslator/internal/module_dateTimeFun'
require 'debug'

class TestDateTimeFun < Minitest::Test
   def test_convert_duration_to_named_group
      tests = [
         ['P1Y2M3DT10H',
          { 'sign' => 'P', 'years' => '1', 'months' => '2', 'days' => '3', 'hours' => '10', 'minutes' => nil,
            'seconds' => nil }],

         ['P1DT12H',
          { 'sign' => 'P', 'years' => nil, 'months' => nil, 'days' => '1', 'hours' => '12', 'minutes' => nil,
            'seconds' => nil }],

         ['hello', nil],

         ['P7Y2M9DT8H45M13S',
          { 'sign' => 'P', 'years' => '7', 'months' => '2', 'days' => '9', 'hours' => '8', 'minutes' => '45',
            'seconds' => '13' }]
      ]

      tests.each do |test|
         assert_equal(test[1], AdiwgDateTimeFun.convertDurationToNamedGroup(test[0]))
      end
   end
end
