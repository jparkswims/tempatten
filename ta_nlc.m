function [C,Ceq] = ta_nlc(X)

C = double(~((X(6) < X(7)) && (X(7) < X(8)) && (X(8) < X(9))));
% if C ~= 0
%     fprintf('Regressory Latency Ordering Violation\n')
% end
Ceq = [];
