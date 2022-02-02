require 'uri'
require 'net/http'
require 'openssl'
require 'json'

module ShortIo
  class ShortUrl
    REQUEST_TYPE      = 'application/json'
    SHORT_IO_BASE_URL = 'https://api.short.io/domains/'

    attr_reader :host_name, :api_key, :options
    
    def initialize(host_name, api_key, options={})
      @host_name          ||= host_name
      @api_key            ||= api_key
      @short_io_base_url  ||= SHORT_IO_BASE_URL
      @options            ||= options
      options_default_value
      check_variables
    end

    def options_default_value
      @options = {
        hide_referer: options.key?(:hide_referer) ? options[:hide_referer] : false,
        https_link: options.key?(:https_link) ? options[:https_link] : false,
        link_type: options.key?(:link_type) ? options[:link_type] : 'random'
      }
    end

    def check_variables
      raise ShortIo::HostNameError.new(host_name: 'Please provide a host name') if (@host_name.nil? || @host_name.empty?)
      raise ShortIo::ApiKeyError.new(api_key: 'Please provide an API key') if (@api_key.nil? || @api_key.empty?)
    end

    def setup
      @url = URI(SHORT_IO_BASE_URL)
      @http = Net::HTTP.new(@url.host, @url.port)
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

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
    
    def domain_list
      setup
      request = Net::HTTP::Get.new(@url)
      request["accept"] = REQUEST_TYPE
      request["content-type"] = REQUEST_TYPE
      request["authorization"] = @api_key
      
      response = @http.request(request)
      return response.read_body
    end
  end
end