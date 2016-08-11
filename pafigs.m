function pafigs(a,n,u,pa,filedir)

close all

for j = 1:length(pa.subjects)
    
    ymin = -0.3;
    ymax = 0.3;
    
   figure
    subplot(3,1,1)
    plot(pa.window(1):pa.window(2),a.(pa.subjects{j}),'color',[.7 .7 .75])
    hold on
    plotlines(pa.locs,[ymin ymax])
    plot(pa.window(1):pa.window(2),a.smeans(j,:),'b','LineWidth',3)
    title([pa.subjects{j} ' attend normalized'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    ylim([ymin ymax])
    
    subplot(3,1,2)
    plot(pa.window(1):pa.window(2),u.(pa.subjects{j}),'color',[.75 .7 .7])
    hold on
    plotlines(pa.locs,[ymin ymax])
    plot(pa.window(1):pa.window(2),u.smeans(j,:),'r','LineWidth',3)
    title([pa.subjects{j} ' unattend normalized'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    ylim([ymin ymax])
    
    subplot(3,1,3)
    plot(pa.window(1):pa.window(2),n.(pa.subjects{j}),'color',[.7 .75 .7])
    hold on
    plotlines(pa.locs,[ymin ymax])
    plot(pa.window(1):pa.window(2),n.smeans(j,:),'g','LineWidth',3)
    title([pa.subjects{j} ' neutral normalized'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    ylim([ymin ymax]) 
    
    figure
    plot(pa.window(1):pa.window(2),a.smeans(j,:),'b')
    hold on
    plot(pa.window(1):pa.window(2),u.smeans(j,:),'r')
    plot(pa.window(1):pa.window(2),n.smeans(j,:),'g')
    plotlines(pa.locs,[ymin ymax])
    title([pa.subjects{j} ' all conditions'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    legend('a','u','n')
    
    ymin = -0.02;
    ymax = 0.02;
    
    figure
    plot(pa.window(1):pa.window(2),a.sdetmeans(j,:),'b')
    hold on
    plot(pa.window(1):pa.window(2),u.sdetmeans(j,:),'r')
    plot(pa.window(1):pa.window(2),n.sdetmeans(j,:),'g')
    plotlines(pa.locs,[ymin ymax])
    title([pa.subjects{j} ' all conditions detrended'])
    xlabel('time (ms)')
    ylabel('pupil area (detrended)')
    legend('a','u','n')
    
    figdir = [filedir '/' pa.subjects{j}];
    
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
plot(pa.window(1):pa.window(2), a.smeans)
hold on
plotlines(pa.locs,[ymin ymax])
title('attend subject averages of normalized data')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
ylim([ymin ymax])

subplot(3,1,2)
plot(pa.window(1):pa.window(2), u.smeans)
hold on
plotlines(pa.locs,[ymin ymax])
title('unattend subject averages of normalized data')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
ylim([ymin ymax])

subplot(3,1,3)
plot(pa.window(1):pa.window(2), n.smeans)
hold on
plotlines(pa.locs,[ymin ymax])
title('neutral subject averages of normalized data')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
ylim([ymin ymax])

ymin = -0.05;
ymax = 0.25;

figure
shadedErrorBar(pa.window(1):pa.window(2),a.gmean,a.se,'b',1) 
hold on
shadedErrorBar(pa.window(1):pa.window(2),u.gmean,u.se,'r',1) 
shadedErrorBar(pa.window(1):pa.window(2),n.gmean,n.se,'g',1)
plotlines(pa.locs,[ymin ymax])
title('group averages (b=atten, r=unatten, and g=neutral)')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
ylim([ymin ymax])

ymin = -0.02;
ymax = 0.02;

figure
subplot(3,1,1)
plot(pa.window(1):pa.window(2), a.sdetmeans)
hold on
plotlines(pa.locs,[ymin ymax])
title('attend subject averages of detrended data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
ylim([ymin ymax])

subplot(3,1,2)
plot(pa.window(1):pa.window(2), u.sdetmeans)
hold on
plotlines(pa.locs,[ymin ymax])
title('unattend subject averages of detrended data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
ylim([ymin ymax])

subplot(3,1,3)
plot(pa.window(1):pa.window(2), n.sdetmeans)
hold on
plotlines(pa.locs,[ymin ymax])
title('neutral subject averages of detrended data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
ylim([ymin ymax])

ymin = -0.015;
ymax = 0.015;

figure
shadedErrorBar(pa.window(1):pa.window(2),a.gdetmean,a.detse,'b',1) %%%%
hold on
shadedErrorBar(pa.window(1):pa.window(2),u.gdetmean,u.detse,'r',1) %%%%
shadedErrorBar(pa.window(1):pa.window(2),n.gdetmean,n.detse,'g',1) %%%%
plotlines(pa.locs,[ymin ymax])
title('group averages det (b=attend, r=unattend, and g=neutral)')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
ylim([ymin ymax])

figdir = filedir;
fig = [1 2 3 4];
fignames = {'subject_avgs' 'group_avgs' 'subject_avgs_det' 'group_avgs_det'};
figprefix = 'ta';

rd_saveAllFigs(fig,fignames,figprefix, figdir)
