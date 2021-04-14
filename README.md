# Carrierwave::Serializable ![Build Status](https://github.com/timfjord/carrierwave-serializable/actions/workflows/test.yml/badge.svg)

Carrierwave plugin that allow mount uploader to serialized field

## Installation

Add this line to your application's Gemfile:

    gem 'carrierwave-serializable'

Or install it yourself as:

    $ gem install carrierwave-serializable

## Usage

To mount an uploader to the serialized field, set the `serialize_to` option
to the serialized field where you want to store the uploader.

```ruby
class User < ActiveRecord::Base
  serialize :documents, Hash
  mount_uploader :document1, DocumentUploader, serialize_to: :documents
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
