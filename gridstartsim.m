load model_recov.mat

rng(10)

gnum = 1000;
snum = 40;
tnum = 100;

uB0 = unidist(10.*rand(tnum*10,1),tnum/10,10);
[uBlocT1, uBlocT2] = unidist2(1000.*rand(tnum*100,1)+500,1000.*rand(tnum*100,1)+750,13,1);
for ii = length(uBlocT1):-1:1
    if uBlocT1(ii) > uBlocT2(ii)
        uBlocT1(ii) = [];
        uBlocT2(ii) = [];
    end
end
uBlocT1 = uBlocT1(1:tnum);
uBlocT2 = uBlocT2(1:tnum);
uBlocs0 = unidist(1000.*rand(tnum*10,1)-500,tnum/10,10);
uRT = unidist(1000.*rand(tnum*10,1)+2350,tnum/10,10);

uintmax = unidist(1000.*rand(tnum*10,1)+500,tnum/10,10);
uinyint = unidist(.08.*rand(tnum*10,1)-.04,tnum/10,10);
uinB = [randsample(uB0,tnum) randsample(uB0,tnum) randsample(uB0,tnum) randsample(uB0,tnum) randsample(uB0,tnum)];
uinBlocs = [(0+randsample(uBlocs0,tnum)) (uBlocT1) (uBlocT2) (1750+randsample(uBlocs0,tnum)) (zeros(tnum,1)) round((randsample(uRT,tnum)))];
%inBlocs = num2cell([(0+randsample(uBlocs0,gnum)) (1000+randsample(uBlocs0,gnum)) (1250+randsample(uBlocs0,gnum)) (1750+randsample(uBlocs0,gnum))]);

for i = 1:tnum
    uinBlocs(i,1:4) = sort(uinBlocs(i,1:4));
end

uinBlocs2 = mat2cell(uinBlocs,ones(1,tnum),[1 1 1 1 2]);

rng(1)

unifize_dist

%%
% uinB = inB(uindex,:);
% uinBlocs = inBlocs(uindex,:);
% uintmax = intmax(uindex);
% uinyint = inyint(uindex);
% 
% uinBlocs2 = mat2cell(uinBlocs,ones(1,length(uindex)),[1 1 1 1 2]);
%%

uB0 = [10.*rand(gnum,1) 10.*rand(gnum,1) 10.*rand(gnum,1) 10.*rand(gnum,1) 10.*rand(gnum,1)];
uBlocs0 = [(1000.*rand(gnum,1)-500) (1000+1000.*rand(gnum,1)-500) (1250+1000.*rand(gnum,1)-500) (1750+1000.*rand(gnum,1)-500) zeros(gnum,1) (2350+1000.*rand(gnum,1)-500)];
utmax0 = 1500.*rand(gnum,1)+500;
uyint0 = .08.*rand(gnum,1)-.04;

uoutB = nan(size(uinB,1),size(uinB,2),snum);
uoutBlocs = nan(size(uinBlocs,1),size(uinBlocs,2),snum);
uouttmax = nan(size(uintmax,1),1,snum);
uoutyint = nan(size(uinyint,1),1,snum);
ucost = nan(size(uinB,1),1,snum);
uR2 = nan(size(uinB,1),1,snum);
uSP = nan(size(uinB,1),1,snum);
usort = nan(size(uinB,1),1,snum);

uBstart = nan(snum,size(uB0,2));
uBlocsstart = cell(snum,size(uBlocs0,2));
utmaxstart = nan(snum,1);
uyintstart = nan(snum,1);
tempcost = nan(gnum,1);

for i = 1:size(uinB,1)
    
    Ymeas = glm_calc(window1,uinB(i,:),uinBlocs2(i,:),Btypes,uintmax(i),uinyint(i),'max');
    
    for g = 1:gnum
        uBlocs0(g,6) = uinBlocs(i,6);
        tempcost(g) = quick_glm_cost([uB0(g,:) uBlocs0(g,:) utmax0(g) uyint0(g)],Ymeas);
    end
    [~,sortind] = sort(tempcost);
    [~,rank] = sort(sortind);
    spind = find(rank <= 40);
    
    uBstart = uB0(spind,:);
    uBlocsstart = mat2cell(uBlocs0(spind,:),ones(1,snum),[1 1 1 1 2]);
    utmaxstart = utmax0(spind);
    uyintstart = uyint0(spind);
    
    for j = 1:size(uBstart,1)
        
        uBlocsstart{j,5}(2) = uinBlocs(i,6);
        [uoutB(i,:,j), tempBloc, uouttmax(i,1,j), uoutyint(i,1,j), ucost(i,1,j), Ycalc,~,~,hessian,sflag] = glm_optim2(Ymeas,window2,uBstart(j,:),uBlocsstart(j,:),Blocbounds,Btypes,Blabels,Bbounds,utmaxstart(j),tmaxbounds,uyintstart(j),modelparams,'max');
        uoutBlocs(i,:,j) = cell2mat(tempBloc);
        SSt = sum((Ymeas-nanmean(Ymeas)).^2);
        uR2(i,1,j) = 1 - (ucost(i,1,j)/SSt);
        uSP(i,1,j) = ~(all(eig(hessian) >= 0));
        usort(i,1,j) = sflag;
        
    end
    
    fprintf('Starting set %d complete\n',i)
end

getbestR2