%glm_grid_test.m
rng(1)

window1 = [-500 3500];
window2 = [0 3500];
Btypes = {'stick' 'stick' 'stick' 'stick' 'box'};
Blocbounds = [-500 500; 500 1500; 750 1750; 1250 2250; -Inf Inf];
Bbounds = repmat([0 100],5,1);
Blabels = {'precue' 't1' 't2' 'postcue' 'decision'};
tmaxbounds = [0 2000];
modelparams = {'locations' 'beta' 'tmax' 'yint'};
plabels = {'pcB','t1B','t2B','rcB','decB','pcL','t1L','t2L','rcL','tmax','yint'};
plabels2 = {'pcB','t1B','t2B','rcB','decB','pcL','t1L','t2L','rcL','decL_1','decL_2','tmax','yint'};

gnum = 2000;
snum = 40;
tnum = 100;

uB0 = unidist(10.*rand(gnum*10,1),gnum/snum,snum);
uBlocs0 = unidist(1000.*rand(gnum*10,1)-500,gnum/snum,snum);

tmax0 = unidist(1000.*rand(gnum*10,1)+500,gnum/snum,snum);
yint0 = unidist(.08.*rand(gnum*10,1)-.04,gnum/snum,snum);
B0 = [randsample(uB0,gnum) randsample(uB0,gnum) randsample(uB0,gnum) randsample(uB0,gnum) randsample(uB0,gnum)];
Blocs0 = [(0+randsample(uBlocs0,gnum)) (1000+randsample(uBlocs0,gnum)) (1250+randsample(uBlocs0,gnum)) (1750+randsample(uBlocs0,gnum)) zeros(gnum,1) nan(gnum,1)];

rng(10)

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

intmax = randsample(unidist(1000.*rand(tnum*10,1)+500,tnum/10,10),tnum);
inyint = randsample(unidist(.08.*rand(tnum*10,1)-.04,tnum/10,10),tnum);
inB = [randsample(uB0,tnum) randsample(uB0,tnum) randsample(uB0,tnum) randsample(uB0,tnum) randsample(uB0,tnum)];
inBlocs = [(0+randsample(uBlocs0,tnum)) (uBlocT1) (uBlocT2) (1750+randsample(uBlocs0,tnum)) (zeros(tnum,1)) round((randsample(uRT,tnum)))];
%inBlocs = num2cell([(0+randsample(uBlocs0,gnum)) (1000+randsample(uBlocs0,gnum)) (1250+randsample(uBlocs0,gnum)) (1750+randsample(uBlocs0,gnum))]);

for i = 1:tnum
    inBlocs(i,1:4) = sort(inBlocs(i,1:4));
end

inBlocscell = mat2cell(inBlocs,ones(1,tnum),[1 1 1 1 2]);

outB = nan(tnum,5);
outBlocs = nan(tnum,6);
outtmax = nan(tnum,1);
outyint = nan(tnum,1);
outR2 = nan(tnum,1);

tempR2 = nan(snum,1);

tempB = nan(snum,5);
tempBlocs = nan(snum,6);
temptmax = nan(snum,1);
tempyint = nan(snum,1);
stempcost = nan(snum,1);

% close all
% 
% %input params vs input params
% figure(1)
% corrplot([inB inBlocs intmax inyint],[inB inBlocs intmax inyint],plabels2,plabels2,'heatdist')
% title('Input GLM params vs Input GLM params','FontSize',24)
% xlabel('Input GLM params','FontSize',24)
% ylabel('Input GLM params','FontSize',24)
% 
% %input params vs starting points
% figure(2)
% corrplot(repmat([inB inBlocs intmax inyint],20,1),[B0 Blocs0 tmax0 yint0],plabels2,plabels2,'heatdist')
% title('Search Params vs Input GLM params','FontSize',24)
% xlabel('Input GLM params','FontSize',24)
% ylabel('Search params','FontSize',24)
% 
% %search points vs search points
% figure(3)
% corrplot([B0 Blocs0 tmax0 yint0],[B0 Blocs0 tmax0 yint0],plabels2,plabels2,'heatdist')
% title('Search Params vs Input GLM params','FontSize',24)
% xlabel('Input GLM params','FontSize',24)
% ylabel('Search params','FontSize',24)

