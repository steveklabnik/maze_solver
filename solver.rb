$:.unshift("lib")

require 'solver'

solver = Solver.new('http://amundsen.com/examples/mazes/2d/five-by-five/')

solver.next_step until(solver.finished?)

puts "you win in #{solver.total_steps}!"
