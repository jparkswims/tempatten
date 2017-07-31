% pa_special_plot
set(0,'DefaultFigureColormap',viridis)
load E0E3tvc.mat

model = 1;

cuecolors = {
    [85 196 154]./255
    [157 16 196]./255};

t1colors = {
    [112 169 249]./255
    [60 139 247]./255
    [29 67 120]./255};

t2colors = {
    [249 129 121]./255
    [247 73 61]./255
    [120 35 30]./255};

smean = pa_tvc.t1vc.smeans(10,301:end);

figure(1)
fill([-200 0 0 -200],[-0.02 -0.02 0.12 0.12],[0.75 0.75 0.75])
hold on
plot(-200:pa_tvc.window(2),smean,'LineWidth',2)
plotlines(pa_tvc.locs,ylim)
xlabel('Time (ms)','FontSize',16)
ylabel('Pupil Size (normalized)','FontSize',16)
pbaspect([2 1 1])
xlim([-200 pa_tvc.window(2)])
set(gca,'TickDir','out')
box off
% set(gca,'XTickLabel',{'Precue' 'T1' 'T2' 'Postcue'})
%%
h = hpupil(pa_tvc.window(1):pa_tvc.window(2),10.1,930,0,'max');

figure(2)
plot(pa_tvc.window(1):pa_tvc.window(2),h,'k','LineWidth',2)
hold on
plot(pa_tvc.window(1):pa_tvc.window(2),h./2,'k','LineWidth',2)
plot(xlim,[0.01 0.01],'--k')
plot(xlim,[0.005 0.005],'--k')
pbaspect([2 1 1])
ylim([-0.002 0.012])
xlabel('Time (ms)','FontSize',16)
% plotlines(0,ylim)
set(gca,'YTick',[])
set(gca,'TickDir','out')
box off

h2 = hpupil(pa_tvc.window(1):pa_tvc.window(2),10.1,930,500,'max');
h2(h2==0) = [];

h(h==0) = [];
h(2501:end) = [];

figure(7)
plot(1:2500,h,'k','LineWidth',2)
hold on
plot(501:pa_tvc.window(2),h2,'k','LineWidth',2)
pbaspect([2 1 1])
ylim([-0.002 0.012])
xlim([-500 3500])
xlabel('Time (ms)','FontSize',16)
plotlines(-200,ylim)
% plotlines(0,ylim)
set(gca,'YTick',[])
set(gca,'TickDir','out')
box off
%%
t1allmeans = nan(length(pa_tvc.subjects),length(pa_tvc.fields)/2);
t2allmeans = nan(length(pa_tvc.subjects),length(pa_tvc.fields)/2);
t1ind = find(strcmp(pa_tvc.loclabels,'t1'));
t2ind = find(strcmp(pa_tvc.loclabels,'t2'));

ind = strfind(pa_tvc.fields, 't1');
ind = find(not(cellfun('isempty', ind)));
x = 0;

for f = ind'
    
    x = x+1;
    t1allmeans(:,x) = pa_tvc.(pa_tvc.fields{f}).models(model).locations(:,t1ind);
    t2allmeans(:,x) = pa_tvc.(pa_tvc.fields{f+1}).models(model).locations(:,t2ind);
    
end

t1means = mean(t1allmeans,2);
t2means = mean(t2allmeans,2);
t1ste = ste(t1means,0,1);
t2ste = ste(t2means,0,1);

t1bar = round(mean(t1means)*100)/100;
t2bar = round(mean(t2means)*100)/100;

[~,pt1] = ttest(t1means,pa_tvc.locs(t1ind));
[~,pt2] = ttest(t2means,pa_tvc.locs(t2ind));

