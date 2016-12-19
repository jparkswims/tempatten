function [cost,tmax,B] = model_comp(Y,pa)

%this function computes the R^2 value of different models

tmax = zeros(9,1);
cost = zeros(9,1);
B = zeros(9,5);

%model 1: ramp
tm0 = 930;
b0 = ones(1,length(pa.locs)+1);
[tmax(1), B(1,:), cost(1)] = glm_optim(Y,pa.window,pa.locs,'ramp','tmax_param','positive',tm0,b0);

%model 2: box
tm0 = 930;
b0 = ones(1,length(pa.locs)+1);
[tmax(2), B(2,:), cost(2)] = glm_optim(Y,pa.window,pa.locs,'box','tmax_param','positive',tm0,b0);

%model 3: simple line
tm0 = 930;
b0 = ones(1,length(pa.locs)+1);
[tmax(3), B(3,:), cost(3)] = glm_optim(Y,pa.window,pa.locs,'line','tmax_param','positive',tm0,b0);

%model 4: ramp fixed tmax
tm0 = 930;
b0 = ones(1,length(pa.locs)+1);
[tmax(4), B(4,:), cost(4)] = glm_optim(Y,pa.window,pa.locs,'ramp','tmax_fixed','positive',tm0,b0);

%model 5: box fixed tmax
tm0 = 930;
b0 = ones(1,length(pa.locs)+1);
[tmax(5), B(5,:), cost(5)] = glm_optim(Y,pa.window,pa.locs,'box','tmax_fixed','positive',tm0,b0);

%model 6: simple line fixed tmax
tm0 = 930;
b0 = ones(1,length(pa.locs)+1);
[tmax(6), B(6,:), cost(6)] = glm_optim(Y,pa.window,pa.locs,'line','tmax_fixed','positive',tm0,b0);

%model 7: ramp unbounded B
tm0 = 930;
b0 = ones(1,length(pa.locs)+1);
[tmax(7), B(7,:), cost(7)] = glm_optim(Y,pa.window,pa.locs,'ramp','tmax_param','unbounded',tm0,b0);

%model 8: box unbounded B
tm0 = 930;
b0 = ones(1,length(pa.locs)+1);
[tmax(8), B(8,:), cost(8)] = glm_optim(Y,pa.window,pa.locs,'box','tmax_param','unbounded',tm0,b0);

%model 9: simple line unbounded B
tm0 = 930;
b0 = ones(1,length(pa.locs)+1);
[tmax(9), B(9,:), cost(9)] = glm_optim(Y,pa.window,pa.locs,'line','tmax_param','unbounded',tm0,b0);

%model 10; ramp fixed tmax unbounded B
tm0 = 930;
b0 = ones(1,length(pa.locs)+1);
[tmax(10), B(10,:), cost(10)] = glm_optim(Y,pa.window,pa.locs,'ramp','tmax_fixed','unbounded',tm0,b0);

%model 11; box fixed tmax unbounded B
tm0 = 930;
b0 = ones(1,length(pa.locs)+1);
[tmax(11), B(11,:), cost(11)] = glm_optim(Y,pa.window,pa.locs,'box','tmax_fixed','unbounded',tm0,b0);

%model 12; simple line fixed tmax unbounded B
tm0 = 930;
b0 = ones(1,length(pa.locs)+1);
[tmax(12), B(12,:), cost(12)] = glm_optim(Y,pa.window,pa.locs,'line','tmax_fixed','unbounded',tm0,b0);

% %model 10: no decision
% tm0 = 930;
% b0 = [ones(1,length(pa.locs)) 0]
% [tmax(10), B(10,:), cost(10)] = glm_optim(Y,pa.window,pa.locs,'none','tmax_param','positive',tm0,b0);
