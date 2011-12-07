require 'uri'
require 'net/http'

url = "http://amundsen.com/examples/mazes/2d/five-by-five/"

uri = URI(url)

req = Net::HTTP::Get.new(uri.request_uri)
req['Accept'] = "application/xml"

res = Net::HTTP.start(uri.hostname, uri.port) {|http|
  http.request(req)
}

puts res.body

