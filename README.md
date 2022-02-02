# ShortIo

[![Gem Version](https://badge.fury.io/rb/short_io.svg)](https://badge.fury.io/rb/short_io) | [![Build Status](https://app.travis-ci.com/yosefbennywidyo/short_io.svg?branch=main)](https://app.travis-ci.com/yosefbennywidyo/short_io) | [![codecov](https://codecov.io/gh/yosefbennywidyo/short_io/branch/main/graph/badge.svg?token=MBMxFB57mZ)](https://codecov.io/gh/yosefbennywidyo/short_io)

A Ruby gem to use with [short.io](https://short.io)

[ShortIo gem documentation](https://rubydoc.info/gems/short_io)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'short_io'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install short_io

## Usage

```ruby
require 'short_io'

ShortIo::ShortUrl.new('kreasi-guna-semesta.co.id', 'API_KEY',)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yosefbennywidyo/short_io. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/yosefbennywidyo/short_io/blob/main/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ShortIoShortBrandedUrl project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/yosefbennywidyo/short_io/blob/main/CODE_OF_CONDUCT.md).
