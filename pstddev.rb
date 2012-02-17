module Enumerable

    def sum
      self.inject(0){|accum, i| accum + i }
    end

    def mean
      self.sum/self.length.to_f
    end

    def sample_variance
      m = self.mean
      sum = self.inject(0){|accum, i| accum +(i-m)**2 }
      sum/(self.length - 1).to_f
    end

    def standard_deviation
      return Math.sqrt(self.sample_variance)
    end

end

lines = IO.readlines("paragraphs.html")
depths = []
for line in lines
  idx = line.index "<p>"
  next if idx.nil?
  depths.push idx/2 - 2
end
p depths.standard_deviation