# This code solves one of Mike Amundsen's maze+xml mazes: http://amundsen.com/media-types/maze/
#
# The code isn't great. I just wanted to see how easy it'd be. So I built up a little test, extracted
# some stuff into a method... next thing you know I've got a little procedural application.
#
# Backtracking implementation borrowed from https://github.com/caelum/restfulie/blob/master/full-examples/mikemaze/maze_basic.rb because I'm lazy.


require 'uri'
require 'net/http'
require 'nokogiri'

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
  node[:href] #uuuuuuuuugh can't use Hash#fetch because it's not a hash.
end

def start_uri
  xml = request_xml('http://amundsen.com/examples/mazes/2d/five-by-five/')
  extract_href_from_xml('start', xml)
end

xml = request_xml(start_uri)
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
  xml = request_xml(link)

  steps = steps + 1
end

puts "you win in #{steps}!"

