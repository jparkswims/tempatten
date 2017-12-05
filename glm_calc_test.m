rng(1)
inB = rand(1000,5).*10;
window1 = [-500 3500];
inBlocs = [((rand(1000,1).*1000)-500) ((rand(1000,1).*1000)+500) ((rand(1000,1).*1000)+750) ((rand(1000,1).*1000)+1250) (zeros(1000,1)) ((rand(1000,1).*1000)+2350)];
for i = 1:1000
    inBlocs(i,1:4) = sort(inBlocs(i,1:4));
end
inBlocs(:,6) = round(inBlocs(:,6));
inBlocs2 = mat2cell(inBlocs,ones(1,1000),[1 1 1 1 2]);
%Blocs = {0 1000 1250 1750 [0 2250]};
Btypes = {'stick' 'stick' 'stick' 'stick' 'box'};
intmax = (rand(1000,1) .* 1500) + 500;
inyint = (rand(1000,1) .* .08) - .04;

%Ymeas = glm_calc(window,B,Blocs,Btypes,tmax,yint);


window2 = [0 3500];
Blocbounds = [-500 500; 500 1500; 750 1750; 1250 2250; -Inf Inf];
Bbounds = repmat([0 100],5,1);
Blabels = {'precue' 't1' 't2' 'postcue' 'decision'};
tmaxbounds = [0 2000];
modelparams = {'locations' 'beta' 'tmax' 'yint'};
B0 = ones(1,5);
Blocs0 = {0 1000 1250 1750 [0 2250]};
tmax0 = 930;
yint0 = 0;

outB = nan(1000,5);
outBlocs = nan(1000,6);
outtmax = nan(1000,1);
outyint = nan(1000,1);
cost = nan(1000,1);

for i = 1:1000

    Blocs0{5}(2) = inBlocs(i,6);
    Ymeas = glm_calc(window1,inB(i,:),inBlocs2(i,:),Btypes,intmax(i),inyint(i),'max');
    [outB(i,:), tempBloc, outtmax(i), outyint(i), cost(i)] = glm_optim2(Ymeas,window2,B0,Blocs0,Blocbounds,Btypes,Blabels,Bbounds,tmax0,tmaxbounds,yint0,modelparams,'max');
    outBlocs(i,:) = cell2mat(tempBloc);
    
end

inlabels = {'pcB_in' 't1B_in' 't2B_in' 'rcB_in' 'decB_in' 'pcL_in' 't1L_in' 't2L_in' 'rcL_in' 'RT' 'tmax_in' 'yint_in'};
outlabels = {'pcB_out' 't1B_out' 't2B_out' 'rcB_out' 'decB_out' 'pcL_out' 't1L_out' 't2L_out' 'rcL_out' 'RT' 'tmax_out' 'yint_out'};
xx = [1 2 3 4 6];

figure(1)
corrplot([inB inBlocs(:,xx) intmax inyint],[outB outBlocs(:,xx) outtmax outyint],inlabels,outlabels)

figure(2)
corrplot([outB outBlocs(:,xx) outtmax outyint],[outB outBlocs(:,xx) outtmax outyint],outlabels,outlabels)

% Ytest = glm_calc(window,testB,testBloc,Btypes,testtmax,testyint);
% 
% hold on
% plot(0:window(2),Ytest,'g')