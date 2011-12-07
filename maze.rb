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

def xml_has_element?(element, xml)
  doc = Nokogiri::XML(xml)

  node = doc.xpath("//#{element}").first
  node
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

puts "We're going to play a maze game. Pick which direction you'd like to go. Type 'north,' 'south,' 'east,' or 'west' to go in that direction."

current_uri = start_uri

while(true)
  xml = request_xml(current_uri)
  break if xml_has_element?("completed", xml)

  north = extract_href_from_xml('north', xml)
  south = extract_href_from_xml('south', xml)
  east = extract_href_from_xml('east', xml)
  west = extract_href_from_xml('west', xml)
  an_exit = extract_href_from_xml('exit', xml)

  puts ""
  puts "In this room, you can go:"
  puts "north" if north
  puts "south" if south
  puts "east" if east
  puts "west" if west
  puts "exit" if an_exit

  puts ""
  puts "Where do you want to go?"
  direction = gets.chomp

  #wow, this sucks. We could just use a hash instead...
  current_uri = case direction.downcase
    when "north" then north
    when "south" then south
    when "east" then east
    when "west" then west
    when "exit" then an_exit
  end
end

