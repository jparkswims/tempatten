function [tmax, B] = glm_optim(Y,window,locs,dec_type)

x0 = [930 ones(1,length(locs)+1)]; %intial params
lb = zeros(1,length(x0)); %lower bounds

f = @(x)glm_cost(x,Y,window,locs,dec_type);

figure

x = fmincon(f,x0,[],[],[],[],lb);

tmax = x(1);

B = x(2:end);