figure(3)
subplot(2,1,1)
hold on
fill([mean(t1means)-t1ste mean(t1means)+t1ste mean(t1means)+t1ste mean(t1means)-t1ste],[-0.1 -0.1 0.1 0.1],[0.5 0.5 0.5])
fill([mean(t2means)-t2ste mean(t2means)+t2ste mean(t2means)+t2ste mean(t2means)-t2ste],[-0.1 -0.1 0.1 0.1],[0.5 0.5 0.5])
% herrorbar([mean(t1means) mean(t2means)],[0 0],[t1ste t2ste],'.k')
plot([mean(t1means) mean(t1means)],[-0.1 0.1],'k','LineWidth',2)
plot([mean(t2means) mean(t2means)],[-0.1 0.1],'k','LineWidth',2)
xlim([600 1400])
ylim([-0.6 0.6])
plotlines([1000 1250],ylim)
xlabel('Time (ms)')
% set(gca,'XTick',[t1bar 1000 1250 t2bar])
set(gca,'YTick',[])
% set(gca,'XTickLabel',{'Model T1' 'Task T1' 'Task T2' 'Model T2'})
pbaspect([4 1 1])
% title('T1 and T2 Pupil Response Locations')

% ind = strfind(pa_tvc.fields, 'vc');
% ind = find(not(cellfun('isempty', ind)));
% 
% t1allvmeans = nan(length(pa_tvc.subjects),length(pa_tvc.fields)/6);
% t2allvmeans = nan(length(pa_tvc.subjects),length(pa_tvc.fields)/6);
% 
% x = 0;
% 
% for f = ind'
%     
%     x = x+1;
%     t1allvmeans(:,x) = pa_tvc.(pa_tvc.fields{f}).models(model).locations(:,t1ind);
%     t2allvmeans(:,x) = pa_tvc.(pa_tvc.fields{f}).models(model).locations(:,t2ind);
%     
% end
% 
% ind = strfind(pa_tvc.fields, 'nc');
% ind = find(not(cellfun('isempty', ind)));
% 
% t1allnmeans = nan(length(pa_tvc.subjects),length(pa_tvc.fields)/6);
% t2allnmeans = nan(length(pa_tvc.subjects),length(pa_tvc.fields)/6);
% 
% x = 0;
% 
% for f = ind'
%     
%     x = x+1;
%     t1allnmeans(:,x) = pa_tvc.(pa_tvc.fields{f}).models(model).locations(:,t1ind);
%     t2allnmeans(:,x) = pa_tvc.(pa_tvc.fields{f}).models(model).locations(:,t2ind);
%     
% end
% 
% ind = strfind(pa_tvc.fields, 'ic');
% ind = find(not(cellfun('isempty', ind)));
% 
% t1allimeans = nan(length(pa_tvc.subjects),length(pa_tvc.fields)/6);
% t2allimeans = nan(length(pa_tvc.subjects),length(pa_tvc.fields)/6);
% 
% x = 0;
% 
% for f = ind'
%     
%     x = x+1;
%     t1allimeans(:,x) = pa_tvc.(pa_tvc.fields{f}).models(model).locations(:,t1ind);
%     t2allimeans(:,x) = pa_tvc.(pa_tvc.fields{f}).models(model).locations(:,t2ind);
%     
% end

t1vcmeans = pa_tvc.t1vc.models(model).locations(:,t1ind);
t2vcmeans = pa_tvc.t2vc.models(model).locations(:,t2ind);
t1ncmeans = pa_tvc.t1nc.models(model).locations(:,t1ind);
t2ncmeans = pa_tvc.t2nc.models(model).locations(:,t2ind);
t1icmeans = pa_tvc.t1ic.models(model).locations(:,t1ind);
t2icmeans = pa_tvc.t2ic.models(model).locations(:,t2ind);

t1vste = ste(t1vcmeans,0,1);
t2vste = ste(t2vcmeans,0,1);
t1nste = ste(t1ncmeans,0,1);
t2nste = ste(t2ncmeans,0,1);
t1iste = ste(t1icmeans,0,1);
t2iste = ste(t2icmeans,0,1);

