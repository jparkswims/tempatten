function [outX, optimflag, maxR2] = quick_glm_grid(Ymeas,pa,snum,dbug)

tempcost = nan(pa.gnum,1);

for gs = 1:pa.gnum
    tempcost(gs) = quick_glm_cost([pa.models.B(gs,:) cell2mat(pa.models.Blocs(gs,:)) 0 round(pa.dectime(snum)) pa.models.tmax(gs) pa.models.yint(gs)],Ymeas);
end

[~,sortind] = sort(tempcost);
[~,rank] = sort(sortind);
spind = find(rank <= pa.ssnum);

if dbug == 2
    fprintf('Best %d grid points found, beggining optimization fits\n',pa.ssnum)
end

B0 = pa.models.B(spind,:);
Blocs0 = cell2mat(pa.models.Blocs(spind,:));

for i = 1:size(B0,1)
    if ~issorted(Blocs0(i,:))
        [Blocs0(i,:),I] = sort(Blocs0(i,:));
        B0temp = B0(i,1:4);
        B0(i,1:4) = B0temp(I);
    end
end

X0 = [B0 Blocs0 zeros(pa.ssnum,1) (ones(pa.ssnum,1)*round(pa.dectime(snum))) pa.models.tmax(spind) pa.models.yint(spind)];

tempout = nan(pa.ssnum,13);
optimflag = nan(pa.ssnum,1);
R2 = nan(pa.ssnum,1);
SSt = sum((Ymeas-nanmean(Ymeas)).^2);

for ss = 1:pa.ssnum
    if dbug > 0
        fprintf('Grid point %d\n',ss)
    end
    [tempout(ss,:),cost,optimflag(ss)] = quick_glm_optim(Ymeas,X0(ss,:));
    R2(ss) = 1 - (cost/SSt);
    if dbug == 2
        if ss == 1
            fprintf('Grid Numbers Completed:')
        end
        fprintf(' %d',ss)
    end
end

[maxR2,iR2] = max(R2);
outX = tempout(iR2,:);
optimflag = optimflag(iR2);

