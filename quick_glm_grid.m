function [outX, optimflag, maxR2, optimplot] = quick_glm_grid(Ymeas,pa,snum,dbug,mnum)

opflag = true;

tempcost = nan(pa.gnum,1);

for gs = 1:pa.gnum
    if mnum == 1
        tempcost(gs) = quick_glm_cost([pa.models(mnum).B(gs,:) cell2mat(pa.models(mnum).Blocs(gs,:)) 0 round(pa.dectime(snum)) pa.models(mnum).tmax(gs) pa.models(mnum).yint(gs)],Ymeas);
    elseif mnum == 2
        tempcost(gs) = quick_glm_cost_1T([pa.models(mnum).B(gs,:) cell2mat(pa.models(mnum).Blocs(gs,:)) 0 round(pa.dectime(snum)) pa.models(mnum).tmax(gs) pa.models(mnum).yint(gs)],Ymeas);
    end
end

[~,sortind] = sort(tempcost);
[~,rank] = sort(sortind);
spind = find(rank <= pa.ssnum);

if dbug == 2
    fprintf('Best %d grid points found, beginning optimization fits\n',pa.ssnum)
end

B0 = pa.models(mnum).B(spind,:);
Blocs0 = cell2mat(pa.models(mnum).Blocs(spind,:));

for i = 1:size(B0,1)
    if ~issorted(Blocs0(i,:))
        [Blocs0(i,:),I] = sort(Blocs0(i,:));
        B0temp = B0(i,1:size(Blocs0,2));
        B0(i,1:size(Blocs0,2)) = B0temp(I);
    end
end

X0 = [B0 Blocs0 zeros(pa.ssnum,1) (ones(pa.ssnum,1)*round(pa.dectime(snum))) pa.models(mnum).tmax(spind) pa.models(mnum).yint(spind)];

tempout = nan(pa.ssnum,size(X0,2));
optimflag = nan(pa.ssnum,1);
R2 = nan(pa.ssnum,1);
SSt = sum((Ymeas-nanmean(Ymeas)).^2);

for ss = 1:pa.ssnum
%     if dbug > 0
%         fprintf('Grid point %d\n',ss)
%     end
    [tempout(ss,:),cost,optimflag(ss)] = quick_glm_optim(Ymeas,X0(ss,:));
    R2(ss) = 1 - (cost/SSt);
    if dbug == 2
        if ss == 1
            fprintf('Optimizations Completed:')
        end
        fprintf(' %d',ss)
    end
end

[maxR2,iR2] = max(R2);
outX = tempout(iR2,:);
optimflag = optimflag(iR2);

if opflag
    fprintf('\nMaking Realtime OptimPlot... ')
    [~,~,~,optimplot] = quick_glm_optim(Ymeas,X0(iR2,:));
    fprintf('Done\n\n')
end