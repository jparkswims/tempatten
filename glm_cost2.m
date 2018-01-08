function cost = glm_cost2(x,Ymeas,window,B,Blocs,Btypes,Blabels,tmax,yint,modelparams,norm)

t = any(strcmp(modelparams,'tmax'));
l = any(strcmp(modelparams,'locations'));
y = any(strcmp(modelparams,'yint'));
b = any(strcmp(modelparams,'beta'));

bf = 10;
lf = 1000;
tf = 1000;
yf = 0.1;

if b
    numB = length(Blabels);
    B = x(1:numB).*bf;
else
    numB = 0;
end

if l
    ind = find(cellfun('length',regexp(Blabels,'decision')) ~= 1);
    for i = 1:length(ind)
        Blocs{ind(i)} = x(numB+i).*lf;
    end
    numL = length(ind);
else
    numL = 0;
end

if y
    yint = x(numB+numL+1).*yf;
end

if t
    tmax = x(end).*tf;
end

Ycalc = glm_calc(window,B,Blocs,Btypes,tmax,yint,norm);

cost = nansum((Ymeas-Ycalc).^2);