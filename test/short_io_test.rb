require "test_helper"

class ShortIoTest < Minitest::Test
  SHORT_IO_BASE_URL       = 'https://api.short.io/domains/'
  DEFAULT_HOST_NAME       = 'example.com'
  DEFAULT_API_KEY         = 'API_KEY'
  SECOND_EXAMPLE_DOMAIN   = 'example-2.com'
  SECOND_EXAMPLE_API_KEY  = 'API_KEY_2'

  def test_that_it_has_latest_version_number
    assert_match ::ShortIo::VERSION, '0.1.8'
  end

  def test_it_initialize_short_url_correctly
    default_initialize
  end

  def test_it_initialize_with_new_host_name
    default_initialize(SECOND_EXAMPLE_DOMAIN)
  end

  def test_it_initialize_with_new_api_key
    default_initialize(DEFAULT_HOST_NAME, SECOND_EXAMPLE_API_KEY)
  end

  def test_it_raise_error_when_nil_host_name
    assert_raises(ShortIo::HostNameError) { create_new_short_url(nil, SECOND_EXAMPLE_API_KEY) }
  end

  def test_it_raise_error_when_empty_host_name
    assert_raises(ShortIo::HostNameError) { create_new_short_url('', SECOND_EXAMPLE_API_KEY) }
  end

  def test_it_raise_error_when_nil_api_key
    assert_raises(ShortIo::ApiKeyError) { create_new_short_url(SECOND_EXAMPLE_DOMAIN, nil) }
  end

  def test_it_raise_error_when_empty_api_key
    assert_raises(ShortIo::ApiKeyError) { create_new_short_url(SECOND_EXAMPLE_DOMAIN, '') }
  end

  def test_it_initialize_with_new_options
    default_initialize(DEFAULT_HOST_NAME, DEFAULT_API_KEY, {hide_referer: true, https_link: true, link_type: 'long'})
  end

  def test_it_setup
    create_new_short_url(DEFAULT_HOST_NAME, DEFAULT_API_KEY)
    @short_url.setup
    @short_url.yield_self.inspect.include? '@url'
    @short_url.yield_self.inspect.include? SHORT_IO_BASE_URL
    @short_url.yield_self.inspect.include? '@http'
    @short_url.yield_self.inspect.include? 'api.short.io:443'
  end

  def create_new_short_url(host_name=DEFAULT_HOST_NAME, api_key=DEFAULT_API_KEY, short_io_base_url=SHORT_IO_BASE_URL, options={})
    @short_url = ::ShortIo::ShortUrl.new(host_name, api_key, options)
  end

  def default_initialize(host_name=DEFAULT_HOST_NAME, api_key=DEFAULT_API_KEY, short_io_base_url=SHORT_IO_BASE_URL, options={})
    create_new_short_url(host_name, api_key, options)
    @short_url.yield_self.inspect.include? '@api_key'
    @short_url.yield_self.inspect.include? "#{api_key}"
    @short_url.yield_self.inspect.include? '@hide_referer'
    @short_url.yield_self.inspect.include? "#{options.key?(:hide_referer) ? options[:hide_referer] : false}"
    @short_url.yield_self.inspect.include? '@host_name'
    @short_url.yield_self.inspect.include? "#{host_name}"
    @short_url.yield_self.inspect.include? '@https_link'
    @short_url.yield_self.inspect.include? "#{options.key?(:https_link) ? options[:https_link] : false}"
    @short_url.yield_self.inspect.include? '@link_type'
    @short_url.yield_self.inspect.include? options.key?(:link_type) ? options[:link_type] : 'random'
    @short_url.yield_self.inspect.include? '@short_io_base_url'
    @short_url.yield_self.inspect.include? SHORT_IO_BASE_URL
  end
end
