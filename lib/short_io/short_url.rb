require 'uri'
require 'net/http'
require 'openssl'
require 'json'

module ShortIo
  class ShortUrl
    REQUEST_TYPE      = 'application/json'
    SHORT_IO_BASE_URL = 'https://api.short.io/domains/'
    
    def initialize(host_name = 'example.com', api_key = 'API_KEY', options={})
      @host_name    = host_name
      @api_key      = api_key
      @hide_referer = options.key?(:hide_referer)  ? options[:hide_referer] : false
      @https_link   = options.key?(:https_link)    ? options[:https_link]   : false
      @link_type    = options.key?(:link_type)     ? options[:link_type]    : 'random'
      @short_io_base_url = 'https://api.short.io/domains/'
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
        {"hideReferer":"#{@hide_referer}",
        "httpsLinks":"#{@https_link}",
        "hostname":"#{@host_name}",
        "linkType":"#{@link_type}"}
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