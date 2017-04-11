function [B, Blocs, tmax, yint, cost, Ycalc, Blabels, numparams] = glm_optim2(Ymeas,window,B,Blocs,Blocbounds,Btypes,Blabels,Bbounds,tmax,tmaxbounds,yint,modelparams,norm)

% x ordered as [betas, locations, tmax, yint]

Ymeas(1:-window(1)) = [];

t = any(strcmp(modelparams,'tmax'));
l = any(strcmp(modelparams,'locations'));
y = any(strcmp(modelparams,'yint'));
b = any(strcmp(modelparams,'beta'));

lb = [];
ub = [];
x0 = [];

if b
    x0 = B;
    lb = Bbounds(:,1);
    ub = Bbounds(:,2);
end

if l
    ind = find(cellfun('length',regexp(Blabels,'decision')) ~= 1);
    for i = 1:length(ind)
        x0 = [x0 (Blocs{ind(i)})];
        lb = [lb; (Blocbounds(ind(i),1))];
        ub = [ub; (Blocbounds(ind(i),2))];
    end
end

if y
    x0 = [x0 yint];
    lb = [lb; -Inf];
    ub = [ub; Inf];
end

if t
    x0 = [x0 tmax];
    lb = [lb; tmaxbounds(1,1)];
    ub = [ub; tmaxbounds(1,2)];
end

ub = ub';
lb = lb';

f = @(x)glm_cost2(x,Ymeas,window,B,Blocs,Btypes,Blabels,tmax,yint,modelparams,norm);

[x0, cost] = fmincon(f,x0,[],[],[],[],lb,ub);

if b
    numB = length(B);
    B = x0(1:numB);
else
    numB = 0;
end
    
if l
    ind = find(cellfun('length',regexp(Blabels,'decision')) ~= 1);
    numL = length(ind);
    for i = 1:numL
%         Blocs{ind(i)} = x0(numB+i);
        temp(i) = x0(numB+i);
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
    yint = x0(numB+numL+1);
end

if t
    tmax = x0(end);
end

Ycalc = glm_calc(window,B,Blocs,Btypes,tmax,yint,norm);
numparams = length(x0);
    
% figure
% hold on
% plot(0:window(2),Ymeas)
% plot(0:window(2),Ycalc,'r')
% plotlines(plotlocs,[0 max(Ymeas)])
