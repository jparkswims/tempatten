dataDir = '/Users/jakeparker/Google Drive/TA_Pupil/Data/gbs_plot_work.mat';
load(dataDir)

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

regcolors = [ppcuecolors{1}; t1colors{1}; t2colors{1}; ppcuecolors{2}; {[0 0 0]}; {[0 0 0]}];
markercolors = [regcolors [{[1 1 1]}; {[1 1 1]}; {[1 1 1]}; {[1 1 1]}; {[1 1 1]}; {[1 1 1]}]];
shapes = {'o','o'};

amplabs = {'precue','T1','T2','resp. cue','decision','y-intercept'};
latlabs = {'precue','T1','T2','resp. cue','t_max'};

sems = ste(smeds,0,3);
L2 = (-1).*sems;
U2 = sems;

figure(1)
clf
%latency and tmax group mean bootstrap medians by experiment
subplot(1,5,[1,2,3,4])
p = uncertplot(1,[mean(mean(smeds(:,:,exp1),1),3) ; mean(mean(smeds(:,:,exp2),1),3)],[mean(mean(mlci(:,:,exp1),1),3) ; mean(mean(mlci(:,:,exp2),1),3)],[mean(mean(muci(:,:,exp1),1),3) ; mean(mean(muci(:,:,exp2),1),3)],1,6:9,1,regcolors,markercolors,shapes,xlab,'jitter','1by1','E2',L2,U2);
set(gca,'FontSize',14)
box off
ylabel('Latency relative to event (ms)','FontSize',18)
set(gca,'TickDir','out')
hold on
plot([0 5],[0 0],'--','color',[0.5 0.5 0.5])
pbaspect([2 1 1])
set(gca,'XTickLabel',latlabs)
xtickangle(45)


subplot(1,5,5)
p = uncertplot(1,[mean(mean(smeds(:,:,exp1),1),3) ; mean(mean(smeds(:,:,exp2),1),3)],[mean(mean(mlci(:,:,exp1),1),3) ; mean(mean(mlci(:,:,exp2),1),3)],[mean(mean(muci(:,:,exp1),1),3) ; mean(mean(muci(:,:,exp2),1),3)],1,10,1,{[0 0 0]},[{[0 0 0]} {[1 1 1]}],shapes,xlab,'jitter','1by1','E2',L2,U2);
set(gca,'FontSize',14)
set(gca,'YAxisLocation','right')
ylabel('Time (ms)','FontSize',18)
box off
set(gca,'TickDir','out')
ylim([500 1500])
xlim([0.5 1.5])
pbaspect([1 2.58 1])
set(gca,'XTickLabel','t_max')
xtickangle(45)
set(gcf,'Position',[100 100 600 300])

print('/Users/jakeparker/Documents/tempatten/paperfigs/figH.pdf','-dpdf')