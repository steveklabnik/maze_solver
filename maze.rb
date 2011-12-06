require 'uri'
require 'net/http'
require 'nokogiri'

class Room
  def initialize(uri)
    @uri = uri
    @uri = extract_href_from_xml('start', current_xml)
  end

  def go(uri)
    @uri = uri

  end

  def can_go?(direction)
    extract_href_from_xml(direction, current_xml)
  end

  def finished?
    xml_has_completed?(current_xml)
  end

  private

  def current_xml
    request_xml(@uri)
  end

  def extract_href_from_xml(rel, xml)
    doc = Nokogiri::XML(xml)

    node = doc.xpath("//link[@rel=\"#{rel}\"]").first
    return nil unless node
    node[:href] #uuuuuuuuugh
  end


  def xml_has_completed?(xml)
    Nokogiri::XML(xml).xpath("//completed").first
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

end


room = Room.new('http://amundsen.com/examples/mazes/2d/five-by-five/')

visited = {}
path = []
steps = 0

until(room.finished?)

  link = ["start", "east", "west", "south", "north", "exit"].collect do |direction|
    room.can_go?(direction)
  end.find {|href| href && !visited[href] }

  if !link
    path.pop
    link = path.pop
  end

  visited[link] = true
  path << link
  room.go(link)

  steps = steps + 1
end

puts "you win in #{steps}!"

