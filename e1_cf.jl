using Printf

function E₁_cf(z::Number, n::Integer)
global c
    cf::typeof(z) = z
    for i = n:-1:1
        cf = z + (1+i)/cf
        cf = 1 + i/cf
    end
    return exp(-z) / (z + inv(cf))
end

function E₁_cf(z::Number, reltol=1e-12)
    for n = 1:1000
        s = E₁_cf(z, n)
        d = E₁_cf(z, 2n)
        if abs(s - d) <= reltol*abs(d)
            return d
        end
    end
    error("iteration limit exceeded!")
end

function MakeMatrix(s::Number, e::Number, length::Integer)
	x = range(s, e, length=length)
	return [E₁_cf(x+y*im) for y in x, x in x]
end

m = @time MakeMatrix(0.1, 5, 100)

fp = open("e1_cf.jl.txt", "w")
for j = 1:100
    for i = 1:100
    	@printf(fp, "%.6f+%.6fim\t", real(m[i,j]), imag(m[i,j]))
    end
    @printf(fp, "\n")
end
close(fp)

