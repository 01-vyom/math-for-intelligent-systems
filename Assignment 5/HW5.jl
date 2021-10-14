# 11.11 Interpolation of rational functions. 
# (Continuation of exercise 8.8.) Find a rational function f(t) = c1 +c2t+c3t2
# 1+d1t+d2t2 that satisfies the following interpolation conditions:
# f(1) = 2, f(2) = 5, f(3) = 9, f(4) = −1, f(5) = −4.
using Plots
using LinearAlgebra
Plots.PlotlyBackend()
A = [1 1 1 1 1;1 2 3 4 5;1 4 9 16 25;-2 -10 -27 4 20;-2 -20 -81 16 100]';
C = [2 5 9 -1 -4]';
B = inv(A)C;
display(B);
f(t) = ((B[1])+(B[2]*t)+(B[3]*t*t))/(1+(B[4]*t)+(B[5]*t*t));
plot(f, 0, 6,label = "Rational Function",xlabel="t",ylabel="f(t)")
scatter!([1,2,3,4,5],[2,5,9,-1,-4],label="Interpolation Points")