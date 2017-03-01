function cost = glm_cost2(x,Ymeas,window,B,Blocs,Btypes,Blabels,tmax,yint,modelparams)

t = any(strcmp(modelparams,'tmax'));
l = any(strcmp(modelparams,'locations'));
y = any(strcmp(modelparams,'yint'));
b = any(strcmp(modelparams,'beta'));

if b
    numB = length(Blabels);
    B = x(1:numB);
else
    numB = 0;
end

if l
    ind = find(cellfun('length',regexp(Blabels,'decision')) ~= 1);
    for i = 1:length(ind)
        Blocs{ind(i)} = x(numB+i);
    end
    numL = length(ind);
else
    numL = 0;
end

if y
    yint = x(numB+numL+1);
end

if t
    tmax = x(end);
end

Ycalc = glm_calc(window,B,Blocs,Btypes,tmax,yint);

cost = sum((Ymeas-Ycalc).^2);