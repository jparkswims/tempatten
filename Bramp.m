function output = Bramp(B,loc,t)

sf = 1/300;

output = zeros(1,length(t));

istart = find(t==loc(1));
iend = find(t==loc(2));

output(istart:iend) = (0:1/(iend-istart):1) * B * sf;