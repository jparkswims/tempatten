%pa_paper_figs
close all
clear all

%%
scale = 100;
window = [-500 3500];
h = hpupil(0:window(2),10.1,930,0,'max');
%h(h==0) = [];
%h(3701:end) = [];

figure(1)
clf
hold on
plot([930 930],[0 1.2],'--','color',[0.5 0.5 0.5],'LineWidth',2)
plot(0:3500,h*scale,'k','LineWidth',2)
xlim([-500 4000])
ylim([0 1.2])
xlabel('Time (ms)','FontSize',20)
ylabel('Pupil area (% change)','FontSize',20)
set(gca,'TickDir','out')
%set(gca,'YTick',[])
pbaspect([2 1 1])
set(gca,'FontSize',18)
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 600 320])
box off
print('/Users/jakeparker/Documents/tempatten/paperfigs/figA.svg','-dsvg')

%%
load E0E3tvc_32M.mat
model = 1;
scale = 100;
sampleSubject = 10;
smean = pa_tvc.t1vc.smeans(sampleSubject,301:end);
pwind = [-500 4000];

ppcuecolors = {
    [.46 .77 .65]
    [.70 .46 .77]};

t1colors = {
    [123 146 202]./255
    [167 179 219]./255
    [204 208 233]./255};

t2colors = {
    [242 123 96]./255
    [247 161 140]./255
    [251 197 185]./255};

cuecondcolors = {
    t1colors{1}
    t2colors{1}
    [.5 .5 .5]};

grayBoxColor = [.9 .9 .9];
baselineColor = [1 .93 .8]; %[255 222 154]/255;

vBoxY = [2.7 2.7 2.95 2.95; 1.7 1.7 1.95 1.95; 0.7 0.7 0.95 0.95];
vLineY = vBoxY(:,2:3);
vBoxX = [0.7 0.7 0.95 0.95; 1.7 1.7 1.95 1.95; 2.7 2.7 2.95 2.95];
vLineX = vBoxX(:,2:3);
cShift = [0 0.35];
cAlphas = [1 0];
cLineColors = [0 0 0; .7 .7 .7];
vNames = {'valid','neutral','invalid'};
vNamesShort = {'V','N','I'};
vPos = 1:3;
targetTimes = [1000 1250];
targetDur = 30;
cueDur = 200;

[B, Blocs, tmax, yint, ~, Y] = glm_optim2(pa_tvc.t1vc.smeans(sampleSubject,:),...
    pa_tvc.window,...
    pa_tvc.models(model).B,...
    [pa_tvc.models(model).Blocs [0 round(pa_tvc.dectime(sampleSubject))]],...
    pa_tvc.models(model).Blocbounds,...
    pa_tvc.models(model).Btypes,...
    pa_tvc.models(model).Blabels,...
    pa_tvc.models(model).Bbounds,...
    pa_tvc.models(model).tmax,...
    pa_tvc.models(model).tmaxbounds,...
    pa_tvc.models(model).yint,...
    pa_tvc.models(model).params,...
    'max');
[~, X] = glm_calc(pwind,B,Blocs,{'stick' 'stick' 'stick' 'stick' 'box'},tmax,yint,'max');

%%

figure(2)
clf
hold on
plotboxes([-200 0], [-.02 .12]*scale, baselineColor)
plotboxes([pa_tvc.locs' (pa_tvc.locs+[cueDur targetDur targetDur cueDur])'],ylim, grayBoxColor)
% plotlines(pa_tvc.locs(1),ylim,'color',ppcuecolors{1})
% plotlines(pa_tvc.locs(2),ylim,'color',t1colors{1})
% plotlines(pa_tvc.locs(3),ylim,'color',t2colors{1})
% plotlines(pa_tvc.locs(4),ylim,'color',ppcuecolors{2})
h1(1) = plot(-200:pa_tvc.window(2),smean*scale,'color',[237 177 32]/255,'LineWidth',2);
plot(0:pwind(2),X(1,:)*scale,'color',ppcuecolors{1},'LineWidth',2)
plot(0:pwind(2),X(2,:)*scale,'color',t1colors{1},'LineWidth',2)
plot(0:pwind(2),X(3,:)*scale,'color',t2colors{1},'LineWidth',2)
plot(0:pwind(2),X(4,:)*scale,'color',ppcuecolors{2},'LineWidth',2)
plot(0:pwind(2),X(5,:)*scale,'k','LineWidth',2)
h1(2) = plot(0:pa_tvc.window(2),Y*scale,'color',[0.5 0.5 0.5],'LineWidth',2,'LineStyle','--');
xlabel('Time (ms)','FontSize',20)
ylabel('Pupil area (% change)','FontSize',20)
pbaspect([2 1 1])
xlim(pwind)
ylim([-.02 .12]*scale)
set(gca,'TickDir','out')
set(gca,'LineWidth',1)
set(gca,'FontSize',18)
box off
legend(h1,'data','model')
legend boxoff
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 600 320])
print('/Users/jakeparker/Documents/tempatten/paperfigs/figB.svg','-dsvg')

