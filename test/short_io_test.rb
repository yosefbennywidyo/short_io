require "test_helper"

class ShortIoTest < Minitest::Test
  SHORT_IO_BASE_URL       = 'https://api.short.io/domains/'
  DEFAULT_HOST_NAME       = 'example.com'
  DEFAULT_API_KEY         = 'API_KEY'
  SECOND_EXAMPLE_DOMAIN   = 'example-2.com'
  SECOND_EXAMPLE_API_KEY  = 'API_KEY_2'
  SUCCESS_ADD_DOMAIN      = "{
    linkType: 'random',
    state: 'configured',
    cloaking: false,
    setupType: 'dns',
    httpsLinks: false,
    id: 91576,
    hostname: 'yourdomain.com',
    UserId: 9346,
    updatedAt: '2020-04-23T10:22:47.010Z',
    createdAt: '2020-04-23T10:22:46.649Z',
    provider: null,
    unicodeHostname: 'urdomain.com',
    clientStorage: null
  }"
  SUCCESS_DOMAIN_LIST      = "{
    id: 7252,
    hostname: 'yrbrand.co',
    title: null,
    segmentKey: null,
    linkType: 'increment',
    state: 'not_configured',
    provider: 'cloudflare',
    redirect404: 'https://short.cm',
    hideReferer: 1,
    caseSensitive: true,
    exportEnabled: true,
    cloaking: false,
    jsRedir: true,
    incrementCounter: 'A',
    setupType: 'js',
    autodeletePeriod: 1,
    httpsLinks: true,
    clientStorage: '{'configurationHidden':false}',
    integrationGA: null,
    integrationFB: null,
    integrationAdroll: null,
    integrationGTM: null,
    createdAt: '2017-12-07T08:24:41.000Z',
    updatedAt: '2019-12-24T13:08:30.000Z',
    TeamId: 1381,
    unicodeHostname: 'yrbrand.co'
  }"

  def test_that_it_has_latest_version_number
    assert_match ::ShortIo::VERSION, '0.1.9'
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

  def test_it_add_domain
    success_add_domain
    create_new_short_url(DEFAULT_HOST_NAME, DEFAULT_API_KEY)
    @short_url.add_domain
    assert_equal @short_url.add_domain, SUCCESS_ADD_DOMAIN
  end

  def success_add_domain
    stub_request(:post, "https://api.short.io/domains/").
      with(
        body: "{\"hideReferer\":\"false\",\"httpsLinks\":\"false\",\"hostname\":\"example.com\",\"linkType\":\"random\"}",
        headers: {
              'Accept'=>'application/json',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization'=>'API_KEY',
              'Content-Type'=>'application/json',
              'Host'=>'api.short.io',
              'User-Agent'=>'Ruby'
        }).
          to_return(status: 200, body: SUCCESS_ADD_DOMAIN, headers: {})
  end

  def test_it_domain_list
    success_domain_list
    create_new_short_url(DEFAULT_HOST_NAME, DEFAULT_API_KEY)
    @short_url.domain_list
    assert_equal @short_url.domain_list, SUCCESS_DOMAIN_LIST
  end

  def success_domain_list
    stub_request(:get, "https://api.short.io/domains/").
      with(
        headers: {
              'Accept'=>'application/json',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization'=>'API_KEY',
              'Content-Type'=>'application/json',
              'Host'=>'api.short.io',
              'User-Agent'=>'Ruby'
        }).
          to_return(status: 200, body: SUCCESS_DOMAIN_LIST, headers: {})
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