for tt = 1:tnum
    
    gtempcost = nan(gnum,1);
    fprintf('\nStarting grid search for input set %d\n',tt)
    
    Ymeas = glm_calc(window1,inB(tt,:),inBlocscell(tt,:),Btypes,intmax(tt),inyint(tt),'max');
    
    for gg = 1:gnum;
        Blocs0(gg,6) = inBlocs(tt,6);
        gtempcost(gg) = quick_glm_cost([B0(gg,:) Blocs0(gg,:) tmax0(gg) yint0(gg)],Ymeas);
    end
    
    [~,sortind] = sort(gtempcost);
    [~,rank] = sort(sortind);
    spind = find(rank <= 40);
    
    Bstart = B0(spind,:);
    Blocsstart = mat2cell(Blocs0(spind,:),ones(1,snum),[1 1 1 1 2]);
    tmaxstart = tmax0(spind);
    yintstart = yint0(spind);
    
    fprintf('Best %d starting sets found, starting optimizations\nOptims completed: ',snum)
    
    for ss = 1:snum
        
        Blocsstart{ss,5}(2) = inBlocs(tt,6);
        [tempB(ss,:), tempBloc, temptmax(ss), tempyint(ss), stempcost(ss), Ycalc,~,~,hessian,sflag] = glm_optim2(Ymeas,window2,Bstart(ss,:),Blocsstart(ss,:),Blocbounds,Btypes,Blabels,Bbounds,tmaxstart(ss),tmaxbounds,yintstart(ss),modelparams,'max');
        tempBlocs(ss,:) = cell2mat(tempBloc);
        SSt = sum((Ymeas-nanmean(Ymeas)).^2);
        tempR2(ss) = 1 - (stempcost(ss)/SSt);
        %usort(i,1,j) = sflag;
        
%         [outR2(tt),mind] = max(tempR2);
%         outB(tt,:) = tempB(mind,:);
%         outBlocs(tt,:) = tempBlocs(mind,:);
%         outtmax(tt) = temptmax(mind);
%         outyint(tt) = tempyint(mind);

        fprintf('%d ',ss)
        
    end
    
    [outR2(tt),mind] = max(tempR2);
    outB(tt,:) = tempB(mind,:);
    outBlocs(tt,:) = tempBlocs(mind,:);
    outtmax(tt) = temptmax(mind);
    outyint(tt) = tempyint(mind);
    
    fprintf('\nOptimizations completed for input set %d\n',tnum)
    fprintf('Final R2 = %f\n',outR2(tt))
end
        
save('glm_grid_test_out.mat')

%% figures
plabels = {'pcB','t1B','t2B','rcB','decB','pcL','t1L','t2L','rcL','tmax','yint'};
plabels2 = {'pcB','t1B','t2B','rcB','decB','pcL','t1L','t2L','rcL','decL_1','decL_2','tmax','yint'};

figure(1)
heatdists2(inB(:,1),outB(:,1),[50 50],plabels(1),'roundlims')
set(gcf,'Resize','off')
set(gcf,'Position',[100 100 400 315])
xlabel(['Input ' plabels{1}],'FontSize',24)
ylabel(['Output ' plabels{1}],'FontSize',24)
print('/Users/jakeparker/Documents/tempatten/paperfigs/figAA.pdf','-dpdf','-opengl')

figure(2)
heatdists2(inB(:,2),outB(:,2),[50 50],plabels(1),'roundlims')
set(gcf,'Resize','off')
set(gcf,'Position',[100 100 400 315])
xlabel(['Input ' plabels{2}],'FontSize',24)
ylabel(['Output ' plabels{2}],'FontSize',24)
print('/Users/jakeparker/Documents/tempatten/paperfigs/figBB.pdf','-dpdf','-opengl')

figure(3)
heatdists2(inB(:,3),outB(:,3),[50 50],plabels(1),'roundlims')
set(gcf,'Resize','off')
set(gcf,'Position',[100 100 400 315])
xlabel(['Input ' plabels{3}],'FontSize',24)
ylabel(['Output ' plabels{3}],'FontSize',24)
print('/Users/jakeparker/Documents/tempatten/paperfigs/figCC.pdf','-dpdf','-opengl')

figure(4)
heatdists2(inB(:,4),outB(:,4),[50 50],plabels(1),'roundlims')
set(gcf,'Resize','off')
set(gcf,'Position',[100 100 400 315])
xlabel(['Input ' plabels{4}],'FontSize',24)
ylabel(['Output ' plabels{4}],'FontSize',24)
print('/Users/jakeparker/Documents/tempatten/paperfigs/figDD.pdf','-dpdf','-opengl')