%print('samplefig.pdf','-dpdf')

%%
sjB = pa_tvc.t1vc.models(model).betas(sampleSubject,:);
sjBlocs = pa_tvc.t1vc.models(model).locations(sampleSubject,:);

figure(3)
hold on
h1 = plot([sjBlocs(1) sjBlocs(1)],[0 sjB(1)],'color',ppcuecolors{1},'LineWidth',2);
h2 = plot([sjBlocs(2) sjBlocs(2)],[0 sjB(2)],'color',t1colors{1},'LineWidth',2);
h3 = plot([sjBlocs(3) sjBlocs(3)],[0 sjB(3)],'color',t2colors{1},'LineWidth',2);
plotboxes([pa_tvc.locs' (pa_tvc.locs+[cueDur targetDur targetDur cueDur])'],ylim, grayBoxColor)
h4 = plot([sjBlocs(4) sjBlocs(4)],[0 sjB(4)],'color',ppcuecolors{2},'LineWidth',2);
h5 = plot([0 0],[0 sjB(5)],'k','LineWidth',2);
plot([Blocs{5}(2) Blocs{5}(2)],[0 sjB(5)],'k','LineWidth',2)
plot([0 Blocs{5}(2)],[sjB(5) sjB(5)],'k','LineWidth',2);
set(gca,'TickDir','out')
%set(gca,'YTick',[])
pbaspect([2 1 1])
set(gca,'LineWidth',1)
set(gca,'FontSize',18)
box off
xlabel('Time (ms)','FontSize',20)
ylabel('Amplitude (a.u.)','FontSize',20)
xlim([-500 4000])
set(gcf,'Position',[100 100 600 320])
set(gcf,'Color',[1 1 1])
legend([h1 h2 h3 h4 h5],'precue','T1','T2','response cue','decision')
legend boxoff

print('/Users/jakeparker/Documents/tempatten/paperfigs/figC.svg','-dsvg')

%%
dataDir = '/Users/jakeparker/Google Drive/TA_Pupil/Data/gbs_plot_work.mat';
load(dataDir)
regcolors = [ppcuecolors{1}; t1colors{1}; t2colors{1}; ppcuecolors{2}; {[0 0 0]}; {[0 0 0]}];
markercolors = [regcolors [{[1 1 1]}; {[1 1 1]}; {[1 1 1]}; {[1 1 1]}; {[1 1 1]}; {[1 1 1]}]];
shapes = {'o','o'};

amplabs = {'precue','T1','T2','resp. cue','decision','y-intercept'};
latlabs = {'precue','T1','T2','resp. cue','t_max'};

sems = ste(smeds,0,3);
L2 = (-1).*sems;
U2 = sems;

%amplitude and yint group mean bootstrap medians by experiment
figure(4)
clf
hold on
plot([0 7],[0 0],'--','color',[0.5 0.5 0.5])
p = uncertplot(4,[mean(mean(smeds(:,:,exp1),1),3) ; mean(mean(smeds(:,:,exp2),1),3)],[mean(mean(mlci(:,:,exp1),1),3) ; mean(mean(mlci(:,:,exp2),1),3)],[mean(mean(muci(:,:,exp1),1),3) ; mean(mean(muci(:,:,exp2),1),3)],1,[1:5 11],1,regcolors,markercolors,shapes,xlab,'jitter','1by1','E2',L2,U2);
%title('Amplitude and y-intercept group mean bootstrap medians')
legend(p,'Discrimination','Estimation');
legend boxoff
set(gca,'FontSize',18)
box off
%xlabel('Time (ms)','FontSize',20)
ylabel('Amplitude (a.u.)','FontSize',20)
set(gca,'TickDir','out')
set(gca,'XTickLabel',amplabs)
%rotateXLabels(gca,45)
pbaspect([2 1 1])
xlim([0 7])
set(gcf,'Position',[100 100 800 400])

