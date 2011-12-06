require 'uri'
require 'net/http'
require 'nokogiri'

class Room
  def initialize(uri)
    @uri = uri
    @uri = xml_extract_href('start')
  end

  def go(uri)
    @uri = uri
  end

  def can_go?(direction)
    xml_extract_href(direction)
  end

  def finished?
    xml_has_completed?
  end

  private

  def xml_current
    Request.new(@uri).get
  end

  def xml_extract_href(rel)
    doc = Nokogiri::XML(xml_current)

    node = doc.xpath("//link[@rel=\"#{rel}\"]").first
    return nil unless node
    node[:href] #uuuuuuuuugh
  end

  def xml_has_completed?
    Nokogiri::XML(xml_current).xpath("//completed").first
  end
end

class Request
  def initialize(url)
    @uri = URI(url)
  end

  def get
    req = Net::HTTP::Get.new(@uri.request_uri)
    req['Accept'] = "application/xml"

    res = Net::HTTP.start(@uri.hostname, @uri.port) {|http|
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

