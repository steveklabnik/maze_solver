require 'maze'
require 'forwardable'

class Solver
  DIRECTIONS = ["start", "east", "west", "south", "north", "exit"]

  extend Forwardable
  def_delegators :@maze, :finished?

  attr_accessor :total_steps

  def initialize(uri)
    @visited = {}
    @path = []
    @total_steps = 0
    @maze = Maze.new(uri)
  end

  def next_step
    link = next_unvisited_direction || backtrack

    visit(link)
  end

  private

  def next_unvisited_direction
    possible_directions.find {|href| !@visited[href] }
  end

  def possible_directions
    DIRECTIONS.collect do |direction|
      @maze.can_go?(direction)
    end.compact
  end

  def visit(link)
    @total_steps += 1

    @visited[link] = true
    @path << link

    @maze.visit(link)
  end

  def backtrack
    @path.pop
    @path.pop
  end
end
