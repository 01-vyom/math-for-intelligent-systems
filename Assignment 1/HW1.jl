#A1.2
#= a) aTx extracts (is equal to) the 5th entry of the 10-vector x. =#
a = (1:10 .== 5)
x = rand(10)
print(transpose(a)*x,"\n")
#= b) aTx is the weighted average of a 3-vector x, assigning weights 0.3 to the first component, 0.4
to the second, and 0.3 to the third. =#
a = [0.3, 0.4, 0.3]
x = rand(3)
print(transpose(a)*x,"\n")
#= c) aTx (with x a 22-vector)is the sum of xi for i a multiple of 4 , minus the sum of xi for i a
multiple of 7. =#
x = rand(22)
a = zeros(22)
for i in 1:22
    if mod(i,4) == 0
         a[i] = 1
    elseif mod(i,7) == 0
         a[i] = -1
    end
end
print(transpose(a)*x,"\n")
#= d) aTx (with x an 11-vector) is the average of the middle five entries of x, i.e., entries 4 to 8. =#
x = rand(11)
a = zeros(11)
a[convert(Int32,((length(a)-5)//2))+1:convert(Int32,((length(a)+5)//2))] = ones(5)
print(transpose(a)*x/5)
