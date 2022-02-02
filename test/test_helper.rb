$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

require "short_io"

require "minitest/autorun"
require "webmock/minitest"