function [X, comps] = glm_comps(window,locs,dec_type,tmax,B)

%time series
t = 1:window(2);

%number of boxes in cascade/width parameter
n = 10.1;

%scaling factor
f = 1/10^27;

%generate pupil response function
h = hpupil(t,n,tmax,f);

%zero time series for stick functions
z = zeros(1,window(2));

%comps variable to store glm components
comps = zeros(length(locs)+1,window(2));

for i = 1:length(locs)
    eval(sprintf('x%d = z;',i))
    eval(sprintf('x%d(%d) = B(%d);',i,locs(i)+1,i))
    eval(sprintf('X%d = conv(x%d,h);',i,i))
    eval(sprintf('X%d = X%d(1:window(2));',i,i))
    eval(sprintf('comps(%d,:) = X%d;',i,i))
end

if strcmp(dec_type,'box')
    eval(sprintf('x%d = (1) * B(end) * ones(1,locs(end));',i+1))
elseif strcmp(dec_type,'ramp')
    eval(sprintf('x%d = [0:1/locs(end):1] .* B(end) .* (1/500);',i+1))
elseif strcmp(dec_type,'line')
    eval(sprintf('x%d = [(1:locs(end)).*(1/locs(end)).*(1/20).* B(end) zeros(1,window(2))];',i+1))
elseif strcmp(dec_type,'none')
    eval(sprintf('x%d = zeros(1,window(2));',i+1))
else
    error('Not valid decision type')
end

if strcmp(dec_type,'box') || strcmp(dec_type,'ramp')
    eval(sprintf('X%d = conv(x%d,h);',i+1,i+1))
    eval(sprintf('X%d = X%d(1:window(2));',i+1,i+1))
else
    eval(sprintf('X%d = x%d(1:window(2));',i+1,i+1))
end

eval(sprintf('comps(%d,:) = X%d;',i+1,i+1))

X = sum(comps,1);


    