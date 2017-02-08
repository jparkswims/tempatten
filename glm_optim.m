function [tmax, B, cost, X] = glm_optim(Y,window,locs,dectime,dec_type,tmax_type,B_type,tm0,b0,loc_type)

Y(1:-window(1)+1) = [];

if strcmp(loc_type,'targets')
    locs = locs(2:end-1);
    b0(end-1) = [];
    b0(1) = [];
end

if strcmp(tmax_type,'tmax_param')
    x0 = [tm0 b0];
elseif strcmp(tmax_type,'tmax_fixed')
    x0 = b0;
    tmax = 930;
end
% x0 = [930 ones(1,length(locs)+1)]; %intial params
if strcmp(B_type,'positive')
    if strcmp(tmax_type,'tmax_param')
        lb = zeros(1,length(x0)); %lower bounds
        ub = [2000 (ones(1,length(x0)-1) .* 100)]; %upper bounds
    elseif strcmp(tmax_type,'tmax_fixed')
        lb = zeros(1,length(x0));
        ub = ones(1,length(x0)) .* 100;
    end

    f = @(x)glm_cost(x,Y,window,locs,dec_type,tmax_type,dectime);

    [x, cost] = fmincon(f,x0,[],[],[],[],lb,ub);
    %try patternsearch, fmincon
    
elseif strcmp(B_type,'unbounded')
    if strcmp(tmax_type,'tmax_param')
        lb = ones(1,length(x0)) .* -100; %lower bounds
        ub = [2000 (ones(1,length(x0)-1) .* 100)]; %upper bounds
    elseif strcmp(tmax_type,'tmax_fixed')
        lb = ones(1,length(x0)) .* -100;
        ub = ones(1,length(x0)) .* 100;
    end 
    
    f = @(x)glm_cost(x,Y,window,locs,dec_type,tmax_type,dectime);
    
    [x, cost] = fmincon(f,x0,[],[],[],[],lb,ub);
    %try patternsearch, fmincon
    
end

if strcmp(tmax_type,'tmax_param')
    tmax = x(1);
    B = x(2:end);
elseif strcmp(tmax_type,'tmax_fixed')
    B = x;
end

X = glm_comps(window,locs,dec_type,tmax,B,dectime);

% figure
% hold on
% plot(X,'r')
% plot(Y)