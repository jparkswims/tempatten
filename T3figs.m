function T3figs(pac)

close all

for j = 1:length(pac.subjects)
    
    ymin = -0.3;
    ymax = 0.3;
    
    %individual subject conditions normalized data
    figure
    subplot(4,1,1)
    plot(pac.window(1):pac.window(2),pac.t1.(pac.subjects{j}),'color',[.7 .7 .75])
    hold on
    plotlines(pac.locs,[ymin ymax])
    plot(pac.window(1):pac.window(2),pac.t1.smeans(j,:),'b','LineWidth',3)
    title([pac.subjects{j} ' t1 normalized'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    ylim([-0.3 0.3])
    
    subplot(4,1,2)
    plot(pac.window(1):pac.window(2),pac.t2.(pac.subjects{j}),'color',[.75 .7 .7])
    hold on
    plotlines(pac.locs,[ymin ymax])
    plot(pac.window(1):pac.window(2),pac.t2.smeans(j,:),'r','LineWidth',3)
    title([pac.subjects{j} ' t2 normalized'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    ylim([-0.3 0.3])

    subplot(4,1,3)
    plot(pac.window(1):pac.window(2),pac.t3.(pac.subjects{j}),'color',[.70 .75 .75])
    hold on
    plotlines(pac.locs,[ymin ymax])
    plot(pac.window(1):pac.window(2),pac.t3.smeans(j,:),'c','LineWidth',3)
    title([pac.subjects{j} ' t3 normalized'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    ylim([-0.3 0.3])

    subplot(4,1,4)
    plot(pac.window(1):pac.window(2),pac.neutral.(pac.subjects{j}),'color',[.7 .75 .7])
    hold on
    plotlines(pac.locs,[ymin ymax])
    plot(pac.window(1):pac.window(2),pac.neutral.smeans(j,:),'g','LineWidth',3)
    title([pac.subjects{j} ' neutral normalized'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    ylim([-0.3 0.3])

    ymin = -0.1;
    ymax = 0.2;
    
    figure
    plot(pac.window(1):pac.window(2),nanmean(pac.t1.(pac.subjects{j})),'b')
    hold on
    plot(pac.window(1):pac.window(2),nanmean(pac.t2.(pac.subjects{j})),'r')
    plot(pac.window(1):pac.window(2),nanmean(pac.t3.(pac.subjects{j})),'c')
    plot(pac.window(1):pac.window(2),nanmean(pac.neutral.(pac.subjects{j})),'g')
    plotlines(pac.locs,[ymin ymax])
    title([pac.subjects{j} ' all conditions'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    legend('t1','t2','t3','neutral')
    ylim([ymin ymax])

    ymin = -0.02;
    ymax = 0.02;

    figure
    plot(pac.window(1):pac.window(2),pac.t1det(j,:),'b')
    hold on
    plot(pac.window(1):pac.window(2),pac.t2det(j,:),'r')
    plot(pac.window(1):pac.window(2),pac.t3det(j,:),'c')
    plot(pac.window(1):pac.window(2),pac.neutraldet(j,:),'g')
    plotlines(pac.locs,[ymin ymax])
    title([pac.subjects{j} ' all conditions det'])
    xlabel('time (ms)')
    ylabel('pupil area (detrended)')
    legend('t1','t2','t3','neutral')

    figdir = [pac.filedir '/' pac.subjects{j}];
    fig = [1 2 3];
    fignames = {'conditions_norm' 'all_conditions_norm' 'all_conditions_det'};
    figprefix = 'ta';
    rd_saveAllFigs(fig,fignames,figprefix, figdir)

    close all

end

ymin = -0.1;
ymax = 0.2;

figure
subplot(4,1,1)
plot(pac.window(1):pac.window(2), pac.t1.smeans)
hold on
plotlines(pac.locs,[ymin ymax])
title('t1 subject averages of normalized data')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
ylim([-0.1 0.2])

subplot(4,1,2)
plot(pac.window(1):pac.window(2), pac.t2.smeans)
hold on
plotlines(pac.locs,[ymin ymax])
title('t2 subject averages of normalized data')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
ylim([-0.1 0.2])

subplot(4,1,3)
plot(pac.window(1):pac.window(2), pac.t3.smeans)
hold on
plotlines(pac.locs,[ymin ymax])
title('t3 subject averages of normalized data')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
ylim([-0.1 0.2])

subplot(4,1,4)
plot(pac.window(1):pac.window(2), pac.neutral.smeans)
hold on
plotlines(pac.locs,[ymin ymax])
title('neutral subject averages of normalized data')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
ylim([-0.1 0.2])

ymin = -0.05;
ymax = 0.1;

figure
shadedErrorBar(pac.window(1):pac.window(2),pac.t1normwm,pac.t1se,'b',1) %%%%%
hold on
shadedErrorBar(pac.window(1):pac.window(2),pac.t2normwm,pac.t2se,'r',1) %%%%
shadedErrorBar(pac.window(1):pac.window(2),pac.t3normwm,pac.t3se,'c',1) %%%%
shadedErrorBar(pac.window(1):pac.window(2),pac.neutralnormwm,pac.nse,'g',1) %%%%
plotlines(pac.locs,[ymin ymax])
title('group averages (b=t1, r=t2, y=t3, and g=neutral)')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
ylim([-0.05 0.1])

ymin = -0.1;
ymax = 0.1;

figure
subplot(4,1,1)
plot(pac.window(1):pac.window(2), pac.t1det)
hold on
plotlines(pac.locs,[ymin ymax])
title('t1 subject averages of detrended data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
ylim([-0.01 0.01])

subplot(4,1,2)
plot(pac.window(1):pac.window(2), pac.t2det)
hold on
plotlines(pac.locs,[ymin ymax])
title('t2 subject averages of detrended data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
ylim([-0.01 0.01])

subplot(4,1,3)
plot(pac.window(1):pac.window(2), pac.t3det)
hold on
plotlines(pac.locs,[ymin ymax])
title('t3 subject averages of detrended data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
ylim([-0.01 0.01])

subplot(4,1,4)
plot(pac.window(1):pac.window(2), pac.neutraldet)
hold on
plotlines(pac.locs,[ymin ymax])
title('neutral subject averages of detrended data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
ylim([-0.01 0.01])

figure
shadedErrorBar(pac.window(1):pac.window(2),pac.t1detwm,pac.t1detse,'b',1)
hold on
shadedErrorBar(pac.window(1):pac.window(2),pac.t2detwm,pac.t2detse,'r',1)
shadedErrorBar(pac.window(1):pac.window(2),pac.t3detwm,pac.t3detse,'c',1)
shadedErrorBar(pac.window(1):pac.window(2),pac.neutraldetwm,pac.neutraldetse,'g',1)
plotlines(pac.locs,[ymin ymax])
title('group averages det (b=t1, r=t2, y=3, and g=neutral)')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
ylim([-0.01 0.01])

figdir = pac.filedir;
fig = [1 2 3 4];
fignames = {'subject_means_norm' 'group_mean_norm' 'subject_means_det' 'group_mean_det'};
figprefix = 'ta';
rd_saveAllFigs(fig,fignames,figprefix, figdir)

close all