function [outX, hessian] = quick_glm_optim2(inX,X0)

% x ordered as [betas, locations, tmax, yint]
% glm_optim2(Ymeas,window,B,Blocs,Blocbounds,Btypes,Blabels,Bbounds,tmax,tmaxbounds,yint,modelparams,norm)
window = [0 3500];
B = X0(1:5);
Blocs = mat2cell(X0(6:11),1,[1 1 1 1 2]);
Blocs{5} = inX(10:11);
Btypes = {'stick' 'stick' 'stick' 'stick' 'box'};
tmax = X0(12);
yint = X0(13);
norm = 'max';
Blocbounds = [-500 500; 500 1500; 750 1750; 1250 2250; -Inf Inf];
Blabels = {'precue' 't1' 't2' 'postcue' 'decision'};
tmaxbounds = [0 2000];
modelparams = {'locations' 'beta' 'tmax' 'yint'};
Bbounds = repmat([0 100],5,1);

Ymeas = quick_glm_calc(inX,0);

[B, Blocs, tmax, yint, ~, ~, ~, ~, hessian] = glm_optim2(Ymeas,window,B,Blocs,Blocbounds,Btypes,Blabels,Bbounds,tmax,tmaxbounds,yint,modelparams,norm);

outX = [B cell2mat(Blocs) tmax yint];

%figure
[~,~] = quick_glm_calc(outX,1);