function [B, Blocs, tmax, yint, cost, Ycalc, Blabels, numparams, hessian, sflag, exitflag] = glm_optim2(Ymeas,window,B,Blocs,Blocbounds,Btypes,Blabels,Bbounds,tmax,tmaxbounds,yint,modelparams,norm)

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
ub = [];
x0 = [];

if b
    x0 = B./bf;
    lb = Bbounds(:,1)./bf;
    ub = Bbounds(:,2)./bf;
end

if l
    ind = find(cellfun('length',regexp(Blabels,'decision')) ~= 1);
    for i = 1:length(ind)
        x0 = [x0 (Blocs{ind(i)}./lf)];
        lb = [lb; (Blocbounds(ind(i),1)./lf)];
        ub = [ub; (Blocbounds(ind(i),2)./lf)];
    end
end

if y
    x0 = [x0 (yint./yf)];
    lb = [lb; -Inf];
    ub = [ub; Inf];
end

if t
    x0 = [x0 tmax./tf];
    lb = [lb; (tmaxbounds(1,1)./tf)];
    ub = [ub; (tmaxbounds(1,2)./tf)];
end

ub = ub';
lb = lb';

f = @(x)glm_cost2(x,Ymeas,window,B,Blocs,Btypes,Blabels,tmax,yint,modelparams,norm);
nonlcon = @ta_nlc;

options = optimoptions('fmincon','Display','off');

[x0, cost, exitflag,~,~,~,hessian] = fmincon(f,x0,[],[],[],[],lb,ub,nonlcon,options);

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
    
% figure
% hold on
% plot(0:window(2),Ymeas)
% plot(0:window(2),Ycalc,'r')
% plotlines(plotlocs,[0 max(Ymeas)])
