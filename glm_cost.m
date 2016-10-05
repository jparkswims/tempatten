function cost = glm_cost(x,Y,window,locs,dec_type)

tmax = x(1);
B = x(2:end);

X = glm_comps(window,locs,dec_type,tmax,B);

cost = sum((Y-X).^2);

clf
hold on
plot(X,'r')
plot(Y)