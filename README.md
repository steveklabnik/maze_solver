# Maze Solver

Primarily, this repository is a hypermedia client for applications that
serve [maze+xml](http://amundsen.com/media-types/maze/).

Secondarily, this repository demonstrates refactoring from a simple procedural
Ruby program to an OO one.

Well, as [much as 'refactoring' is without any tests](http://hamletdarcy.blogspot.com/2009/06/forgotten-refactorings.html),
anyway.

## Running

First of all, I ran this with Ruby 1.9.3. 1.9.2 should work just fine, too.

Secondly, you need some [nokogiri](http://nokogiri.org) to get going, so
`gem install` that right-off.

Finally, just `ruby solver.rb` to solve the maze.

## The procedural version

I started with a simple task: "request some XML with Net::HTTP" and slowly built
up some code. I pulled out some methods, and before you know it, I had a little
procedural maze solver.

You might be intereseted in following from the beginning. If so, check it [here](https://github.com/steveklabnik/maze_solver/tree/beginning)

You can read along with the commits to see how I built it by going [here](https://github.com/steveklabnik/maze_solver/compare/beginning...procedural).

You can see this version [here](https://github.com/steveklabnik/maze_solver/tree/procedural).

## The Refactoring

Commit early, commit often, that's what I always say! I tried to keep the
commits really tiny so you could see my process with each one. The easiest
way to follow along is probably on GitHub, you can see the list of commits
by going [here](https://github.com/steveklabnik/maze_solver/compare/procedural...objectoriented).
Check each one in order, as they build upon each other.

## The OO version

After the Great Refactoring, what's left is a shiny new version with lots of
objects. It happens to all of us eventually... anyway, you can check it
out [here](https://github.com/steveklabnik/maze_solver/tree/objectoriented).

## The Alternate TDD universe

... coming soon...
