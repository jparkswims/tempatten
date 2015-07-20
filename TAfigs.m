load eyedata.mat

for j = 1:6
    
    ymin = min(min(trialmat(:,:,j)));
    ymax = max(max(trialmat(:,:,j)));

    figure
    subplot(3,1,1)
    plot(window(1):window(2),t1(:,:,j),'color',[.7 .7 .75])
    hold on
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([1250 1250],[ymin ymax],'k')
    plot([1750 1750],[ymin ymax],'k')
    plot(window(1):window(2),nanmean(t1(:,:,j)),'b','LineWidth',3)
    title([subjects{j} ' t1'])
    xlabel('time (ms)')
    ylabel('pupil area')
    
    subplot(3,1,2)
    plot(window(1):window(2),t2(:,:,j),'color',[.75 .7 .7])
    hold on
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([1250 1250],[ymin ymax],'k')
    plot([1750 1750],[ymin ymax],'k')
    plot(window(1):window(2),nanmean(t2(:,:,j)),'r','LineWidth',3)
    title([subjects{j} ' t2'])
    xlabel('time (ms)')
    ylabel('pupil area')
    
    subplot(3,1,3)
    plot(window(1):window(2),neutral(:,:,j),'color',[.7 .75 .7])
    hold on
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([1250 1250],[ymin ymax],'k')
    plot([1750 1750],[ymin ymax],'k')
    plot(window(1):window(2),nanmean(neutral(:,:,j)),'g','LineWidth',3)
    title([subjects{j} ' neutral'])
    xlabel('time (ms)')
    ylabel('pupil area')
    
    ymin = -0.3;
    ymax = 0.3;
    
    figure
    subplot(3,1,1)
    plot(window(1):window(2),t1norm(:,:,j),'color',[.7 .7 .75])
    hold on
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([1250 1250],[ymin ymax],'k')
    plot([1750 1750],[ymin ymax],'k')
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
    plot([1250 1250],[ymin ymax],'k')
    plot([1750 1750],[ymin ymax],'k')
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
    plot([1250 1250],[ymin ymax],'k')
    plot([1750 1750],[ymin ymax],'k')
    plot(window(1):window(2),nanmean(neutralnorm(:,:,j)),'g','LineWidth',3)
    title([subjects{j} ' neutral normalized'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    ylim([-0.3 0.3])
    
    switch j
        case 2
            figdir = '/Users/jakeparker/Documents/tempatten/bl';
        case 3
            figdir = '/Users/jakeparker/Documents/tempatten/ec';
        case 4
            figdir = '/Users/jakeparker/Documents/tempatten/ty';
        case 5
            figdir = '/Users/jakeparker/Documents/tempatten/vp';
        case 6
            figdir = '/Users/jakeparker/Documents/tempatten/zw';
        case 1
            figdir = '/Users/jakeparker/Documents/tempatten/ad';
    end
    
    fig = [2*j-1 2*j];
    
    fignames = {'conditions' 'conditions_norm'};
    
    figprefix = 'ta';
    
    rd_saveAllFigs(fig,fignames,figprefix, figdir)
    
end

ymin = -0.1;
ymax = 0.3;

figure
subplot(3,1,1)
plot(window(1):window(2),nanmean(t1norm(:,:,1)),'b')
hold on
plot(window(1):window(2),nanmean(t1norm(:,:,2)),'c')
plot(window(1):window(2),nanmean(t1norm(:,:,3)),'g')
plot(window(1):window(2),nanmean(t1norm(:,:,4)),'m')
plot(window(1):window(2),nanmean(t1norm(:,:,5)),'r')
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([1250 1250],[ymin ymax],'k')
plot([1750 1750],[ymin ymax],'k')
title('t1 subject averages of normalized data')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
legend('bl','ec','ty','vp','zw')
ylim([-0.1 0.3])

subplot(3,1,2)
plot(window(1):window(2),nanmean(t2norm(:,:,1)),'b')
hold on
plot(window(1):window(2),nanmean(t2norm(:,:,2)),'c')
plot(window(1):window(2),nanmean(t2norm(:,:,3)),'g')
plot(window(1):window(2),nanmean(t2norm(:,:,4)),'m')
plot(window(1):window(2),nanmean(t2norm(:,:,5)),'r')
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([1250 1250],[ymin ymax],'k')
plot([1750 1750],[ymin ymax],'k')
title('t2 subject averages of normalized data')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
legend('bl','ec','ty','vp','zw')
ylim([-0.1 0.3])

subplot(3,1,3)
plot(window(1):window(2),nanmean(neutralnorm(:,:,1)),'b')
hold on
plot(window(1):window(2),nanmean(neutralnorm(:,:,2)),'c')
plot(window(1):window(2),nanmean(neutralnorm(:,:,3)),'g')
plot(window(1):window(2),nanmean(neutralnorm(:,:,4)),'m')
plot(window(1):window(2),nanmean(neutralnorm(:,:,5)),'r')
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([1250 1250],[ymin ymax],'k')
plot([1750 1750],[ymin ymax],'k')
title('neutral subject averages of normalized data')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
legend('bl','ec','ty','vp','zw')
ylim([-0.1 0.3])

ymin = -0.05;
ymax = 0.25;

figure
shadedErrorBar(window(1):window(2),nanmean(nanmean(t1norm),3),nanmean(nanstd(t1norm),3),'b',1)
hold on
shadedErrorBar(window(1):window(2),nanmean(nanmean(t2norm),3),nanmean(nanstd(t2norm),3),'r',1)
shadedErrorBar(window(1):window(2),nanmean(nanmean(neutralnorm),3),nanmean(nanstd(neutralnorm),3),'g',1)
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([1250 1250],[ymin ymax],'k')
plot([1750 1750],[ymin ymax],'k')
title('group averages (b=t1, r=t2, and g=neutral)')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
ylim([-0.05 0.25])

figdir = '/Users/jakeparker/Documents/tempatten';
fig = [13 14];
fignames = {'subject_avgs' 'group_avgs'};
figprefix = 'ta';

rd_saveAllFigs(fig,fignames,figprefix, figdir)
