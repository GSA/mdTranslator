[![Build Status](https://travis-ci.org/adiwg/mdTranslator.svg?branch=master)](https://travis-ci.org/adiwg/mdTranslator)
[![Gem Version](https://badge.fury.io/rb/adiwg-mdtranslator.svg)](http://badge.fury.io/rb/adiwg-mdtranslator)

# mdTranslator

**mdtranslator** was written by the [Alaska Data Integration Working Group](http://www.adiwg.org) (ADIwg) to assist researchers with authoring both spatial and non-spatial metadata for projects and datasets.  Input to the mdtranslator is a JSON record conforming to the [mdJson-schemas](http://mdTools.adiwg.org).  The user can request the mdTranslator to translate the mdJson input into one or more established metadata standards.  The mdTranslator currently supports translation to ISO 19115-2, ISO 19110, HTML, and mdJson 2x.  The mdTranslator part of an open source architecture toolkit that allows developers to write additional readers and/or writers as may be required.

## Installation

Add this line to your application's Gemfile:

    gem 'adiwg-mdtranslator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install adiwg-mdtranslator

## CLI Usage

    $ bundle exec mdtranslator help translate

## ISO19115-3 Reader Work
### Introduction
- we want to create an ISO19115-3 reader because we process ISO19115-3 files and want to convert them into DCAT. There's already an ISO19115-3 writer so we're basically looking for the inverse of that. What does the inverse look like? To understand that first let's check out the information flow of the program as a whole:
  1) read/parse the input file ( e.g. fgdc, mdJson, sbJson, iso19115_3 )
  2) store the input file data in the internal md object
  3) write the internal md object into the output file
- the "inverse" we're looking for is step 3 to step 2 or xml into the md internal object which ends up actually being step 1 to step 2.
### Git Workflow
- [ISO19115-3 feature branch](https://github.com/GSA/mdTranslator/tree/feature/iso19115_3-reader)
- all work is branched off and merged into ^ this branch. 
- the ISO19115-3 feature branch would be merged into `datagov` when finished.
### Feature Development
- units of work are typically going to be some xml complex element found in an ISO19115-3 document which will be expressed as a ruby module. 
- let's take `cit:CI_Address` as an example....
   ```xml
   <!-- ... -->
   <cit:CI_Address>
      <!-- look below for deliveryPoint -->
      <cit:deliveryPoint>
         <gco:CharacterString>4210 University Drive</gco:CharacterString>
      </cit:deliveryPoint>
      <cit:deliveryPoint>
         <gco:CharacterString>1234 Example Drive</gco:CharacterString>
      </cit:deliveryPoint>
      <!-- look above for deliveryPoint -->
      <cit:city>
         <gco:CharacterString>Anchorage</gco:CharacterString>
      </cit:city>
      <cit:administrativeArea>
         <gco:CharacterString>AK</gco:CharacterString>
      </cit:administrativeArea>
      <cit:postalCode>
         <gco:CharacterString>99508</gco:CharacterString>
      </cit:postalCode>
      <cit:country>
         <gco:CharacterString>USA</gco:CharacterString>
      </cit:country>
   </cit:CI_Address>
   <!-- ... -->
   ```
- the idea is to create a ruby file called `module_address.rb` in our [modules folder](lib/adiwg/mdtranslator/readers/iso19115_3/modules) which is responsible for processing `cit:CI_Address` elements regardless of the context. In other words, wherever `cit:CI_Address` can occur `module_address.rb` should be able to process it by accepting its immediate parent element.
- first, go to the associated [address writer file](lib/adiwg/mdtranslator/writers/iso19115_3/classes/class_address.rb) and see how the internal md object is written to the output xml. Let's use `deliveryPoints` as an example. 
   ```ruby
   # ...
   # address - delivery points []
   aDeliveryPoints = hAddress[:deliveryPoints]
   aDeliveryPoints.each do |myPoint|
      @xml.tag!('cit:deliveryPoint') do
         @xml.tag!('gco:CharacterString', myPoint)
      end
   end
   # ... 
   ```
- looking back at the example `cit:CI_Address` above you can see what the data is supposed to look like when written. 
- so `hAddress[:deliveryPoints]` should look like `['4210 University Drive', '1234 Example Drive']`
- you want to store data according to the associated object found in [internal object file](lib/adiwg/mdtranslator/internal/internal_metadata_obj.rb)
- in this case, what you're looking for is...
   ```ruby
   def newAddress
         {
            addressTypes: [],
            description: nil,
            deliveryPoints: [],
            city: nil,
            adminArea: nil,
            postalCode: nil,
            country: nil
         }
   end
   ```
- sometimes there's information in the internal object (in this case `newAddress`) which doesn't need to be processed. so you'll need to check the writer out for more info. in this case, `addressTypes` and `description` aren't processed.
- additionally, you may need to reference the schema documents for more info. you can find them [here](https://github.com/ISO-TC211/XML/tree/master/schemas.isotc211.org/19115/-3) which may lead you to finding out that you need more data in your fixture/example for processing. 
- here's what the template of the ruby file should look like when you're ready to begin...

   ```ruby
   require 'nokogiri' # xml lib
   require 'adiwg/mdtranslator/internal/internal_metadata_obj' # internal object lib

   module ADIWG
      module Mdtranslator
         module Readers
            module Iso191153
               module Address
                  # i've been adding xpath class vars here
                  def self.unpack(xParentElem, hResponseObj):
                     # xParentElem is the parent element cit:CI_Address resides under.
                     # hResponseObj is basically a logging object for communicating warnings, info, and errors to the end user during processing.
                     
                     intMetadataClass = InternalMetadata.new
                     hAddress = intMetadataClass.newAddress

                     # fill out your address data...
                  end
               end
            end
         end
      end
   end
   ```

### Feature Development (testing)
- modules/elements are responsible for checking exact values for their root-level keys. 
- assertions on container keys which point to a `hash` or `array` should simply check whether the container is empty or the size of the container. let the module/element that container represents handle its own contents.

## Development
### Debugger
1. [debug](https://github.com/ruby/debug) comes with ruby installations >= 3.1. this is a proper debugger with more features than IRB. 

#### Steps to get 'debug' wired up:

- Uncomment / add `require 'debug'` in bin/mdtranslator to run debugger
- Add a breakpoint anywhere in the code via `binding.b`
- Assign your test file to a variable in the CLI: 
```bash
    export f=test/readers/iso19115_2/testData/iso19115-2.xml
```
- Invoke MDTranslator with the following command:

```bash
   bundle exec mdtranslator translate $f -r iso19115_2 -w dcat_us
```

Note: to debug a test, you want to add `require 'debug'` to `vendor/ruby/3.2.0/gems/rake-13.2.1/lib/rake/rake_test_loader.rb`, prior to invoking `bundle exec rake test TEST={path to test file}`

2. [IRB](https://github.com/ruby/irb) comes with your ruby installation and can be used to "debug"
- insert a "breakpoint" by adding `binding.irb` on the line of your choice. here's an example of what that might look like...

```
From: /home/bobsmith/.rbenv/versions/3.2.2/lib/ruby/vendor_ruby/gems/3.2.0/gems/adiwg-mdtranslator-2.20.0.pre.beta.5/lib/adiwg/mdtranslator/writers/dcat_us/sections/dcat_us_contact_point.rb @ line 10 :

     5:       module Writers
     6:          module Dcat_us
     7:             module ContactPoint
     8: 
     9:                def self.build(intObj)
 => 10:                   binding.irb
    11:                   resourceInfo = intObj[:metadata][:resourceInfo]
    12:                   pointOfContact = resourceInfo[:pointOfContacts][0]
    13:                   contactId = pointOfContact[:parties][0][:contactId]
    14: 
    15:                   contact = Dcat_us.get_contact_by_id(contactId)

irb(ADIWG::Mdtranslator::Writers:...):001> # execute your expressions here...
```

## Requirements

Requires
- [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
- bundler (`gem install bundler`)
- rake (`gem install rake`)

## Tests

In order to run the tests, first install the dependencies

    $ bundle install

Then, run the rake command

    $ bundle exec rake

_TODO: There are currently 4 tests that are not passing, related to mdJSON readers and writers_

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mdTranslator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Data.gov specific notes
For our purposes, we are building a spec compliant reader first and then cloning that reader and making changes to that `ISO19115-2-datagov` reader so that documents which have been marked valid historically by our harvester are passed so long as there is not a good reason to fail them. 

To that end, we have settled up this workflow:

- Create test documents in `testData` folders that are spec compliant
- Run a secondary translation test against this document `test/datagov/WIP__office-of-coast-survey-wrecks-and-obstructions-database.xml` via the command: `bundle exec mdtranslator translate $f -r iso19115_2 -w dcat_us` where `$f` is equal to the above file
- Comment out failing lines
- Add lines to XML to allow spec compliant reader to pass

(as an example)
   ```
   <gmd:date>
      <gmd:CI_Date>
         <gmd:date>
         <gco:Date>2014-06-01</gco:Date>
         </gmd:date>
         <gmd:dateType>
         <gmd:CI_DateTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#CI_DateTypeCode" codeListValue="publication">publication</gmd:CI_DateTypeCode>
         </gmd:dateType>
      </gmd:CI_Date>
   </gmd:date>                  
   <!-- <gmd:date gco:nilReason="inapplicable" /> -->
   ```
- Once we begin work on the sibling reader we will begin to back out those changes and slowly make our document pass
