# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_citation

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_citation'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Citation < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Citation

   def test_citation_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('mdb:MD_Metadata')
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary

      assert_equal('U.S. Geological Survey ScienceBase parent identifier', hDictionary[:title])
      refute_empty hDictionary[:identifiers]

      assert_equal('USGS ScienceBase Identifier', hDictionary[:description])
   end
end
