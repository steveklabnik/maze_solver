require 'uri'
require 'net/http'
require 'nokogiri'
require 'forwardable'

$:.unshift("lib")

require 'maze'
require 'xml'
require 'request'

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

