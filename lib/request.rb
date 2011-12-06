class Request
  extend Forwardable
  def_delegators :@uri, :request_uri, :hostname, :port

  def initialize(url)
    @uri = URI(url)
  end

  def get
    req = Net::HTTP::Get.new(request_uri)
    req['Accept'] = "application/xml"

    res = Net::HTTP.start(hostname, port) {|http|
      http.request(req)
    }

    res.body
  end
end