print('/Users/jakeparker/Documents/tempatten/paperfigs/figD.pdf','-dpdf')

%latency and tmax group mean bootstrap medians by experiment
figure(5)
hold on
plot([0 5],[0 0],'--','color',[0.5 0.5 0.5])
p = uncertplot(5,[mean(mean(smeds(:,:,exp1),1),3) ; mean(mean(smeds(:,:,exp2),1),3)],[mean(mean(mlci(:,:,exp1),1),3) ; mean(mean(mlci(:,:,exp2),1),3)],[mean(mean(muci(:,:,exp1),1),3) ; mean(mean(muci(:,:,exp2),1),3)],1,6:9,1,regcolors,markercolors,shapes,xlab,'jitter','1by1','E2',L2,U2);
%title('Latency and tmax group mean bootstrap medians')
xlim([0 5])
xl = xlim;
yl = ylim;
hold on
h1 = plot(1000,0,'ko','MarkerFaceColor','k','MarkerSize',10);
h2 = plot(1000,1,'ks','MarkerFaceColor','k','MarkerSize',10);
xlim(xl)
ylim(yl)
%legend([h1 h2],'Discrimination','Estimation','Location','NorthWest');
set(gca,'FontSize',18)
box off
ylabel('Latency relative to event (ms)','FontSize',18)
set(gca,'TickDir','out')
set(gca,'XTickLabels',latlabs)
pbaspect([2 1 1])
hold on
set(gcf,'Position',[100 100 800 400])

print('/Users/jakeparker/Documents/tempatten/paperfigs/figE.pdf','-dpdf')

%yint by itself
p = uncertplot(6,[mean(mean(smeds(:,:,exp1),1),3) ; mean(mean(smeds(:,:,exp2),1),3)],[mean(mean(mlci(:,:,exp1),1),3) ; mean(mean(mlci(:,:,exp2),1),3)],[mean(mean(muci(:,:,exp1),1),3) ; mean(mean(muci(:,:,exp2),1),3)],1,11,1,{[0 0 0]},[{[0 0 0]} {[1 1 1]}],shapes,xlab,'jitter','1by1','E2',L2,U2);
%title('Amplitude and y-intercept group mean bootstrap medians')
set(gca,'FontSize',18)
box off
set(gca,'TickDir','out')
pbaspect([1 3 1])
set(gca,'YAxisLocation','right')
set(gcf,'Position',[100 100 800 400])

print('/Users/jakeparker/Documents/tempatten/paperfigs/figF.pdf','-dpdf')

%tmax by itself
p = uncertplot(7,[mean(mean(smeds(:,:,exp1),1),3) ; mean(mean(smeds(:,:,exp2),1),3)],[mean(mean(mlci(:,:,exp1),1),3) ; mean(mean(mlci(:,:,exp2),1),3)],[mean(mean(muci(:,:,exp1),1),3) ; mean(mean(muci(:,:,exp2),1),3)],1,10,1,{[0 0 0]},[{[0 0 0]} {[1 1 1]}],shapes,xlab,'jitter','1by1','E2',L2,U2);
%title('Amplitude and y-intercept group mean bootstrap medians')
set(gca,'FontSize',18)
box off
set(gca,'TickDir','out')
pbaspect([1 3 1])
ylim([500 1500])
ylabel('Time (ms)','FontSize',20)
set(gca,'YAxisLocation','right')
set(gcf,'Position',[100 100 800 400])

print('/Users/jakeparker/Documents/tempatten/paperfigs/figG.pdf','-dpdf')

%%