subplot(2,1,2)
hold on
fill([mean(t1vcmeans)-t1vste mean(t1vcmeans)+t1vste mean(t1vcmeans)+t1vste mean(t1vcmeans)-t1vste],[0.3 0.3 0.5 0.5],t1colors{1})
fill([mean(t1ncmeans)-t1nste mean(t1ncmeans)+t1nste mean(t1ncmeans)+t1nste mean(t1ncmeans)-t1nste],[-0.1 -0.1 0.1 0.1],t1colors{2})
fill([mean(t1icmeans)-t1iste mean(t1icmeans)+t1iste mean(t1icmeans)+t1iste mean(t1icmeans)-t1iste],[-0.5 -0.5 -0.3 -0.3],t1colors{3})
fill([mean(t2vcmeans)-t2vste mean(t2vcmeans)+t2vste mean(t2vcmeans)+t2vste mean(t2vcmeans)-t2vste],[0.3 0.3 0.5 0.5],t2colors{1})
fill([mean(t2ncmeans)-t2nste mean(t2ncmeans)+t2nste mean(t2ncmeans)+t2nste mean(t2ncmeans)-t2nste],[-0.1 -0.1 0.1 0.1],t2colors{2})
fill([mean(t2icmeans)-t2iste mean(t2icmeans)+t2iste mean(t2icmeans)+t2iste mean(t2icmeans)-t2iste],[-0.5 -0.5 -0.3 -0.3],t2colors{3})
plot([mean(t1vcmeans) mean(t1vcmeans)],[0.3 0.5],'k','LineWidth',2)
plot([mean(t1ncmeans) mean(t1ncmeans)],[-0.1 0.1],'k','LineWidth',2)
plot([mean(t1icmeans) mean(t1icmeans)],[-0.5 -0.3],'k','LineWidth',2)
plot([mean(t2vcmeans) mean(t2vcmeans)],[0.3 0.5],'k','LineWidth',2)
plot([mean(t2ncmeans) mean(t2ncmeans)],[-0.1 0.1],'k','LineWidth',2)
plot([mean(t2icmeans) mean(t2icmeans)],[-0.5 -0.3],'k','LineWidth',2)
% herrorbar([mean(t1vcmeans) mean(t2vcmeans)],[0.2 0.2],[t1vste t2vste],'.b')
% herrorbar([mean(t1ncmeans) mean(t2ncmeans)],[0 0],[t1nste t2nste],'.g')
% herrorbar([mean(t1icmeans) mean(t2icmeans)],[-0.2 -0.2],[t1iste t2iste],'.r')
ylim([-0.6 0.6])
xlim([600 1400])
plotlines([1000 1250],ylim)
xlabel('Time (ms)')
set(gca,'YTick',[])
pbaspect([4 1 1])
% title('T1 and T2 Pupil Response Locations')
% legend('T1 Valid','T1 Neutral','T1 Invalid','T2 Valid','T2 Neutral','T2 Invalid','Location','Best')


[B, Blocs, tmax, yint, ~, Y] = glm_optim2(pa_tvc.t1vc.smeans(10,:),...
    pa_tvc.window,...
    pa_tvc.models(model).B,...
    [pa_tvc.models(model).Blocs [0 round(pa_tvc.dectime(10))]],...
    pa_tvc.models(model).Blocbounds,...
    pa_tvc.models(model).Btypes,...
    pa_tvc.models(model).Blabels,...
    pa_tvc.models(model).Bbounds,...
    pa_tvc.models(model).tmax,...
    pa_tvc.models(model).tmaxbounds,...
    pa_tvc.models(model).yint,...
    pa_tvc.models(model).params,...
    'max');
[~, X] = glm_calc(pa_tvc.window,B,Blocs,{'stick' 'stick' 'stick' 'stick' 'box'},tmax,yint,'max');
%X(end,:) = [];
figure(5)
fill([-200 0 0 -200],[-0.02 -0.02 0.12 0.12],[0.75 0.75 0.75])
hold on
plot(-200:pa_tvc.window(2),smean,'LineWidth',2)
plot(0:pa_tvc.window(2),X(1,:),'color',cuecolors{1},'LineWidth',2)
plotlines(pa_tvc.locs,ylim)
xlabel('Time (ms)','FontSize',16)
ylabel('Pupil Size (normalized)','FontSize',16)
pbaspect([2 1 1])
xlim([-200 pa_tvc.window(2)])
set(gca,'TickDir','out')
box off

figure(8)
fill([-200 0 0 -200],[-0.02 -0.02 0.12 0.12],[0.75 0.75 0.75])
hold on
plot(-200:pa_tvc.window(2),smean,'LineWidth',2)
plot(0:pa_tvc.window(2),X(1,:),'color',cuecolors{1},'LineWidth',2)
plot(0:pa_tvc.window(2),X(2,:),'color',t1colors{2},'LineWidth',2)
plotlines(pa_tvc.locs,ylim)
xlabel('Time (ms)','FontSize',16)
ylabel('Pupil Size (normalized)','FontSize',16)
pbaspect([2 1 1])
xlim([-200 pa_tvc.window(2)])
set(gca,'TickDir','out')
box off

