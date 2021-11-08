using Statistics
using LinearAlgebra
using Plots
using MLJ
plotly()
#A14.3
include("iris_flower_data.jl")
include("iris_multiclass_helpers.jl")

D = get_iris_data();
X_train = D[1][1:4,1:100]'
Y_train = D[2][1:100];
X_test = D[1][1:4,101:150]';
Y_test = D[2][101:150];

A =  [ones(100) X_train];

Theta1 = A\((2*(Y_train.==1)).-1); 
Theta2 = A\((2*(Y_train.==2)).-1);
Theta3 = A\((2*(Y_train.==3)).-1);



v1 = Theta1[1,:]
beta1= Theta1[2:end]
v2 = Theta2[1,:]
beta2 = Theta2[2:end]
v3 = Theta3[1,:]
beta3 = Theta2[2:end]
#display(beta2)
#a
#Train errors
display(mean(((X_train * beta1 .+ v1).>0) .!=(Y_train.==1)));
display(mean(((X_train * beta2 .+ v2).>0) .!=(Y_train.==2)));
display(mean(((X_train * beta3 .+ v3).>0) .!=(Y_train.==3)));

#Test errors
display(mean((((X_test * beta1 .+ v1)).>0) .!=(Y_test.==1)));
display(mean((((X_test * beta2 .+ v2)).>0) .!=(Y_test.==2)));
display(mean((((X_test * beta3 .+ v3).>0) .!=(Y_test.==3))));

#confusion_matrix for train and test
display(confusion_matrix(argmax_by_row((A*[Theta1 Theta2 Theta3])), Y_train));
display(confusion_matrix(argmax_by_row(([ones(50) X_test]*[Theta1 Theta2 Theta3])), Y_test));

#A15.2
include("lsq_classifier_data.jl")

#a
A = [ones(size(X)[2]) X'];

Theta = A\y;
v = Theta[1,:]
beta = Theta[2:51];
println("Beta and v (slope) values are : ", beta, v);

y_hat = X' * beta .+ v;
test_y_hat = X_test' * beta .+ v;
println("The error rate on training data is ",(sum(((y_hat).>0) .!=(y.==1)) + sum(((y_hat).<0) .!=(y.==-1)))/size(y)[1]/2);
println("The error rate on testing data is ",(sum(((test_y_hat).>0) .!=(y_test.==1)) + sum(((test_y_hat).<0) .!=(y_test.==-1)))/size(y_test)[1]/2);

#b
regularization_factor =  10 .^ range(-1,4,length = 100);
test_values = []
train_values = []
logvalues = []
for i in regularization_factor
    Theta = inv(transpose(A)*A + i*Matrix{Float64}(I,51,51)) * transpose(A) * y;
    v = Theta[1,:]
    beta = Theta[2:51];
    y_hat = X' * beta .+ v;
    test_y_hat = X_test' * beta .+ v;
    append!(train_values,(sum(((y_hat).>0) .!=(y.==1)) + sum(((y_hat).<0) .!=(y.==-1)))/size(y)[1]/2);
    append!(test_values,(sum(((test_y_hat).>0) .!=(y_test.==1)) + sum(((test_y_hat).<0) .!=(y_test.==-1)))/size(y_test)[1]/2);
    append!(logvalues,log10(i));
end

plot(logvalues, xlabel = "Log Scaled Lambdas", ylabel = "RMS Error", train_values, label = "Train Data")
plot(logvalues, xlabel = "Log Scaled Lambdas", ylabel = "RMS Error", test_values, label = "Test Data")
println("Regularization value at minimum loss value for train data is ", regularization_factor[findmin(train_values)[2]]);

#A15.3
include("price_elasticity.jl")

delta_p = zeros(5,75)
delta_d = zeros(5,75)
for product in 1:5
  delta_p[product,:] = (Prices[product,:].- p_nom[product])./p_nom[product];
  delta_d[product,:] = (Demands[product,:].- d_nom[product])./d_nom[product]; 
end

delta_p_train = delta_p[1:5,1:60];
delta_p_test = delta_p[1:5,61:75];
delta_d_train = delta_d[1:5,1:60];
delta_d_test = delta_d[1:5,61:75];

E_cap = zeros(5,5)

for product in 1:5
  E_cap[product,:] = (delta_d[product,:]\transpose(delta_p))
end

display(E_cap);
display(E);

delta_d_hat = E_cap * delta_p_test
println(rms(E_cap * delta_p_train, delta_d_train));
println(rms(delta_d_hat, delta_d_test));