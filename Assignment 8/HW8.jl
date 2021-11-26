using LinearAlgebra
#A16.2
# m = 600
# n = 4000
# A = rand(600,4000);
# b = rand(600);
# @time A\b;
# @time A\b;
# @time A\b;
# @time A\b;
# @time A\b;
#  2nm**2 flops

#A16.3
m = 10000
n = 1000
p = 100

A = rand(m,n);
b = rand(m,1);
C = rand(p,n);
d = rand(p,1);

KKT =  [2*A'A C';C zeros(p,p)]\[2*A'b;d];
print("x hat (solution): \n");
display(KKT[1:n,1]);
print("\nLagrange Multiplier: \n");
display(KKT[n+1:n+p,1]);