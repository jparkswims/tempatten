function [tmax, B, cost, X] = glm_optim(Y,window,locs,dec_type,tmax_type,B_type,tm0,b0)

Y(1:-window(1)+1) = [];

if strcmp(tmax_type,'tmax_param')
    x0 = [tm0 b0];
elseif strcmp(tmax_type,'tmax_fixed')
    x0 = b0;
    tmax = 930;
end
% x0 = [930 ones(1,length(locs)+1)]; %intial params
if strcmp(B_type,'positive')
    lb = zeros(1,length(x0)); %lower bounds

    f = @(x)glm_cost(x,Y,window,locs,dec_type,tmax_type);

    [x, cost] = fmincon(f,x0,[],[],[],[],lb);
    
elseif strcmp(B_type,'unbounded')
    lb = ones(1,length(x0)) .* -inf;
    
    f = @(x)glm_cost(x,Y,window,locs,dec_type,tmax_type);
    
    [x, cost] = fmincon(f,x0,[],[],[],[],lb);
end

if strcmp(tmax_type,'tmax_param')
    tmax = x(1);
    B = x(2:end);
elseif strcmp(tmax_type,'tmax_fixed')
    B = x;
end

X = glm_comps(window,locs,dec_type,tmax,B);

% figure
% hold on
% plot(X,'r')
% plot(Y)