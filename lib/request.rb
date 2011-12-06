require 'net/http'
require 'uri'
require 'forwardable'

class Request
  extend Forwardable
  def_delegators :@uri, :request_uri, :hostname, :port

  def initialize(url)
    @uri = URI(url)
  end

  def get
    req = Net::HTTP::Get.new(request_uri)
    req['Accept'] = 'application/xml'

    Net::HTTP.start(hostname, port) {|http| http.request(req) }.body
  end
end
