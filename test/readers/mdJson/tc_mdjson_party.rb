# MdTranslator - minitest of
# reader / mdJson / module_party

# History:
# Stan Smith 2016-10-09 original script

require 'minitest/autorun'
require 'json'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require 'adiwg/mdtranslator/readers/mdJson/modules/module_party'

# set contacts to be used by this test
module ADIWG
    module Mdtranslator
        module Readers
            module MdJson
                module MdJson

                    # create new internal metadata container for the reader
                    intMetadataClass = InternalMetadata.new
                    intObj = intMetadataClass.newBase

                    # first contact
                    intObj[:contacts] << intMetadataClass.newContact
                    intObj[:contacts][0][:contactId] = 'individualId0'
                    intObj[:contacts][0][:isOrganization] = false

                    # second contact
                    intObj[:contacts] << intMetadataClass.newContact
                    intObj[:contacts][1][:contactId] = 'individualId1'
                    intObj[:contacts][1][:isOrganization] = false

                    # third contact
                    intObj[:contacts] << intMetadataClass.newContact
                    intObj[:contacts][2][:contactId] = 'organizationId0'
                    intObj[:contacts][2][:isOrganization] = true

                    @contacts = intObj[:contacts]

                end
            end
        end
    end
end

class TestReaderMdJsonParty < MiniTest::Test

    # set constants and variables
    @@NameSpace = ADIWG::Mdtranslator::Readers::MdJson::Party
    @@responseObj = {
        readerExecutionPass: true,
        readerExecutionMessages: []
    }

    # get json file for tests from examples folder
    file = File.join(File.dirname(__FILE__), 'testData', 'party.json')
    file = File.open(file, 'r')
    jsonFile = file.read
    file.close
    aIn = JSON.parse(jsonFile)

    # the first example is fully populated
    @@aIn = aIn['party']
    def test_individual_roleParty

        hIn = Marshal::load(Marshal.dump(@@aIn[0]))
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_equal 'individualId0', metadata[:contactId]
        assert_equal 0, metadata[:contactIndex]
        assert_equal 'individual', metadata[:contactType]
        assert hResponse[:readerExecutionPass]
        assert_empty hResponse[:readerExecutionMessages]

    end

    def test_organization_roleParty

        hIn = Marshal::load(Marshal.dump(@@aIn[1]))
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_equal 'organizationId0', metadata[:contactId]
        assert_equal 2, metadata[:contactIndex]
        assert_equal 'organization', metadata[:contactType]
        assert_equal 2, metadata[:organizationMembers].length
        assert_equal 'individualId0', metadata[:organizationMembers][0][:contactId]
        assert_equal 0, metadata[:organizationMembers][0][:contactIndex]
        assert_equal 'individual', metadata[:organizationMembers][0][:contactType]
        assert_equal 0, metadata[:organizationMembers][0][:organizationMembers].length
        assert_equal 'individualId1', metadata[:organizationMembers][1][:contactId]
        assert hResponse[:readerExecutionPass]
        assert_empty hResponse[:readerExecutionMessages]

    end

    def test_bad_roleParty_id

        hIn = Marshal::load(Marshal.dump(@@aIn[2]))
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_nil metadata
        refute hResponse[:readerExecutionPass]
        refute_empty hResponse[:readerExecutionMessages]

    end

    def test_bad_organizationMember_id

        hIn = Marshal::load(Marshal.dump(@@aIn[3]))
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_equal 1, metadata[:organizationMembers].length
        assert hResponse[:readerExecutionPass]
        refute_empty hResponse[:readerExecutionMessages]

    end

    def test_empty_roleParty

        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack({}, hResponse)

        assert_nil metadata
        refute hResponse[:readerExecutionPass]
        refute_empty hResponse[:readerExecutionMessages]

    end

end
