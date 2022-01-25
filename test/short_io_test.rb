require "test_helper"

class ShortIoTest < Minitest::Test
  SHORT_IO_BASE_URL       = 'https://api.short.io/domains/'
  DEFAULT_HOST_NAME       = 'example.com'
  DEFAULT_API_KEY         = 'API_KEY'
  SECOND_EXAMPLE_DOMAIN   = 'example-2.com'
  SECOND_EXAMPLE_API_KEY  = 'API_KEY_2'

  def test_that_it_has_latest_version_number
    assert_match ::ShortIo::VERSION, '0.1.7'
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

  def create_new_short_url(host_name=DEFAULT_HOST_NAME, api_key=DEFAULT_API_KEY, options={})
    ::ShortIo::ShortUrl.new(host_name, api_key, options)
  end

  def default_initialize(host_name=DEFAULT_HOST_NAME, api_key=DEFAULT_API_KEY, options={})
    short_url = create_new_short_url(host_name, api_key, options)
    assert_equal short_url.instance_variable_get('@api_key'), api_key
    assert_equal short_url.instance_variable_get('@hide_referer'), options.key?(:hide_referer) ? options[:hide_referer] : false
    assert_equal short_url.instance_variable_get('@host_name'), host_name
    assert_equal short_url.instance_variable_get('@https_link'), options.key?(:https_link) ? options[:https_link] : false
    assert_equal short_url.instance_variable_get('@link_type'), options.key?(:link_type) ? options[:link_type] : 'random'
    assert_equal short_url.instance_variable_get('@short_io_base_url'), SHORT_IO_BASE_URL
  end
end
