require 'uri'
require 'net/http'
require 'nokogiri'

url = "http://amundsen.com/examples/mazes/2d/five-by-five/"

def request_xml(url)
  uri = URI(url)

  req = Net::HTTP::Get.new(uri.request_uri)
  req['Accept'] = "application/xml"

  res = Net::HTTP.start(uri.hostname, uri.port) {|http|
    http.request(req)
  }

  res.body
end

xml = request_xml('http://amundsen.com/examples/mazes/2d/five-by-five/')
doc = Nokogiri::XML(xml)

href = doc.xpath('//link[@rel="start"]').first[:href]

puts href

