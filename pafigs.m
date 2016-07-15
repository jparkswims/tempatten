function [] = pafigs(t1,t2,n,postcue,t2time,window,subjects,filedir)

close all

for j = 1:length(subjects)
    
    ymin = -0.3;
    ymax = 0.3;
    
   figure
    subplot(3,1,1)
    plot(window(1):window(2),t1.(subjects{j}),'color',[.7 .7 .75])
    hold on
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    plot(window(1):window(2),t1.smeans(j,:),'b','LineWidth',3)
    title([subjects{j} ' t1 normalized'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    ylim([-0.3 0.3])
    
    subplot(3,1,2)
    plot(window(1):window(2),t2.(subjects{j}),'color',[.75 .7 .7])
    hold on
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    plot(window(1):window(2),t2.smeans(j,:),'r','LineWidth',3)
    title([subjects{j} ' t2 normalized'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    ylim([-0.3 0.3])
    
    subplot(3,1,3)
    plot(window(1):window(2),n.(subjects{j}),'color',[.7 .75 .7])
    hold on
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    plot(window(1):window(2),n.smeans(j,:),'g','LineWidth',3)
    title([subjects{j} ' neutral normalized'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    ylim([-0.3 0.3]) 
    
    figure
    plot(window(1):window(2),t1.smeans(j,:),'b')
    hold on
    plot(window(1):window(2),t2.smeans(j,:),'r')
    plot(window(1):window(2),n.smeans(j,:),'g')
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    title([subjects{j} ' all conditions'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    legend('t1','t2','neutral')
    
    ymin = -0.02;
    ymax = 0.02;
    
    figure
    plot(window(1):window(2),t1.sdetmeans(j,:),'b')
    hold on
    plot(window(1):window(2),t2.sdetmeans(j,:),'r')
    plot(window(1):window(2),n.sdetmeans(j,:),'g')
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    title([subjects{j} ' all conditions detrended'])
    xlabel('time (ms)')
    ylabel('pupil area (detrended)')
    legend('t1','t2','neutral')
    
    figdir = [filedir '/' subjects{j}];
    
    fig = [1 2 3];
    
    fignames = {'conditions' 'all_conditions' 'all_conditions_det'};
    
    figprefix = 'ta';
    
    rd_saveAllFigs(fig,fignames,figprefix, figdir)
    
    close all
    
end

ymin = -0.1;
ymax = 0.3;

figure
subplot(3,1,1)
plot(window(1):window(2), t1.smeans)
hold on
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
plot(window(1):window(2), t2.smeans)
hold on
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
plot(window(1):window(2), n.smeans)
hold on
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

figure
shadedErrorBar(window(1):window(2),t1.gmean,t1.se,'b',1) 
hold on
shadedErrorBar(window(1):window(2),t2.gmean,t2.se,'r',1) 
shadedErrorBar(window(1):window(2),n.gmean,n.se,'g',1)
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('group averages (b=t1, r=t2, and g=neutral)')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
ylim([-0.05 0.25])

ymin = -0.02;
ymax = 0.02;

figure
subplot(3,1,1)
plot(window(1):window(2), t1.sdetmeans)
hold on
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('t1 subject averages of detrended data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
%legend('ad','bl','ec','ty','vp','zw')
ylim([-0.02 0.02])

subplot(3,1,2)
plot(window(1):window(2), t2.sdetmeans)
hold on
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('t2 subject averages of detrended data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
%legend('ad','bl','ec','ty','vp','zw')
ylim([-0.02 0.02])

subplot(3,1,3)
plot(window(1):window(2), n.sdetmeans)
hold on
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('neutral subject averages of detrended data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
%legend('ad','bl','ec','ty','vp','zw')
ylim([-0.02 0.02])

figure
shadedErrorBar(window(1):window(2),t1.gdetmean,t1.detse,'b',1) %%%%
hold on
shadedErrorBar(window(1):window(2),t2.gdetmean,t2.detse,'r',1) %%%%
shadedErrorBar(window(1):window(2),n.gdetmean,n.detse,'g',1) %%%%
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('group averages det (b=t1, r=t2, and g=neutral)')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
ylim([-0.015 0.015])

figdir = filedir;
fig = [1 2 3 4];
fignames = {'subject_avgs' 'group_avgs' 'subject_avgs_det' 'group_avgs_det'};
figprefix = 'ta';

rd_saveAllFigs(fig,fignames,figprefix, figdir)
