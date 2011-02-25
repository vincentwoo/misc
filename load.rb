=begin
4. An interpreter needs to load a module's dependencies before it can load the module. Likewise, it needs to load a dependency's dependencies before it can load the dependency.

Given the following functions:

1. "deps(M)" returns the list of modules that are dependencies for module M
2. "load-module(M)" attempts to load a module, throwing an error if the module has already been loaded or if the dependencies haven't been loaded yet

Write a function "load(M)" that takes a module as input and loads the module and its dependencies in the right order.
=end

def deps(m)
	case m
	when 'A'
		['B', 'C', 'D']
	when 'B'
		['C']
	when 'C'
		[]
	when 'D'
		['C']
	end
end

def load_module(m)
	puts "loading " + m
end

def load(m)
	stack = [m]
	i = 0
	while i < stack.length
		for dep in deps(stack[i])
			stack.push dep
		end
		i += 1
	end
	stack.reverse.uniq.each {|m| load_module m }
end

load('A')