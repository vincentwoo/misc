require 'benchmark'
require 'benchmark/ips'

module Enumerable
  def rails_index_by
    if block_given?
      Hash[map { |elem| [yield(elem), elem] }]
    else
      to_enum(:index_by) { size if respond_to?(:size) }
    end
  end

  def new_index_by
    if block_given?
      hash = {}
      each do |elem|
        hash[yield(elem)] = elem
      end
      hash
    else
      to_enum(:index_by) { size if respond_to?(:size) }
    end
  end
end

arr = (1..100000).to_a.shuffle

Benchmark.ips do |x|
  x.time = 20
  x.warmup = 5

  x.report("rails:")   { arr.rails_index_by &:itself }
  x.report("new:")     { arr.new_index_by   &:itself }

  x.compare!
end
