using LinearAlgebra
#A12.1
A = rand(20,10);
b = rand(20);
#a.1
x_cap_1 = A\b;
println(x_cap_1,"\n");
#a.2
x_cap_2 = inv(A'A)A'b;
println(x_cap_2,"\n");
#a.3
x_cap_3 = pinv(A)b;
println(x_cap_3,"\n");

println("Checking if the vectors are equal or not by printing it. One can see that the vectors are similar upto 13 to 14 decimal places. Thus, they are equivalent.");
#b
function verify(A, b, x_cap, delta)
    return norm(A*(x_cap+delta)-b).^2 > norm(A*x_cap-b).^2
end
delta1 = rand(10);
println(verify(A, b, x_cap_1, delta1));
delta2 = rand(10);
println(verify(A, b, x_cap_1, delta2));
delta3 = rand(10);
println(verify(A, b, x_cap_1, delta3));
delta4 = rand(10);
scaled_delta4 = (delta4.-minimum(delta4))./(maximum(delta4)-minimum(delta4));
println(verify(A, b, x_cap_1, scaled_delta4));

#A12.2
A = rand(100000,100);
b = rand(100000);
@time x_cap = A\b;
@time x_cap = A\b;
@time x_cap = A\b;
@time x_cap = A\b;
@time x_cap = A\b;
@time x_cap = A\b;
@time x_cap = A\b;
#=
2.766416 seconds (2.49 M allocations: 216.166 MiB, 1.83% gc time, 17.91% compilation time)
2.273690 seconds (633 allocations: 77.364 MiB, 1.37% gc time)
2.187377 seconds (633 allocations: 77.364 MiB, 0.11% gc time)
2.186633 seconds (633 allocations: 77.364 MiB, 0.07% gc time)
2.208185 seconds (633 allocations: 77.364 MiB, 0.07% gc time)
2.199118 seconds (633 allocations: 77.364 MiB, 0.04% gc time)
2.195885 seconds (633 allocations: 77.364 MiB, 0.03% gc time)
=#

#A13.3

#b
include("time_series_data.jl")
J_train = zeros(11);
J_test = zeros(11);
for M in 2:12
    N = size(x_train)[1];
    A = toeplitz(x_train,M)[M:N-1,1:M];
    b = x_train[M+1:N];
    beta = A\b;
    J_train[M-1] = (norm(A*beta-b).^2)./(N-M);

    N_test = size(x_test)[1];
    A = toeplitz(x_test,M)[M:N_test-1,1:M];
    J_test[M-1] = (norm(A*beta-b).^2)./(N_test-M);
end
println("Train Losses");
println(J_train);
println("\nTest Losses: ");
println(J_test);
mJ = minimum(J_train);
print("The mimimum value of J [", mJ,"] is at M = ", findall(x->x==mJ,J_train)[1]+1);

# 2 Sample predictors
M = 2;
N = size(x_train)[1];
A_sam1 = rand(N-M);
A_sam1 .= x_train[M:N-1]; #Previous value
J_sam1 = (norm(A_sam1-x_train[M+1:N]).^2)./(N-M);
println("\nSample 1: ", J_sam1);
A_sam2 = rand(N-M); #Extrapolating line
for i in M:N-2
    A_sam2[i] = x_train[i]+(x_train[i]-x_train[i-1]);
end
J_sam2 = (norm(A_sam2-x_train[M+1:N]).^2)./(N-M);
println("\nSample 2: ", J_sam2);