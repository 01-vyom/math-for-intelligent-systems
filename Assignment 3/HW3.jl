#A6.2 Vandermonde matrices in Julia. Write a function that takes a positive integer n 
# and an m-vector t as inputs and generates the corresponding m × n Vandermonde matrix.
using LinearAlgebra
function Vandermonde_generator(n,m)
    v = ones(length(m),n)
    for i in 1:n
        mnew = m.^(i-1)
        for j in 1:length(m)
            v[j,i] = mnew[j]
        end
    end
    display(v)
end
Vandermonde_generator(5,[5,6,7])
Vandermonde_generator(5,[7,8,6])