load model_recov.mat

rng(1)

unifize_dist

snum = 40;

uinB = inB(uindex,:);
uinBlocs = inBlocs(uindex,:);
uintmax = intmax(uindex);
uinyint = inyint(uindex);

uinBlocs2 = mat2cell(uinBlocs,ones(1,length(uindex)),[1 1 1 1 2]);

uB0 = unidist(10.*rand(snum*10,1),snum,1);
uBlocs0 = unidist(1000.*rand(snum*10,1)-500,snum,1);
utmax0 = unidist(1500.*rand(snum*10,1)+500,snum,1);
uyint0 = unidist(.08.*rand(snum*10,1)-.04,snum,1);

uB0 = [randsample(uB0,snum) randsample(uB0,snum) randsample(uB0,snum) randsample(uB0,snum) randsample(uB0,snum)];
uBlocs0 = [(0+randsample(uBlocs0,snum)) (1000+randsample(uBlocs0,snum)) (1250+randsample(uBlocs0,snum)) (1750+randsample(uBlocs0,snum)) zeros(snum,1) (2350+randsample(uBlocs0,snum))];
utmax0 = randsample(utmax0,snum);
uyint0 = randsample(uyint0,snum);

uBlocs0 = mat2cell(uBlocs0,ones(1,snum),[1 1 1 1 2]);

uoutB = nan(size(uinB,1),size(uinB,2),snum);
uoutBlocs = nan(size(uinBlocs,1),size(uinBlocs,2),snum);
uouttmax = nan(size(uintmax,1),1,snum);
uoutyint = nan(size(uinyint,1),1,snum);
ucost = nan(49,1,snum);
uR2 = nan(49,1,snum);
uSP = nan(49,1,snum);
usort = nan(49,1,snum);

for i = 1:size(uinB,1)
    
    Ymeas = glm_calc(window1,uinB(i,:),uinBlocs2(i,:),Btypes,uintmax(i),uinyint(i),'max');
    
    for j = 1:size(uB0,1)
        
        uBlocs0{j,5}(2) = uinBlocs(i,6);
        [uoutB(i,:,j), tempBloc, uouttmax(i,1,j), uoutyint(i,1,j), ucost(i,1,j), Ycalc,~,~,hessian,sflag] = glm_optim2(Ymeas,window2,uB0(j,:),uBlocs0(j,:),Blocbounds,Btypes,Blabels,Bbounds,utmax0(j),tmaxbounds,uyint0(j),modelparams,'max');
        uoutBlocs(i,:,j) = cell2mat(tempBloc);
        SSt = sum((Ymeas-nanmean(Ymeas)).^2);
        uR2(i,1,j) = 1 - (ucost(i,1,j)/SSt);
        uSP(i,1,j) = ~(all(eig(hessian) >= 0));
        usort(i,1,j) = sflag;
        
    end
end

getbestR2