figure(9)
fill([-200 0 0 -200],[-0.02 -0.02 0.12 0.12],[0.75 0.75 0.75])
hold on
plot(-200:pa_tvc.window(2),smean,'LineWidth',2)
plot(0:pa_tvc.window(2),X(1,:),'color',cuecolors{1},'LineWidth',2)
plot(0:pa_tvc.window(2),X(2,:),'color',t1colors{2},'LineWidth',2)
plot(0:pa_tvc.window(2),X(3,:),'color',t2colors{2},'LineWidth',2)
plotlines(pa_tvc.locs,ylim)
xlabel('Time (ms)','FontSize',16)
ylabel('Pupil Size (normalized)','FontSize',16)
pbaspect([2 1 1])
xlim([-200 pa_tvc.window(2)])
set(gca,'TickDir','out')
box off

figure(10)
fill([-200 0 0 -200],[-0.02 -0.02 0.12 0.12],[0.75 0.75 0.75])
hold on
plot(-200:pa_tvc.window(2),smean,'LineWidth',2)
plot(0:pa_tvc.window(2),X(1,:),'color',cuecolors{1},'LineWidth',2)
plot(0:pa_tvc.window(2),X(2,:),'color',t1colors{2},'LineWidth',2)
plot(0:pa_tvc.window(2),X(3,:),'color',t2colors{2},'LineWidth',2)
plot(0:pa_tvc.window(2),X(4,:),'color',cuecolors{2},'LineWidth',2)
plotlines(pa_tvc.locs,ylim)
xlabel('Time (ms)','FontSize',16)
ylabel('Pupil Size (normalized)','FontSize',16)
pbaspect([2 1 1])
xlim([-200 pa_tvc.window(2)])
set(gca,'TickDir','out')
box off

figure(11)
fill([-200 0 0 -200],[-0.02 -0.02 0.12 0.12],[0.75 0.75 0.75])
hold on
plot(-200:pa_tvc.window(2),smean,'LineWidth',2)
plot(0:pa_tvc.window(2),X(1,:),'color',cuecolors{1},'LineWidth',2)
plot(0:pa_tvc.window(2),X(2,:),'color',t1colors{2},'LineWidth',2)
plot(0:pa_tvc.window(2),X(3,:),'color',t2colors{2},'LineWidth',2)
plot(0:pa_tvc.window(2),X(4,:),'color',cuecolors{2},'LineWidth',2)
plot(0:pa_tvc.window(2),X(5,:),'k','LineWidth',2)
plot(0:pa_tvc.window(2),Y,'color',[0.5 0.5 0.5],'LineWidth',2,'LineStyle','--')
plotlines(pa_tvc.locs,ylim)
xlabel('Time (ms)','FontSize',16)
ylabel('Pupil Size (normalized)','FontSize',16)
pbaspect([2 1 1])
xlim([-200 pa_tvc.window(2)])
set(gca,'TickDir','out')
box off

%%
figure(12)
hold on
ylim([-1 1])
plotlines(pa_tvc.locs,ylim)
pbaspect([6 1 1])
xlabel('Time (ms)','FontSize',16)
set(gca,'YTick',[])
xlim([-200 2000])
set(gca,'TickDir','out')
set(gca,'XTick',0:250:2000)
box off

figure(13)
plot(1:2500,h,'k','LineWidth',2)
ylim([0 0.012])
xlabel('Time (ms)','FontSize',16)
set(gca,'TickDir','out')
set(gca,'YTick',[])
pbaspect([2 1 1])
box off


% plot(0:pa_tvc.window(2),Y,'color',[0.5 0.5 0.5],'LineWidth',2,'LineStyle','--')


fig = [1:3 5 7:13];
figdir = '/Users/jakeparker/Documents/tempatten';
fignames = {'fig1' 'fig2' 'fig3' 'fig5' 'fig7' 'fig8' 'fig9' 'fig10' 'fig11' 'fig12' 'fig13'};
figprefix = 'urc';

rd_saveAllFigs(fig,fignames,figprefix, figdir)