figure(5)
heatdists2(inB(:,5),outB(:,5),[50 50],plabels(1),'roundlims')
set(gcf,'Resize','off')
set(gcf,'Position',[100 100 400 315])
xlabel(['Input ' plabels{5}],'FontSize',24)
ylabel(['Output ' plabels{5}],'FontSize',24)
print('/Users/jakeparker/Documents/tempatten/paperfigs/figEE.pdf','-dpdf','-opengl')

figure(6)
heatdists2(inBlocs(:,1)-0,outBlocs(:,1)-0,[50 50],plabels(1),'roundlims')
set(gcf,'Resize','off')
set(gcf,'Position',[100 100 400 315])
xlabel(['Input ' plabels{6}],'FontSize',24)
ylabel(['Output ' plabels{6}],'FontSize',24)
print('/Users/jakeparker/Documents/tempatten/paperfigs/figFF.pdf','-dpdf','-opengl')

figure(7)
heatdists2(inBlocs(:,2)-1000,outBlocs(:,2)-1000,[50 50],plabels(1),'roundlims')
set(gcf,'Resize','off')
set(gcf,'Position',[100 100 400 315])
xlabel(['Input ' plabels{7}],'FontSize',24)
ylabel(['Output ' plabels{7}],'FontSize',24)
print('/Users/jakeparker/Documents/tempatten/paperfigs/figGG.pdf','-dpdf','-opengl')

figure(8)
heatdists2(inBlocs(:,3)-1250,outBlocs(:,3)-1250,[50 50],plabels(1),'roundlims')
set(gcf,'Resize','off')
set(gcf,'Position',[100 100 400 315])
xlabel(['Input ' plabels{8}],'FontSize',24)
ylabel(['Output ' plabels{8}],'FontSize',24)
print('/Users/jakeparker/Documents/tempatten/paperfigs/figHH.pdf','-dpdf','-opengl')

figure(9)
heatdists2(inBlocs(:,4)-1750,outBlocs(:,4)-1750,[50 50],plabels(1),'roundlims')
set(gcf,'Resize','off')
set(gcf,'Position',[100 100 400 315])
xlabel(['Input ' plabels{9}],'FontSize',24)
ylabel(['Output ' plabels{9}],'FontSize',24)
print('/Users/jakeparker/Documents/tempatten/paperfigs/figII.pdf','-dpdf','-opengl')

figure(10)
heatdists2(intmax,outtmax,[50 50],plabels(1),'roundlims')
set(gcf,'Resize','off')
set(gcf,'Position',[100 100 400 315])
xlabel(['Input ' plabels{10}],'FontSize',24)
ylabel(['Output ' plabels{10}],'FontSize',24)
print('/Users/jakeparker/Documents/tempatten/paperfigs/figJJ.pdf','-dpdf','-opengl')

figure(11)
heatdists2(inyint,outyint,[50 50],plabels(1))
set(gcf,'Resize','off')
set(gcf,'Position',[100 100 400 315])
xlabel(['Input ' plabels{11}],'FontSize',24)
ylabel(['Output ' plabels{11}],'FontSize',24)
print('/Users/jakeparker/Documents/tempatten/paperfigs/figKK.pdf','-dpdf','-opengl')
%set(gcf,'PaperPosition',[0 0 2800/150 315/150])


% figure(2)
% heatdists2(inBlocs(:,1:4),outBlocs(:,1:4),[50 50],plabels(6:9))
% set(gcf,'Resize','off')
% set(gcf,'Position',[100 100 2200 315])
% set(gcf,'PaperPosition',[0 0 2200/150 315/150])
% saveas(gcf,'/Users/jakeparker/Documents/tempatten/paperfigs/figBB.png')
% 
% figure(3)
% heatdists2(intmax,outtmax,[50 50],plabels(10))
% set(gcf,'Resize','off')
% set(gcf,'Position',[100 100 400 315])
% set(gcf,'PaperPosition',[0 0 400/150 315/150])
% saveas(gcf,'/Users/jakeparker/Documents/tempatten/paperfigs/figCC.png')
% 
% figure(4)
% heatdists2(inyint,outyint,[50 50],plabels(11))
% set(gcf,'Resize','off')
% set(gcf,'Position',[100 100 400 315])
% set(gcf,'PaperPosition',[0 0 400/150 315/150])
% saveas(gcf,'/Users/jakeparker/Documents/tempatten/paperfigs/figDD.png')


