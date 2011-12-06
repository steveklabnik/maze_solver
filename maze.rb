require 'uri'
require 'net/http'
require 'nokogiri'
require 'forwardable'

class Maze
  def initialize(uri)
    @xml_cache = {}
    @uri = uri
    @uri = xml.href_for('start')
  end

  def visit(uri)
    @uri = uri
  end

  def can_go?(direction)
    xml.href_for(direction)
  end

  def finished?
    xml.has_node?('completed')
  end

  private

  def xml
    @xml_cache[@uri] ||= XML.new(@uri)
  end
end

class XML
  def initialize(uri)
    @uri = uri
  end

  def href_for(rel)
    doc = Nokogiri::XML(self.to_s)

    node = doc.xpath("//link[@rel='#{rel}']").first
    #uuuuuuuuugh, node isn't a hash, or else I'd #fetch
    return nil unless node
    node[:href]
  end

  def has_node?(node)
    Nokogiri::XML(self.to_s).xpath("//#{node}").first
  end

  def to_s
    @request ||= Request.new(@uri).get
  end
end

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

maze = Maze.new('http://amundsen.com/examples/mazes/2d/five-by-five/')

visited = {}
path = []
steps = 0

until(maze.finished?)

  link = ["start", "east", "west", "south", "north", "exit"].collect do |direction|
    maze.can_go?(direction)
  end.find {|href| href && !visited[href] }

  if !link
    path.pop
    link = path.pop
  end

  visited[link] = true
  path << link
  maze.visit(link)

  steps = steps + 1
end

puts "you win in #{steps}!"

