function cost = glm_cost(x,Y,window,locs,dec_type,tmax_type,dectime)

if strcmp(tmax_type,'tmax_param')
    tmax = x(1);
    B = x(2:end);
elseif strcmp(tmax_type,'tmax_fixed')
    tmax = 930;
    B = x;
end

X = glm_comps(window,locs,dec_type,tmax,B,dectime);

cost = sum((Y-X).^2);