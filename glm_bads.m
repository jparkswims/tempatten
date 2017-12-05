function [B, Blocs, tmax, yint, cost, Ycalc, Blabels, numparams, sflag] = glm_bads(Ymeas,window,B,Blocs,Blocbounds,Btypes,Blabels,Bbounds,tmax,tmaxbounds,yint,modelparams,norm)

% x ordered as [betas, locations, yint, tmax]

Ymeas(1:-window(1)) = [];

t = any(strcmp(modelparams,'tmax'));
l = any(strcmp(modelparams,'locations'));
y = any(strcmp(modelparams,'yint'));
b = any(strcmp(modelparams,'beta'));

bf = 10;
lf = 1000;
tf = 1000;
yf = 0.1;

lb = [];
plb = [];
ub = [];
pub = [];
x0 = [];

if b
    x0 = B./bf;
    lb = Bbounds(:,1)./bf;
    plb = Bbounds(:,1)./bf/10;
    ub = Bbounds(:,2)./bf;
    pub = Bbounds(:,2)./bf/10;
end

if l
    ind = find(cellfun('length',regexp(Blabels,'decision')) ~= 1);
    for i = 1:length(ind)
        x0 = [x0 (Blocs{ind(i)}./lf)];
        lb = [lb; (Blocbounds(ind(i),1)./lf)];
        plb = [plb; (Blocbounds(ind(i),1)./lf)];
        ub = [ub; (Blocbounds(ind(i),2)./lf)];
        pub = [pub; (Blocbounds(ind(i),2)./lf)];
    end
end

if y
    x0 = [x0 (yint./yf)];
    lb = [lb; -0.1./yf];
    plb = [plb; -0.05./yf];
    ub = [ub; 0.1./yf];
    pub = [pub; 0.05./yf];
end

if t
    x0 = [x0 tmax./tf];
    lb = [lb; (tmaxbounds(1,1)./tf)];
    plb = [plb; 500./tf];
    ub = [ub; (tmaxbounds(1,2)./tf)];
    pub = [pub; (tmaxbounds(1,2)./tf)];
end

ub = ub';
lb = lb';
pub = pub';
plb = plb';

f = @(x)glm_cost2(x,Ymeas,window,B,Blocs,Btypes,Blabels,tmax,yint,modelparams,norm);
NONBCON = @(X) X(:,6) >= X(:,7) | X(:,7) >= X(:,8) | X(:,8) >= X(:,9);

[x0, cost] = bads(f,x0,lb,ub,plb,pub,NONBCON);

if b
    numB = length(B);
    B = x0(1:numB).*bf;
else
    numB = 0;
end
    
if l
    ind = find(cellfun('length',regexp(Blabels,'decision')) ~= 1);
    numL = length(ind);
    for i = 1:numL
%         Blocs{ind(i)} = x0(numB+i);
        temp(i) = x0(numB+i).*lf;
    end
    if ~issorted(temp)
        sflag = true;
    else
        sflag = false;
    end
    [temp,I] = sort(temp);
    Btemp = B;
    for i = 1:numL
        Blocs{ind(i)} = temp(i);
        if b
            B(i) = Btemp(I(i));
        end
    end        
else
    numL = 0;
end

if y
    yint = x0(numB+numL+1).*yf;
end

if t
    tmax = x0(end).*tf;
end

Ycalc = glm_calc(window,B,Blocs,Btypes,tmax,yint,norm);
numparams = length(x0);