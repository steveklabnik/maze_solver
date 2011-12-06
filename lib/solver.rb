class Solver
  extend Forwardable
  def_delegators :@maze, :finished?

  def initialize(uri)
    @visited = {}
    @path = []
    @steps = 0
    @maze = Maze.new(uri)
  end

  def next_step
    link = ["start", "east", "west", "south", "north", "exit"].collect do |direction|
      @maze.can_go?(direction)
    end.find {|href| href && !@visited[href] }

    if !link
      @path.pop
      link = @path.pop
    end

    @visited[link] = true
    @path << link
    @maze.visit(link)

    @steps = @steps + 1
  end

  def total_steps
    @steps
  end
end
