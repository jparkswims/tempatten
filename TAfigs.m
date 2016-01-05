t1gmean = t1normwm; % m: nanmean(nanmean(t1norm),3) wm: t1normwm
t2gmean = t2normwm; % m: nanmean(nanmean(t2norm),3) wm: t2normwm
ngmean = neutralnormwm; % m :nanmean(nanmean(neutralnorm),3)    wm: neutralnormwm

t1se = nanstd(nanmean(t1norm),0,3)/sqrt(numel(subjects)); % std: nanstd(nanmean(t1norm),0,3)   wstd: wstd(squeeze(nanmean(t1norm))',t1normwm,countt1)
t2se = nanstd(nanmean(t2norm),0,3)/sqrt(numel(subjects)); % std: nanstd(nanmean(t2norm),0,3)   wstd: wstd(squeeze(nanmean(t2norm))',t2normwm,countt2)
nse = nanstd(nanmean(neutralnorm),0,3)/sqrt(numel(subjects)); % std: nanstd(nanmean(neutralnorm),0,3)  wstd: wstd(squeeze(nanmean(neutralnorm))',neutralnormwm,countn)

for j = 1:length(subjects)
    
    ymin = min(min(trialmat(:,:,j)));
    ymax = max(max(trialmat(:,:,j)));

    %individual subject conditions raw data
    figure
    subplot(3,1,1)
    plot(window(1):window(2),t1(:,:,j),'color',[.7 .7 .75])
    hold on
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    plot(window(1):window(2),nanmean(t1(:,:,j)),'b','LineWidth',3)
    title([subjects{j} ' t1'])
    xlabel('time (ms)')
    ylabel('pupil area')
    
    subplot(3,1,2)
    plot(window(1):window(2),t2(:,:,j),'color',[.75 .7 .7])
    hold on
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    plot(window(1):window(2),nanmean(t2(:,:,j)),'r','LineWidth',3)
    title([subjects{j} ' t2'])
    xlabel('time (ms)')
    ylabel('pupil area')
    
    subplot(3,1,3)
    plot(window(1):window(2),neutral(:,:,j),'color',[.7 .75 .7])
    hold on
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    plot(window(1):window(2),nanmean(neutral(:,:,j)),'g','LineWidth',3)
    title([subjects{j} ' neutral'])
    xlabel('time (ms)')
    ylabel('pupil area')
    
    ymin = -0.3;
    ymax = 0.3;
    
    %individual subject conditions normalized data
    figure
    subplot(3,1,1)
    plot(window(1):window(2),t1norm(:,:,j),'color',[.7 .7 .75])
    hold on
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    plot(window(1):window(2),nanmean(t1norm(:,:,j)),'b','LineWidth',3)
    title([subjects{j} ' t1 normalized'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    ylim([-0.3 0.3])
    
    subplot(3,1,2)
    plot(window(1):window(2),t2norm(:,:,j),'color',[.75 .7 .7])
    hold on
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    plot(window(1):window(2),nanmean(t2norm(:,:,j)),'r','LineWidth',3)
    title([subjects{j} ' t2 normalized'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    ylim([-0.3 0.3])
    
    subplot(3,1,3)
    plot(window(1):window(2),neutralnorm(:,:,j),'color',[.7 .75 .7])
    hold on
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    plot(window(1):window(2),nanmean(neutralnorm(:,:,j)),'g','LineWidth',3)
    title([subjects{j} ' neutral normalized'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    ylim([-0.3 0.3])
    
    ymin = -0.1;
    ymax = 0.3;
    
    figure
    plot(window(1):window(2),nanmean(t1norm(:,:,j)),'b')
    hold on
    plot(window(1):window(2),nanmean(t2norm(:,:,j)),'r')
    plot(window(1):window(2),nanmean(neutralnorm(:,:,j)),'g')
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    title([subjects{j} ' all conditions'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    legend('t1','t2','neutral')
    
    figdir = [filedir '/' subjects{j}];
    
    fig = [3*j-2 3*j-1 3*j];
    
    fignames = {'conditions' 'conditions_norm' 'all conditions'};
    
    figprefix = 'ta';
    
    rd_saveAllFigs(fig,fignames,figprefix, figdir)
    
end

ymin = -0.1;
ymax = 0.3;

%subject means
figure
subplot(3,1,1)
plot(window(1):window(2), squeeze(nanmean(t1norm)))
% plot(window(1):window(2),nanmean(t1norm(:,:,1)),'b')
hold on
% plot(window(1):window(2),nanmean(t1norm(:,:,2)),'c')
% plot(window(1):window(2),nanmean(t1norm(:,:,3)),'g')
% plot(window(1):window(2),nanmean(t1norm(:,:,4)),'m')
% plot(window(1):window(2),nanmean(t1norm(:,:,5)),'r')
% plot(window(1):window(2),nanmean(t1norm(:,:,6)),'y')
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('t1 subject averages of normalized data')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
%legend('ad','bl','ec','ty','vp','zw')
ylim([-0.1 0.3])

subplot(3,1,2)
plot(window(1):window(2), squeeze(nanmean(t2norm)))
hold on
% plot(window(1):window(2),nanmean(t2norm(:,:,1)),'b')
% hold on
% plot(window(1):window(2),nanmean(t2norm(:,:,2)),'c')
% plot(window(1):window(2),nanmean(t2norm(:,:,3)),'g')
% plot(window(1):window(2),nanmean(t2norm(:,:,4)),'m')
% plot(window(1):window(2),nanmean(t2norm(:,:,5)),'r')
% plot(window(1):window(2),nanmean(t2norm(:,:,6)),'y')
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('t2 subject averages of normalized data')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
%legend('ad','bl','ec','ty','vp','zw')
ylim([-0.1 0.3])

subplot(3,1,3)
plot(window(1):window(2), squeeze(nanmean(neutralnorm)))
hold on
% plot(window(1):window(2),nanmean(neutralnorm(:,:,1)),'b')
% hold on
% plot(window(1):window(2),nanmean(neutralnorm(:,:,2)),'c')
% plot(window(1):window(2),nanmean(neutralnorm(:,:,3)),'g')
% plot(window(1):window(2),nanmean(neutralnorm(:,:,4)),'m')
% plot(window(1):window(2),nanmean(neutralnorm(:,:,5)),'r')
% plot(window(1):window(2),nanmean(neutralnorm(:,:,6)),'y')
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('neutral subject averages of normalized data')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
%legend('ad','bl','ec','ty','vp','zw')
ylim([-0.1 0.3])

ymin = -0.05;
ymax = 0.25;

%group means
figure
shadedErrorBar(window(1):window(2),t1normwm,wstd(flipud(rot90(squeeze(nanmean(t1norm)))),t1normwm,countt1)/sqrt(numel(subjects)),'b',1) %%%%%
hold on
shadedErrorBar(window(1):window(2),t2normwm,wstd(flipud(rot90(squeeze(nanmean(t2norm)))),t2normwm,countt2)/sqrt(numel(subjects)),'r',1) %%%%
shadedErrorBar(window(1):window(2),neutralnormwm,wstd(flipud(rot90(squeeze(nanmean(neutralnorm)))),neutralnormwm,countn)/sqrt(numel(subjects)),'g',1) %%%%
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('group averages (b=t1, r=t2, and g=neutral)')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
ylim([-0.05 0.25])

figdir = filedir;
fig = [3*j+1 3*j+2];
fignames = {'subject_avgs' 'group_avgs'};
figprefix = 'ta';

rd_saveAllFigs(fig,fignames,figprefix, figdir)