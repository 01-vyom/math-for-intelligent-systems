# 11.11 Interpolation of rational functions. 
# (Continuation of exercise 8.8.) Find a rational function f(t) = c1 +c2t+c3t2
# 1+d1t+d2t2 that satisfies the following interpolation conditions:
# f(1) = 2, f(2) = 5, f(3) = 9, f(4) = −1, f(5) = −4.
using Plots
using LinearAlgebra
Plots.PlotlyBackend()
A = [1 1 1 1 1;1 2 3 4 5;1 4 9 16 25;-2 -10 -27 4 20;-2 -20 -81 16 100]';
C = [2 5 9 -1 -4]';
B = A\C;
display(B);
f(t) = ((B[1])+(B[2]*t)+(B[3]*t*t))/(1+(B[4]*t)+(B[5]*t*t));
plot(f, 0, 6,label = "Rational Function",xlabel="t",ylabel="f(t)")
scatter!([1,2,3,4,5],[2,5,9,-1,-4],label="Interpolation Points")

# 11.21 Quadrature weights.
# Consider a quadrature problem (see exercise 8.12) with n = 4, with
# points t = (−0.6, −0.2, 0.2, 0.6). We require that the quadrature rule be exact for 
# all polynomials of degree up to d = 3. Set this up as a square system of linear equations 
# in the weight vector. Numerically solve this system to get the weights. 
# Compute the true value and the quadrature estimate, for the specific function f(x) = exp(x).
A = [1 1 1 1; -0.6 -0.2 0.2 0.6; (-0.6)^2 (-0.2)^2 (0.2)^2 (0.6)^2; (-0.6)^3 (-0.2)^3 (0.2)^3 (0.6)^3];
b = [2 0 (2/3) 0]';
W = A\b;
f(x) = exp(x);
alpha_cap = f.([-0.6 -0.2 0.2 0.6])*W;
alpha = exp(1)-exp(-1);
display(W);
display(alpha_cap);
display(alpha);