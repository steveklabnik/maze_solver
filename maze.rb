require 'uri'
require 'net/http'
require 'nokogiri'

class Room
  def initialize(uri)
    @uri = uri
    @uri = extract_href_from_xml('start')
  end

  def go(uri)
    @uri = uri
  end

  def can_go?(direction)
    extract_href_from_xml(direction)
  end

  def finished?
    xml_has_completed?
  end

  private

  def current_xml
    Request.new(@uri).get
  end

  def extract_href_from_xml(rel)
    doc = Nokogiri::XML(current_xml)

    node = doc.xpath("//link[@rel=\"#{rel}\"]").first
    return nil unless node
    node[:href] #uuuuuuuuugh
  end


  def xml_has_completed?
    Nokogiri::XML(current_xml).xpath("//completed").first
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