figure(8)
clf
%latency and tmax group mean bootstrap medians by experiment
subplot(1,5,[1,2,3,4])
p = uncertplot(8,[mean(mean(smeds(:,:,exp1),1),3) ; mean(mean(smeds(:,:,exp2),1),3)],[mean(mean(mlci(:,:,exp1),1),3) ; mean(mean(mlci(:,:,exp2),1),3)],[mean(mean(muci(:,:,exp1),1),3) ; mean(mean(muci(:,:,exp2),1),3)],1,6:9,1,regcolors,markercolors,shapes,xlab,'jitter','1by1','E2',L2,U2);
set(gca,'FontSize',16)
box off
ylabel('Latency relative to event (ms)','FontSize',18)
set(gca,'TickDir','out')
hold on
plot([xl(1) xl(2)],[0 0],'--','color',[0.5 0.5 0.5])
pbaspect([2 1 1])
set(gca,'XTickLabel',latlabs)
xtickangle(45)
%rotateXLabels(gca,45)

subplot(1,5,5)
p = uncertplot(8,[mean(mean(smeds(:,:,exp1),1),3) ; mean(mean(smeds(:,:,exp2),1),3)],[mean(mean(mlci(:,:,exp1),1),3) ; mean(mean(mlci(:,:,exp2),1),3)],[mean(mean(muci(:,:,exp1),1),3) ; mean(mean(muci(:,:,exp2),1),3)],1,10,1,{[0 0 0]},[{[0 0 0]} {[1 1 1]}],shapes,xlab,'jitter','1by1','E2',L2,U2);
set(gca,'FontSize',16)
set(gca,'YAxisLocation','right')
ylabel('Time (ms)','FontSize',18)
box off
%xlabel('Time (ms)','FontSize',20)
set(gca,'TickDir','out')
ylim([500 1500])
xlim([0.5 1.5])
pbaspect([1 2.89 1])
set(gca,'XTickLabel','t_{max}')
xtickangle(45)
%rotateXLabels(gca,45)
set(gcf,'Position',[100 100 600 320])

print('/Users/jakeparker/Documents/tempatten/paperfigs/figH.svg','-dsvg')

%%
figure(18)
clf
%latency and tmax group mean bootstrap medians by experiment
subplot(1,6,[1,2,3,4,5])
hold on
plot([0 7],[0 0],'--','color',[0.5 0.5 0.5])
p = uncertplot(18,[mean(mean(smeds(:,:,exp1),1),3) ; mean(mean(smeds(:,:,exp2),1),3)],[mean(mean(mlci(:,:,exp1),1),3) ; mean(mean(mlci(:,:,exp2),1),3)],[mean(mean(muci(:,:,exp1),1),3) ; mean(mean(muci(:,:,exp2),1),3)],1,[1:5 11],1,regcolors,markercolors,shapes,xlab,'jitter','1by1','E2',L2,U2);
legend(p,'Discrimination','Estimation');
xl = xlim;
legend boxoff
set(gca,'FontSize',16)
box off
ylabel('Amplitude (a.u.)','FontSize',18)
set(gca,'TickDir','out')
set(gca,'XTickLabels',amplabs)
xtickangle(45)
pbaspect([2 1 1])
xlim(xl)
ylim([-1 8])

subplot(1,6,6)
p = uncertplot(18,[mean(mean(smeds(:,:,exp1),1),3) ; mean(mean(smeds(:,:,exp2),1),3)],[mean(mean(mlci(:,:,exp1),1),3) ; mean(mean(mlci(:,:,exp2),1),3)],[mean(mean(muci(:,:,exp1),1),3) ; mean(mean(muci(:,:,exp2),1),3)],1,11,1,{[0 0 0]},[{[0 0 0]} {[1 1 1]}],shapes,xlab,'jitter','1by1','E2',L2,U2);
%title('Amplitude and y-intercept group mean bootstrap medians')
set(gca,'FontSize',16)
set(gca,'YAxisLocation','right')
set(gca,'XTick',[])
box off
set(gca,'TickDir','out')
xlim([0.5 1.5])
pbaspect([1 2.4 1])
set(gcf,'Position',[100 100 600 320])

print('/Users/jakeparker/Documents/tempatten/paperfigs/figH2.svg','-dsvg')



%%
exparams = gbsall.rdE3.t1a.glm_params(:,[1:9 12 13]);
paramcolors = [regcolors{1}; regcolors{2}; regcolors{3}; regcolors{4}; regcolors{5}; regcolors{1}; regcolors{2}; regcolors{3}; regcolors{4}; regcolors{5}; regcolors{5}];

