# frozen_string_literal: true

# MdTranslator - minitest of
# parent class for all iso19115-3 tests

require 'minitest/autorun'
require 'rubygems'
require 'nokogiri'
require 'adiwg/mdtranslator'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_iso19115_3'

class TestReaderIso191153Parent < Minitest::Test
   @@hResponseObj = {
      readerExecutionPass: true,
      readerExecutionMessages: [],
      readerStructurePass: true,
      readerStructureMessages: []
   }

   # get iso19115-3 file for testing from test data folder
   def self.get_xml(fileName)
      file = File.join(File.dirname(__FILE__), 'testData', fileName)
      Nokogiri::XML(File.read(file))
   end

   # set xDoc for iso19115-3 methods
   # use when testing modules that read data from other iso19115-3 metadata sections
   # ... pass the additional metadata section data in through xDoc
   def self.set_xdoc(xDoc)
      ADIWG::Mdtranslator::Readers::Iso191153::Iso191153.set_xdoc(xDoc)
   end

   # set intObj for test modules
   # use when tests need to read/write to/from internal object sections other
   # ... than the one created by the test
   def self.set_int_obj(intObj = nil)
      if intObj.nil?
         # create new internal metadata container for the reader
         intMetadataClass = InternalMetadata.new
         intObj = intMetadataClass.newBase
         hMetadata = intMetadataClass.newMetadata
         hMetadataInfo = intMetadataClass.newMetadataInfo
         hResourceInfo = intMetadataClass.newResourceInfo
         hDataQuality = intMetadataClass.newDataQuality
         hMetadata[:metadataInfo] = hMetadataInfo
         hMetadata[:resourceInfo] = hResourceInfo
         hMetadata[:dataQuality] = hDataQuality
         intObj[:metadata] = hMetadata
      end
      ADIWG::Mdtranslator::Readers::Iso191153::Iso191153.set_int_obj(intObj)
      intObj
   end

   # get intObj for assertions of data written to other intObj sections during test
   def self.get_int_obj
      ADIWG::Mdtranslator::Readers::Iso191153::Iso191153.get_int_obj
   end
end
