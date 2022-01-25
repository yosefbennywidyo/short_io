require "short_io/version"
require "short_io/short_url"

module ShortIo
  class Error < StandardError; end
  class HostNameError < Error; end
  class ApiKeyError < Error; end
  # Your code goes here...
end