%amplitude box and whisker
figure(9)
clf
subplot(1,6,[1,2,3,4,5])
hold on
plot([0 7],[0 0],'--','color',[0.5 0.5 0.5])
xx = 1;
for pp = [1:5 11]
    bplot(exparams(:,pp),xx,'nomean','nooutliers','color',paramcolors(pp,:));
    xx = xx+1;
end
pbaspect([2 1 1])
xl = xlim;
set(gcf,'Position',[100 100 600 320])
set(gca,'FontSize',16)
box off
set(gca,'TickDir','out')
set(gcf,'Color',[1 1 1])
set(gca,'XTick',1:6)
set(gca,'XTickLabel',amplabs)
xtickangle(45)
ylabel('Amplitude (a.u.)','FontSize',18)
pbaspect([2 1 1])
ylim([-1 4])
xlim([0 7])

subplot(1,6,6)
bplot(exparams(:,11),'nomean','nooutliers','color',[0 0 0]);
xlim([0.5 1.5])
set(gca,'YAxisLocation','right')
ylim([-.01 .01])
set(gca,'FontSize',16)
box off
set(gca,'TickDir','out')
set(gcf,'Color',[1 1 1])
set(gca,'YTick',[-0.01 0 0.01])
set(gca,'XTick',[])
pbaspect([1 2.4 1])
%set(gcf,'PaperPosition',[100 100 750 300])

print('/Users/jakeparker/Documents/tempatten/paperfigs/figI.svg','-dsvg')
%saveas(gcf,'/Users/jakeparker/Documents/tempatten/paperfigs/figI.png')

%%
%yint box and whisker
% figure(10)
% bplot(exparams(:,11),'nomean','nooutliers');
% pbaspect([1 4 1])
% xlim([0.5 1.5])
% set(gca,'YAxisLocation','right')
% ylim([-.01 .01])
% set(gca,'FontSize',18)
% box off
% set(gca,'TickDir','out')
% set(gcf,'Color',[1 1 1])
% set(gca,'XTick',1)
% set(gca,'XTickLabel',xlab(11))
% 
% print('/Users/jakeparker/Documents/tempatten/paperfigs/figJ.pdf','-dpdf')
lminus = repmat([0 1000 1250 1750],100,1);

%latency and tmax box and whisker
figure(11)
clf
subplot(1,5,[1,2,3,4])
hold on
xx = 1;
for pp = 6:9
    bplot(exparams(:,pp)-lminus(:,xx),xx,'nomean','nooutliers','color',paramcolors(pp,:));
    xx = xx+1;
end 
%bplot(exparams(:,6:9)-repmat([0 1000 1250 1750],100,1),'nomean','nooutliers');
pbaspect([2 1 1])
%xl = xlim;
plot([0 5],[0 0],'--','color',[0.5 0.5 0.5])
xlim([0 5])
set(gca,'FontSize',16)
set(gca,'XTick',1:4)
set(gca,'XTickLabel',latlabs)
xtickangle(45)
ylabel('Latency relative to event (ms)','FontSize',18)

subplot(1,5,5)
bplot(exparams(:,10),'nomean','nooutliers','color',[0 0 0]);
set(gca,'YAxisLocation','right')
ylabel('Time (ms)','FontSize',18)
set(gcf,'Position',[100 100 600 320])
xlim([0.5 1.5])
ylim([500 1500])
pbaspect([1 2.5 1])
set(gca,'FontSize',16)
set(gca,'XTick',1)
set(gca,'XTickLabel','t_{max}')
xtickangle(45)
box off
set(gca,'TickDir','out')
set(gcf,'Color',[1 1 1])
pbaspect([1 2.89 1])

print('/Users/jakeparker/Documents/tempatten/paperfigs/figK.svg','-dsvg')

%%
smedmeans = squeeze(mean(smeds,1))';
smedporder = nan(size(smedmeans,1),size(smedmeans,2));


for pp = 1:size(smedmeans,2)
    
    [~,sortind] = sort(smedmeans(:,pp));
    
%      for ss = 1:10
%          
%          smedporder((2*ss)-1,pp) = sortind(ss);
%          smedporder(2*ss,pp) = sortind(ss+11);
%          
%      end
%      smedporder(21,pp) = sortind(11);

    for ss = 1:21
        smedporder(ss,pp) = sortind(ss);
    end
        
end 

