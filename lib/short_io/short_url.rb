require 'uri'
require 'net/http'
require 'openssl'
require 'json'

# @author Yosef Benny Widyokarsono
module ShortIo
  # Add domain and list domains registerd to Short.io
  class ShortUrl
    REQUEST_TYPE          = 'application/json'
    SHORT_IO_BASE_URL     = 'https://api.short.io/domains/'
    SHORT_IO_API_BASE_URL = 'https://api.short.io/api/domains'

    attr_reader :host_name, :api_key, :options
    
    def initialize(host_name, api_key, short_io_base_url=SHORT_IO_BASE_URL, options={})
      @host_name          ||= host_name
      @api_key            ||= api_key
      @short_io_base_url  ||= short_io_base_url
      @options            ||= options
      unless options.key?(:domain_id)
        options_default_value
        check_variables
      end
    end

    # Options Default Value
    #
    # @return [Hash] return default options in Hash if no value provided.

    def options_default_value
      @options = {
        hide_referer: options.key?(:hide_referer) ? options[:hide_referer] : false,
        https_link: options.key?(:https_link) ? options[:https_link] : false,
        link_type: options.key?(:link_type) ? options[:link_type] : 'random'
      }
    end

    # Check Variables
    #
    # @raise [HostNameError] if no Host Name provided.
    # @raise [ApiKeyError] if no API Key provided.

    def check_variables
      raise ShortIo::HostNameError.new(host_name: 'Please provide a host name') if (@host_name.nil? || @host_name.empty?)
      raise ShortIo::ApiKeyError.new(api_key: 'Please provide an API key') if (@api_key.nil? || @api_key.empty?)
    end

    # Prepare request

    def setup(action=nil, base_url=SHORT_IO_BASE_URL)
      @url = action.nil? ? URI(base_url) : URI(base_url + action)
      @http = Net::HTTP.new(@url.host, @url.port)
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    # Add new domain
    #
    # @return [JSON] return in JSON format.
    #
    # @example
    #   ShortIo::ShortUrl.new('example.com', 'YOUR_API_KEY').add_domain
    #     {
    #       linkType: 'random',
    #       state: 'configured',
    #       cloaking: false,
    #       setupType: 'dns',
    #       httpsLinks: false,
    #       id: 91576,
    #       hostname: 'yourdomain.com',
    #       UserId: 9346,
    #       updatedAt: '2022-02-03T10:22:47.010Z',
    #       createdAt: '2022-02-03T10:22:46.649Z',
    #       provider: null,
    #       unicodeHostname: 'urdomain.com',
    #       clientStorage: null
    #     }
    #
    # @see https://developers.short.io/docs/adding-a-domain

    def add_domain
      setup

      request = Net::HTTP::Post.new(@url)
      request["accept"] = REQUEST_TYPE
      request["content-type"] = REQUEST_TYPE
      request["authorization"] = @api_key
      request.body = JSON.generate(
        {
          "hideReferer":"#{@options[:hide_referer]}",
          "httpsLinks":"#{@options[:https_link]}",
          "hostname":"#{@host_name}",
          "linkType":"#{@options[:link_type]}"
        }
      )
      response = @http.request(request)
      return response.read_body
    end

    # Delete a domain
    #
    # @return [JSON] return in JSON format.
    #
    # @example
    #   ShortIo::ShortUrl.new('example.com', 'YOUR_API_KEY', {domain_id: YOUR_DOMAIN_ID}).delete_domain
    #     response:
    #     {
    #       success: true
    #     }
    #
    # @see https://developers.short.io/docs/deleting-a-domain

    def delete_domain
      setup("delete/#{@options[:domain_id]}")

      request = Net::HTTP::Post.new(@url)
      request["authorization"] = @api_key

      response = @http.request(request)
      return response.read_body
    end

    # Udpadating a domain
    #
    # @return [JSON] return in JSON format.
    #
    # @example
    #   ShortIo::ShortUrl.new('example.com', 'YOUR_API_KEY', {domain_id: YOUR_DOMAIN_ID, root_redirect_url: 'YOUR_LINK'}).update_domain
    #     response:
    #     {
    #       success: true
    #     }
    #
    # @see https://developers.short.io/docs/updating-a-domain

    def update_domain
      setup("settings/#{@options[:domain_id]}")

      request = Net::HTTP::Post.new(@url)
      request["accept"] = REQUEST_TYPE
      request["content-type"] = REQUEST_TYPE
      request["authorization"] = @api_key
      request.body = JSON.generate({ 'rootRedirect': "#{@options[:root_redirect_url]}" })

      response = @http.request(request)
      return response.read_body
    end

    # Domain List
    #
    # @return [JSON] return domain list in JSON format.
    #
    # @example
    #   ShortIo::ShortUrl.new('example.com', 'YOUR_API_KEY').domain_list
    #     response:
    #     {
    #       id: 7252,
    #      hostname: 'yrbrand.co',
    #      title: null,
    #      segmentKey: null,
    #      linkType: 'increment',
    #      state: 'not_configured',
    #      provider: 'cloudflare',
    #      redirect404: 'https://short.cm',
    #      hideReferer: 1,
    #      caseSensitive: true,
    #      exportEnabled: true,
    #      cloaking: false,
    #      jsRedir: true,
    #      incrementCounter: 'A',
    #      setupType: 'js',
    #      autodeletePeriod: 1,
    #      httpsLinks: true,
    #      clientStorage: '{"configurationHidden":false}',
    #      integrationGA: null,
    #      integrationFB: null,
    #      integrationAdroll: null,
    #      integrationGTM: null,
    #      createdAt: '2017-12-07T08:24:41.000Z',
    #      updatedAt: '2019-12-24T13:08:30.000Z',
    #      TeamId: 1381,
    #      unicodeHostname: 'yrbrand.co'
    #    }
    #
    # @see https://developers.short.io/docs/getting-a-list-of-domains
    
    def domain_list
      setup(nil, SHORT_IO_API_BASE_URL)
      request = Net::HTTP::Get.new(@url)
      request["accept"] = REQUEST_TYPE
      request["authorization"] = @api_key
      
      response = @http.request(request)
      return response.read_body
    end
  end
end