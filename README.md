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

## Development
### Debugger
- [IRB](https://github.com/ruby/irb) comes with your ruby installation and can be used to debug
- insert a "breakpoint" by adding `binding.irb` on the line of your choice. here's an example of what that might look like...
```console 
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

### Requirements

Requires
- [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
- bundler (`gem install bundler`)
- rake (`gem install rake`)

### Tests

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
