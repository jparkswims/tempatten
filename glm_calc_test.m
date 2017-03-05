B = [0.1 1.2 0.3 0.6 1];
window = [-500 3500];
Blocs = {1250 0 1750 1000 [0 2250]};
Btypes = {'stick' 'stick' 'stick' 'stick' 'box'};
tmax = 859;
yint = 0.002;

Ymeas = glm_calc(window,B,Blocs,Btypes,tmax,yint);


window = [0 3500];
Blocbounds = [-250 250; 750 1250; 1000 1500; 1500 2000; -Inf Inf];
Bbounds = repmat([-100 100],5,1);
Blabels = {'precue' 't1' 't2' 'postcue' 'decision'};
tmaxbounds = [0 2000];
modelparams = {'locations' 'beta' 'tmax' 'yint'};
B0 = ones(1,length(B));
Blocs0 = {0 1000 1250 1750 [0 2250]};
tmax0 = 930;
yint0 = 0;


[testB, testBloc, testtmax, testyint, cost, Ycalc] = glm_optim2(Ymeas,window,B0,Blocs0,Blocbounds,Btypes,Blabels,Bbounds,tmax0,tmaxbounds,yint0,modelparams);

% Ytest = glm_calc(window,testB,testBloc,Btypes,testtmax,testyint);
% 
% hold on
% plot(0:window(2),Ytest,'g')