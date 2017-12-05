load model_recov.mat

rng(1)

unifize_dist

gnum = 1000;
snum = 40;

uinB = inB(uindex,:);
uinBlocs = inBlocs(uindex,:);
uintmax = intmax(uindex);
uinyint = inyint(uindex);

uinBlocs2 = mat2cell(uinBlocs,ones(1,length(uindex)),[1 1 1 1 2]);

uB0 = [10.*rand(gnum,1) 10.*rand(gnum,1) 10.*rand(gnum,1) 10.*rand(gnum,1) 10.*rand(gnum,1)];
uBlocs0 = [(1000.*rand(gnum,1)-500) (1000+1000.*rand(gnum,1)-500) (1250+1000.*rand(gnum,1)-500) (1750+1000.*rand(gnum,1)-500) zeros(gnum,1) (2350+1000.*rand(gnum,1)-500)];
utmax0 = 1500.*rand(gnum,1)+500;
uyint0 = .08.*rand(gnum,1)-.04;

uoutB = nan(size(uinB,1),size(uinB,2),snum);
uoutBlocs = nan(size(uinBlocs,1),size(uinBlocs,2),snum);
uouttmax = nan(size(uintmax,1),1,snum);
uoutyint = nan(size(uinyint,1),1,snum);
ucost = nan(49,1,snum);
uR2 = nan(49,1,snum);
uSP = nan(49,1,snum);
usort = nan(49,1,snum);

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
end

getbestR2