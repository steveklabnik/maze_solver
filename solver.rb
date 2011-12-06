$:.unshift("lib")

require 'solver'

solver = Solver.new('http://amundsen.com/examples/mazes/2d/five-by-five/')

solver.next_step until solver.finished?

puts "Solved in #{solver.total_steps}."
