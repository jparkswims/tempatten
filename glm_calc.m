function [Ycalc, X] = glm_calc(window,B,Blocs,Btypes,tmax,yint)

X = nan(length(B),window(2)+1);

t = window(1):window(2);
n = 10.1;
f = 1/10^27;

for i = 1:size(X,1)
    
    h = hpupil(t,n,tmax,f,Blocs{i}(1));
    h(1:-window(1)) = [];
    
    fh = str2func(['B' Btypes{i}]);
    x = conv(h,fh(B(i),Blocs{i}));

    X(i,:) = x(1:window(2)+1);
    
end

Ycalc = sum(X,1) + yint;