sjcolors = [0.5172    0.5172    1.0000; ...
         0         0    0.1724; ...
         0    1.0000         0; ...
    1.0000         0         0; ...
    1.0000    0.1034    0.7241; ...
    1.0000    0.8276         0; ...
         0    0.3448         0; ...
         0         0    1.0000; ...
    0.6207    0.3103    0.2759; ...
         0    1.0000         0; ...
         0    0.5172    0.5862; ...
    1.0000         0         0; ...
    0.5862    0.8276    0.3103; ...
    0.9655    0.6207    0.8621; ...
    0.8276    0.0690    1.0000; ...
    0.4828    0.1034    0.4138; ...
    0.9655    0.0690    0.3793; ...
    1.0000    0.7586    0.5172; ...
    0.1379    0.1379    0.0345; ...
         0         0    1.0000; ...
    0.9655    0.5172    0.0345];
jitw = 0.7;
sjjit = linspace(0-(jitw/2),jitw/2,size(smeds,3));
condcolors = [t1colors{1}; ...
    t2colors{1}; ...
    t1colors{2}; ...
    t2colors{2}; ...
    t1colors{3}; ...
    t2colors{3}];

%amplitude and yint fits scatter
figure(12)
clf
subplot(1,6,[1,2,3,4,5])
hold on
plot([0 7],[0 0],'--','color',[0.5 0.5 0.5])
h1 = plot(10,10,'ko','MarkerFaceColor',[0 0 0]);
h2 = plot(11,11,'ko','MarkerFaceColor',[1 1 1]);
for cc = 1:size(smeds,1)
    tempparams = squeeze(smeds(cc,:,:))';
    for ss = 1:size(smeds,3)
        xx = 1;
        for pp = [1:5 11]
            if smedporder(ss,pp) < 10
                markerfacecolor = sjcolors(smedporder(ss,pp),:);
            elseif smedporder(ss,pp) >= 10
                markerfacecolor = [1 1 1];
            end
            plot(xx + sjjit(ss),tempparams(smedporder(ss,pp),pp),'o','color',sjcolors(smedporder(ss,pp),:),'MarkerFaceColor',markerfacecolor,'MarkerSize',4)
            xx = xx+1;
        end
    end
end
pbaspect([4 1 1])
ylim([-2 15])
xlim([0 7])
box off
legend([h1 h2],'Discrimination','Estimation')
legend boxoff
set(gca,'TickDir','out')
set(gcf,'Color',[1 1 1])
set(gca,'FontSize',16)
set(gca,'XTick',1:6)
set(gca,'XTickLabel',amplabs)
xtickangle(45)
%set(gcf,'Position',[100 100 800 400])
ylabel('Amplitude (a.u.)','FontSize',18)

subplot(1,6,6)
hold on
for cc = 1:size(smeds,1)
    tempparams = squeeze(smeds(cc,:,:))';
    for ss = 1:size(smeds,3)
        if smedporder(ss,11) < 10
            markerfacecolor = sjcolors(smedporder(ss,11),:);
        elseif smedporder(ss,11) >= 10
            markerfacecolor = [1 1 1];
        end
        plot(1 + sjjit(ss),tempparams(smedporder(ss,11),11),'o','color',sjcolors(smedporder(ss,11),:),'MarkerFaceColor',markerfacecolor,'MarkerSize',4)
    end
end
pbaspect([1 1.2 1])
box off
set(gca,'TickDir','out')
set(gcf,'Color',[1 1 1])
set(gca,'FontSize',16)
set(gca,'XTick',[])
%set(gca,'XTickLabel',xlab(11))
set(gcf,'Position',[100 100 1000 320])
xlim([0.5 1.5])
set(gca,'YAxisLocation','right')

print('/Users/jakeparker/Documents/tempatten/paperfigs/figL.svg','-dsvg')

% jitw = 0.4;
% condjit = linspace(0-(jitw/2),jitw/2,size(smeds,1));
% 
% figure(13)
% hold on
% for ss = 1:size(smeds,3)
%     tempparams = smeds(:,:,ss);
%     for cc = 1:size(smeds,1)
%         plot([1:5]+condjit(cc),tempparams(cc,1:5),'o','color',condcolors(cc,:),'MarkerFaceColor',condcolors(cc,:),'MarkerSize',8)
%     end
% end
% pbaspect([2 1 1])
% box off
% set(gca,'TickDir','out')
% set(gcf,'Color',[1 1 1])
% set(gca,'FontSize',18)
% set(gca,'XTick',1:5)
% set(gca,'XTickLabel',xlab(1:5))

