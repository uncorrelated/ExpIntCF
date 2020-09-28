#
# ported to Ruby by @sumim
# https://gist.github.com/sumim/8a80d57a901552b1d2bc36976d215e26
#
require 'matrix'

def _e1_cf(z, n)
  cf = z
  (n..1).step(-1).each{ |i|
    cf = z + (1 + i) / cf
    cf = 1 + i / cf
  }
  Math::E ** -z / (z + 1 / cf)
end

def e1_cf(z, reltol=1e-12)
  (1..1000).each{ |n|
    s = _e1_cf(z, n)
    d = _e1_cf(z, 2 * n)
    return d if (s - d).abs <= (d.abs * reltol) 
  }
  raise RuntimeError "iteration limit exceeded!"
end

def make_matrix(s, e, len)
  Matrix.build(len){ |j, i| 
    x = s + (e - s) / (len - 1) * i
    y = s + (e - s) / (len - 1) * j
    e1_cf(x + y.i)
  }
end

length = 100

# make a matrix, and save it.
start = Time.now
m = make_matrix(0.1, 5, length)
print "elapsed time: #{Time.now - start} seconds"

# save the matrix.
File.open("e1_cf.rb.txt", "w"){ |stream|
  length.times{ |j|
    length.times{ |i|
      stream.printf("%.6f+%.6f\t", m[i, j].real, m[i, j].imaginary)
#      stream.printf("%6d\t", m[i, j])
    }
    stream.print("\n")
  }
}
