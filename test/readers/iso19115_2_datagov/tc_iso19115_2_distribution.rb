# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-2 / module_security_constraint

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_security_constraint'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovDistribution < TestReaderIso191152datagovParent
  @@xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_distribution.xml')
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::Distribution

  def test_distribution
    TestReaderIso191152datagovParent.set_xdoc(@@xDoc)
    # first block
    xIn = @@xDoc.xpath('.//gmd:distributionInfo')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert hDictionary.instance_of? Hash

    # the distributor has 1 distribution along with 1 sibling distribution
    assert_equal(2, hDictionary.dig(:distributor, 0, :transferOptions).size)

    hTransferOptions = hDictionary.dig(:distributor, 0, :transferOptions, 0)
    hOnlineOptions = hTransferOptions.dig(:onlineOptions, 0)
    assert_equal('online resource URL', hOnlineOptions[:olResURI])
    assert_equal('online resource name', hOnlineOptions[:olResName])
    assert_equal('online resource description', hOnlineOptions[:olResDesc])
    assert_equal('download', hOnlineOptions[:olResFunction])
    assert_equal('protocol', hOnlineOptions[:olResProtocol])

    # distribution formats aren't calculated because they need to be
    # determined based on the url not on what's in the metadata

    # second block
    xIn = @@xDoc.xpath('.//gmd:distributionInfo')[1]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert hDictionary.instance_of? Hash
    hTransferOptions = hDictionary.dig(:distributor, 0, :transferOptions)
    assert_equal(0, hTransferOptions.size)
  end

  def test_distribution_no_distributor
    TestReaderIso191152datagovParent.set_xdoc(@@xDoc)
    xIn = @@xDoc.xpath('.//gmd:distributionInfo')[0]

    xIn.xpath('.//gmd:distributor').remove

    # no distributors are present
    assert_equal(xIn.xpath('.//gmd:distributor').size, 0)

    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    # transfer options are still read despite no distributor being present
    # (i.e. a placeholder one is used instead)
    assert_equal(hDictionary[:distributor][0][:transferOptions].size, 1)
  end
end