%%
%latency fits scatter
figure(13)
clf
subplot(1,5,[1,2,3,4])
hold on
plot([0 5],[0 0],'--','color',[0.5 0.5 0.5])
for cc = 1:size(smeds,1)
    tempparams = squeeze(smeds(cc,:,:))';
    for ss = 1:size(smeds,3)
        xx = 1;
        for pp = 6:9
            if smedporder(ss,pp) < 10
                markerfacecolor = sjcolors(smedporder(ss,pp),:);
            elseif smedporder(ss,pp) >= 10
                markerfacecolor = [1 1 1];
            end
            plot(xx + sjjit(ss),tempparams(smedporder(ss,pp),pp),'o','color',sjcolors(smedporder(ss,pp),:),'MarkerFaceColor',markerfacecolor,'MarkerSize',4)
            xx = xx+1;
        end
    end
end
pbaspect([4 1 1])
box off
set(gca,'TickDir','out')
set(gcf,'Color',[1 1 1])
set(gca,'FontSize',16)
set(gca,'XTick',1:4)
set(gca,'XTickLabel',latlabs)
xtickangle(45)
%set(gcf,'Position',[100 100 800 400])
ylabel('Latency relative to event (ms)','FontSize',18)
ylim([-500 500])

subplot(1,5,5)
hold on
for cc = 1:size(smeds,1)
    tempparams = squeeze(smeds(cc,:,:))';
    for ss = 1:size(smeds,3)
        if smedporder(ss,10) < 10
            markerfacecolor = sjcolors(smedporder(ss,10),:);
        elseif smedporder(ss,10) >= 10
            markerfacecolor = [1 1 1];
        end
        plot(1 + sjjit(ss),tempparams(smedporder(ss,10),10),'o','color',sjcolors(smedporder(ss,10),:),'MarkerFaceColor',markerfacecolor,'MarkerSize',4)
    end
end
pbaspect([1 1.24 1])
box off
set(gca,'TickDir','out')
set(gcf,'Color',[1 1 1])
set(gca,'FontSize',16)
set(gca,'XTick',1)
set(gca,'XTickLabel','t_{max}')
xtickangle(45)
ylabel('Time (ms)')
set(gcf,'Position',[100 100 1000 320])
xlim([0.5 1.5])
set(gca,'YAxisLocation','right')


print('/Users/jakeparker/Documents/tempatten/paperfigs/figM.svg','-dsvg')

%%
%yint fits scatter
figure(14)
hold on
for cc = 1:size(smeds,1)
    tempparams = squeeze(smeds(cc,:,:))';
    for ss = 1:size(smeds,3)
        plot(1 + sjjit(ss),tempparams(ss,11),'o','color',sjcolors(ss,:),'MarkerFaceColor',sjcolors(ss,:),'MarkerSize',8)
    end
end
pbaspect([1 4 1])
box off
set(gca,'TickDir','out')
set(gcf,'Color',[1 1 1])
set(gca,'FontSize',18)
set(gca,'XTick',1)
set(gca,'XTickLabel',xlab(11))
%set(gcf,'Position',[100 100 800 400])
xlim([0.5 1.5])
set(gca,'YAxisLocation','right')

print('/Users/jakeparker/Documents/tempatten/paperfigs/figN.pdf','-dpdf')

%tmax fits scatter
figure(15)
hold on
for cc = 1:size(smeds,1)
    tempparams = squeeze(smeds(cc,:,:))';
    for ss = 1:size(smeds,3)
        plot(1 + sjjit(ss),tempparams(ss,10),'o','color',sjcolors(ss,:),'MarkerFaceColor',sjcolors(ss,:),'MarkerSize',8)
    end
end
pbaspect([1 4 1])
box off
set(gca,'TickDir','out')
set(gcf,'Color',[1 1 1])
set(gca,'FontSize',18)
set(gca,'XTick',1)
set(gca,'XTickLabel',xlab(10))
%set(gcf,'Position',[100 100 800 400])
xlim([0.5 1.5])
set(gca,'YAxisLocation','right')

print('/Users/jakeparker/Documents/tempatten/paperfigs/figO.pdf','-dpdf')
