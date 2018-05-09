function [outX,cost,optimflag,optimplot] = quick_glm_optim_noL(Ymeas,X0)

% x ordered as [betas, locations, tmax, yint]
% glm_optim2(Ymeas,window,B,Blocs,Blocbounds,Btypes,Blabels,Bbounds,tmax,tmaxbounds,yint,modelparams,norm)
window = [-500 3500];
if length(X0) == 13
    B = X0(1:5);
    Blocs = mat2cell(X0(6:11),1,[1 1 1 1 2]);
    Btypes = {'stick' 'stick' 'stick' 'stick' 'box'};
    tmax = X0(12);
    yint = X0(13);
    norm = 'max';
    Blocbounds = [-500 500; 500 1500; 750 1750; 1250 2250; -Inf Inf];
    Blabels = {'precue' 't1' 't2' 'postcue' 'decision'};
    tmaxbounds = [0 2000];
    modelparams = {'no L' 'beta' 'tmax' 'yint'};
    Bbounds = repmat([0 100],5,1);
elseif length(X0) == 11
    B = X0(1:4);
    Blocs = mat2cell(X0(5:9),1,[1 1 1 2]);
    Btypes = {'stick' 'stick' 'stick' 'box'};
    tmax = X0(10);
    yint = X0(11);
    norm = 'max';
    Blocbounds = [-500 500; 500 1750; 1250 2250; -Inf Inf];
    Blabels = {'precue' 'target' 'postcue' 'decision'};
    tmaxbounds = [0 2000];
    modelparams = {'locations' 'beta' 'tmax' 'yint'};
    Bbounds = repmat([0 100],4,1);
end

[B, Blocs, tmax, yint, cost,~,~,~,~,~, optimflag, optimplot] = glm_optim2(Ymeas,window,B,Blocs,Blocbounds,Btypes,Blabels,Bbounds,tmax,tmaxbounds,yint,modelparams,norm);

outX = [B cell2mat(Blocs) tmax yint];