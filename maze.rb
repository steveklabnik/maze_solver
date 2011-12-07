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

def extract_href_from_xml(rel, xml)
  doc = Nokogiri::XML(xml)

  node = doc.xpath("//link[@rel=\"#{rel}\"]").first
  return nil unless node
  node[:href] #uuuuuuuuugh
end

def start_uri
  xml = request_xml('http://amundsen.com/examples/mazes/2d/five-by-five/')
  extract_href_from_xml('start', xml)
end

puts start_uri

