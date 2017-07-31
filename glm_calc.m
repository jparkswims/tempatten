function [Ycalc, X] = glm_calc(window,B,Blocs,Btypes,tmax,yint,norm)

X = nan(length(B),window(2)+1);

t = window(1):window(2);
n = 10.1;

for i = 1:size(X,1)
    
    h = hpupil(t,n,tmax,Blocs{i}(1),norm);
    h(1:-window(1)) = [];
    
    fh = str2func(['B' Btypes{i}]);
    if strcmp(Btypes{i},'linear')
        x = [Bramp(B(i),Blocs{i}) zeros(1,5000)];
    else
        x = conv(h,fh(B(i),Blocs{i}));
    end

    X(i,:) = x(1:window(2)+1);
    
end

Ycalc = sum(X,1) + yint;