require 'minitest/autorun'
require 'json'
require 'adiwg-mdtranslator'
require_relative 'dcat_us_test_parent'

class TestWriterDcatUsDistribution < TestWriterDcatUsParent
  # get input JSON for test
  @@jsonIn = TestWriterDcatUsParent.getJson('distribution.json')

  def test_distribution
    metadata = ADIWG::Mdtranslator.translate(
      file: @@jsonIn, reader: 'mdJson', validate: 'normal',
      writer: 'dcat_us', showAllTags: false
    )

    hJsonOut = JSON.parse(metadata[:writerOutput])
    got = hJsonOut['distribution']

    expect = [
      { '@type' => 'dcat:Distribution', 'description' => 'distribution online resource description',
        'downloadURL' => 'http://ISO.uri/adiwg/0', 'mediaType' => 'placeholder/value' },
      { '@type' => 'dcat:Distribution', 'downloadURL' => 'http://ISO.uri/adiwg/1',
        'mediaType' => 'placeholder/value' },
      { '@type' => 'dcat:Distribution', 'description' => 'distribution description',
        'downloadURL' => 'http://ISO.uri/adiwg/3', 'mediaType' => 'placeholder/value' }
    ]

    assert_equal expect, got
  end
end
