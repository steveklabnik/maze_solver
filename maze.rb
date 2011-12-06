require 'uri'
require 'net/http'
require 'nokogiri'

class Room
  attr_accessor :current_xml

  def initialize(uri)
    @uri = extract_href_from_xml('start', request_xml(uri))
    @current_xml = request_xml(@uri)
  end

  def go(uri)
    @uri = uri
    @current_xml = request_xml(@uri)
  end
end

def request_xml(url)
  uri = URI(url)

  req = Net::HTTP::Get.new(uri.request_uri)
  req['Accept'] = "application/xml"

  res = Net::HTTP.start(uri.hostname, uri.port) {|http|
    http.request(req)
  }

  res.body
end

def xml_has_completed?(xml)
  Nokogiri::XML(xml).xpath("//completed").first
end

def extract_href_from_xml(rel, xml)
  doc = Nokogiri::XML(xml)

  node = doc.xpath("//link[@rel=\"#{rel}\"]").first
  return nil unless node
  node[:href] #uuuuuuuuugh
end

room = Room.new('http://amundsen.com/examples/mazes/2d/five-by-five/')

xml = room.current_xml
visited = {}
path = []
steps = 0

until(xml_has_completed?(xml))

  link = ["start", "east", "west", "south", "north", "exit"].collect do |direction|
    extract_href_from_xml(direction, xml)
  end.find {|href| href && !visited[href] }

  if !link
    path.pop
    link = path.pop
  end

  visited[link] = true
  path << link
  room.go(link)
  xml = room.current_xml

  steps = steps + 1
end

puts "you win in #{steps}!"

