close all

for j = 1:length(subjects)
    
    ymin = -30;
    ymax = 30;
    
    figure
    subplot(3,1,1)
    plot(window(1):window(2),gt1(:,:,j),'color',[.7 .7 .75])
    hold on
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    plot(window(1):window(2),nanmean(gt1(:,:,j)),'b','LineWidth',3)
    title([subjects{j} ' t1'])
    xlabel('time (ms)')
    ylabel('gaze position')
    ylim([ymin ymax])
    
    subplot(3,1,2)
    plot(window(1):window(2),gt2(:,:,j),'color',[.75 .7 .7])
    hold on
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    plot(window(1):window(2),nanmean(gt2(:,:,j)),'r','LineWidth',3)
    title([subjects{j} ' t2'])
    xlabel('time (ms)')
    ylabel('gaze position')
    ylim([ymin ymax])
    
    subplot(3,1,3)
    plot(window(1):window(2),gneutral(:,:,j),'color',[.7 .75 .7])
    hold on
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    plot(window(1):window(2),nanmean(gneutral(:,:,j)),'g','LineWidth',3)
    title([subjects{j} ' neutral'])
    xlabel('time (ms)')
    ylabel('gaze position')
    ylim([ymin ymax])
    
    figure
    plot(window(1):window(2),nanmean(gt1(:,:,j)),'b')
    hold on
    plot(window(1):window(2),nanmean(gt2(:,:,j)),'r')
    plot(window(1):window(2),nanmean(gneutral(:,:,j)),'g')
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    title([subjects{j} ' all conditions'])
    xlabel('time (ms)')
    ylabel('gaze position')
    legend('t1','t2','neutral')
    
    figure
    plot(window(1):window(2),gt1det(1,:,j),'b')
    hold on
    plot(window(1):window(2),gt2det(1,:,j),'r')
    plot(window(1):window(2),gneutraldet(1,:,j),'g')
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    title([subjects{j} ' all conditions detrended'])
    xlabel('time (ms)')
    ylabel('gaze position')
    legend('t1','t2','neutral')
    
    figdir = [filedir '/' subjects{j}];
    
    fig = [1 2 3];
    
    fignames = {'gazeposition' 'all_conditions' 'all_conditions_det'};
    
    figprefix = 'ta';
    
    rd_saveAllFigs(fig,fignames,figprefix, figdir)
    
    close all
    
end

ymin = -10;
ymax = 10;

figure
subplot(3,1,1)
plot(window(1):window(2), squeeze(nanmean(gt1)))
hold on
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('t1 subject averages of normalized data')
xlabel('time (ms)')
ylabel('gaze position')
%legend('ad','bl','ec','ty','vp','zw')

subplot(3,1,2)
plot(window(1):window(2), squeeze(nanmean(gt2)))
hold on
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('t2 subject averages of normalized data')
xlabel('time (ms)')
ylabel('gaze position')
%legend('ad','bl','ec','ty','vp','zw')

subplot(3,1,3)
plot(window(1):window(2), squeeze(nanmean(gneutral)))
hold on
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('neutral subject averages of normalized data')
xlabel('time (ms)')
ylabel('gaze position')
%legend('ad','bl','ec','ty','vp','zw')

figure
subplot(3,1,1)
plot(window(1):window(2), squeeze(gt1det))
hold on
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('t1 subject averages of normalized data')
xlabel('time (ms)')
ylabel('gaze position')
%legend('ad','bl','ec','ty','vp','zw')

subplot(3,1,2)
plot(window(1):window(2), squeeze(gt2det))
hold on
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('t2 subject averages of normalized data')
xlabel('time (ms)')
ylabel('gaze position')
%legend('ad','bl','ec','ty','vp','zw')

subplot(3,1,3)
plot(window(1):window(2), squeeze(gneutraldet))
hold on
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('neutral subject averages of normalized data')
xlabel('time (ms)')
ylabel('gaze position')
%legend('ad','bl','ec','ty','vp','zw')

figure
plot(window(1):window(2), nanmean(nanmean(gt1,3)),'b')
hold on
plot(window(1):window(2), nanmean(nanmean(gt2,3)),'r')
plot(window(1):window(2), nanmean(nanmean(gneutral,3)),'g')
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('group averages (b=t1, r=t2, and g=neutral)')
xlabel('time (ms)')
ylabel('gaze position')
ylim([ymin ymax])

figure
plot(window(1):window(2), nanmean(gt1det,3),'b')
hold on
plot(window(1):window(2), nanmean(gt2det,3),'r')
plot(window(1):window(2), nanmean(gneutraldet,3),'g')
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('group averages (b=t1, r=t2, and g=neutral)')
xlabel('time (ms)')
ylabel('gaze position')
ylim([ymin ymax])

figdir = filedir;
fig = [1 2 3 4];
fignames = {'subject_avgs' 'subject_avgs_det' 'group_avgs' 'group_avgs_det'};
figprefix = 'ta';

rd_saveAllFigs(fig,fignames,figprefix, figdir)

close all