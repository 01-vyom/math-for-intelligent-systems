#5.a
using LinearAlgebra
USV = svd(A);
U_org = USV.U;
S_org = USV.S;
V_org = USV.V;
A = rand(6,3);
N = 100000
q0, r0 = qr(A)
r0[1,1] = abs(r0[1,1])
r0[2,2] = abs(r0[2,2])
r0[3,3] = abs(r0[3,3])
rarr = []
qarr = []
append!(rarr, [r0])
append!(qarr, [q0])
for k in  1:N
    q,r = qr(rarr[k]')
    append!(rarr, [r])
    append!(qarr, [q])
end

z = zeros(3,3)
U = qarr[1]
V = [qarr[2] z; z z]
for k in 3:N+1
    if k%2 == 1
        U *= [qarr[k] z; z z]
    else
        V *= [qarr[k] z; z z]
    end
end
S = rarr[N+1];

println("S value using SVD: ");
println(S_org);
D = Diagonal(S);
S = [D[1,1], D[2,2], D[3,3]]; 
println("S value using QRSVD: ");
println(S);
println();
println("V value by SVD function: ");
println(V_org);
V = V[1:3,1:3];
println("V value by QRSVD function: ");
println(V);
println();
println("U value by SVD function: ");
println(U_org);
U = U[:,1:3];
println("U value by QRSVD function: ");
println(U);
println();