function [outX,cost,optimflag] = quick_glm_optim(Ymeas,X0)

% x ordered as [betas, locations, tmax, yint]
% glm_optim2(Ymeas,window,B,Blocs,Blocbounds,Btypes,Blabels,Bbounds,tmax,tmaxbounds,yint,modelparams,norm)
window = [-500 3500];
B = X0(1:5);
Blocs = mat2cell(X0(6:11),1,[1 1 1 1 2]);
Btypes = {'stick' 'stick' 'stick' 'stick' 'box'};
tmax = X0(12);
yint = X0(13);
norm = 'max';
Blocbounds = [-500 500; 500 1500; 750 1750; 1250 2250; -Inf Inf];
Blabels = {'precue' 't1' 't2' 'postcue' 'decision'};
tmaxbounds = [0 2000];
modelparams = {'locations' 'beta' 'tmax' 'yint'};
Bbounds = repmat([0 100],5,1);

[B, Blocs, tmax, yint, cost,~,~,~,~,~,optimflag] = glm_optim2(Ymeas,window,B,Blocs,Blocbounds,Btypes,Blabels,Bbounds,tmax,tmaxbounds,yint,modelparams,norm);

outX = [B cell2mat(Blocs) tmax yint];