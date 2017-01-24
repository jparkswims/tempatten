function output = bic(n,cost,k)

%n = number of data values
%cost = SSresiduals
%k = number of params

output = (n * log(cost/n)) + (k * log(n));