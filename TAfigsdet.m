

% for j = 1:length(subjects)
%     
%     ymin = -0.1;
%     ymax = 0.1;
%     
%     %individual subject conditions normalized data
%     figure
%     subplot(3,1,1)
%     plot(window(1):window(2),t1det(:,:,j),'color',[.7 .7 .75])
%     hold on
%     plot([0 0],[ymin ymax],'k')
%     plot([1000 1000],[ymin ymax],'k')
%     plot([1250 1250],[ymin ymax],'k')
%     plot([1750 1750],[ymin ymax],'k')
%     plot(window(1):window(2),nanmean(t1det(:,:,j)),'b','LineWidth',3)
%     title([subjects{j} ' t1 detrended'])
%     xlabel('time (ms)')
%     ylabel('pupil area (detrended)')
%     ylim([-0.015 0.015])
%     
%     subplot(3,1,2)
%     plot(window(1):window(2),t2det(:,:,j),'color',[.75 .7 .7])
%     hold on
%     plot([0 0],[ymin ymax],'k')
%     plot([1000 1000],[ymin ymax],'k')
%     plot([1250 1250],[ymin ymax],'k')
%     plot([1750 1750],[ymin ymax],'k')
%     plot(window(1):window(2),nanmean(t2det(:,:,j)),'r','LineWidth',3)
%     title([subjects{j} ' t2 detrended'])
%     xlabel('time (ms)')
%     ylabel('pupil area (detrended)')
%     ylim([-0.015 0.015])
%     
%     subplot(3,1,3)
%     plot(window(1):window(2),neutraldet(:,:,j),'color',[.7 .75 .7])
%     hold on
%     plot([0 0],[ymin ymax],'k')
%     plot([1000 1000],[ymin ymax],'k')
%     plot([1250 1250],[ymin ymax],'k')
%     plot([1750 1750],[ymin ymax],'k')
%     plot(window(1):window(2),nanmean(neutraldet(:,:,j)),'g','LineWidth',3)
%     title([subjects{j} ' neutral detrended'])
%     xlabel('time (ms)')
%     ylabel('pupil area (detrended)')
%     ylim([-0.015 0.015])
%     
%     switch j
%         case 2
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/ca';
%             case 3
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/ec';
%             case 4
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/en';
%             case 5
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/ew';
%             case 6
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/jl';
%             case 7
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/jx';
%             case 8
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/ld';
%             case 9
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/rd';
%             case 10
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/sj';
%             case 11
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/ml';
%             case 12
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/id';    
%             case 1
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/bl';
%     end
%     
%     fig = j;
%     
%     fignames = {'conditions_detrended'};
%     
%     figprefix = 'ta';
%     
%     rd_saveAllFigs(fig,fignames,figprefix, figdir)
%     
% end

ymin = -0.1;
ymax = 0.1;

%subject means
figure
subplot(3,1,1)
plot(window(1):window(2), squeeze(t1det1))
hold on
% plot(window(1):window(2),nanmean(t1det(:,:,1)),'b')
% hold on
% plot(window(1):window(2),nanmean(t1det(:,:,2)),'c')
% plot(window(1):window(2),nanmean(t1det(:,:,3)),'g')
% plot(window(1):window(2),nanmean(t1det(:,:,4)),'m')
% plot(window(1):window(2),nanmean(t1det(:,:,5)),'r')
% plot(window(1):window(2),nanmean(t1det(:,:,6)),'y')
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('t1 subject averages of detrended1 data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
% legend('ad','bl','ec','ty','vp','zw')
ylim([-0.01 0.01])

subplot(3,1,2)
plot(window(1):window(2), squeeze(t2det1))
hold on
% plot(window(1):window(2),nanmean(t2det(:,:,1)),'b')
% hold on
% plot(window(1):window(2),nanmean(t2det(:,:,2)),'c')
% plot(window(1):window(2),nanmean(t2det(:,:,3)),'g')
% plot(window(1):window(2),nanmean(t2det(:,:,4)),'m')
% plot(window(1):window(2),nanmean(t2det(:,:,5)),'r')
% plot(window(1):window(2),nanmean(t2det(:,:,6)),'y')
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('t2 subject averages of detrended1 data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
% legend('ad','bl','ec','ty','vp','zw')
ylim([-0.01 0.01])

subplot(3,1,3)
plot(window(1):window(2), squeeze(neutraldet1))
% plot(window(1):window(2),nanmean(neutraldet(:,:,1)),'b')
% hold on
% plot(window(1):window(2),nanmean(neutraldet(:,:,2)),'c')
% plot(window(1):window(2),nanmean(neutraldet(:,:,3)),'g')
% plot(window(1):window(2),nanmean(neutraldet(:,:,4)),'m')
% plot(window(1):window(2),nanmean(neutraldet(:,:,5)),'r')
% plot(window(1):window(2),nanmean(neutraldet(:,:,6)),'y')
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('neutral subject averages of detrended1 data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
% legend('ad','bl','ec','ty','vp','zw')
ylim([-0.01 0.01])

ymin = -0.1;
ymax = 0.1;



%group means
figure
shadedErrorBar(window(1):window(2),nanmean(t1det1,3),nanstd(t1det1,0,3)./(sqrt(numel(subjects))),'b',1) %%%%
hold on
shadedErrorBar(window(1):window(2),nanmean(t2det1,3),nanstd(t2det1,0,3)./(sqrt(numel(subjects))),'r',1) %%%%
shadedErrorBar(window(1):window(2),nanmean(neutraldet1,3),nanstd(neutraldet1,0,3)./(sqrt(numel(subjects))),'g',1) %%%%
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('group averages det1 (b=t1, r=t2, and g=neutral)')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
ylim([-0.01 0.01])

%subject means
figure
subplot(3,1,1)
plot(window(1):window(2), squeeze(t1det2))
hold on

plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('t1 subject averages of detrended2 data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
% legend('ad','bl','ec','ty','vp','zw')
ylim([-0.01 0.01])

subplot(3,1,2)
plot(window(1):window(2), squeeze(t2det2))
hold on

plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('t2 subject averages of detrended2 data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
% legend('ad','bl','ec','ty','vp','zw')
ylim([-0.01 0.01])

subplot(3,1,3)
plot(window(1):window(2), squeeze(neutraldet2))
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('neutral subject averages of detrended2 data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
% legend('ad','bl','ec','ty','vp','zw')
ylim([-0.01 0.01])

%group means
figure
shadedErrorBar(window(1):window(2),nanmean(t1det2,3),nanstd(t1det2,0,3)./(sqrt(numel(subjects))),'b',1) %%%%
hold on
shadedErrorBar(window(1):window(2),nanmean(t2det2,3),nanstd(t2det2,0,3)./(sqrt(numel(subjects))),'r',1) %%%%
shadedErrorBar(window(1):window(2),nanmean(neutraldet2,3),nanstd(neutraldet2,0,3)./(sqrt(numel(subjects))),'g',1) %%%%
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('group averages det2 (b=t1, r=t2, and g=neutral)')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
ylim([-0.01 0.01])


figdir = filedir;
fig = [1 2 3 4];
fignames = {'subject_avgs_det1' 'group_avgs_det1' 'subject_avgs_det2' 'group_avgs_det2'};
figprefix = 'ta';

rd_saveAllFigs(fig,fignames,figprefix, figdir)

for j = 1:length(subjects)
    
    ymin = -0.02;
    ymax = 0.02;
    
    figure
    plot(window(1):window(2),nanmean(t1det1(:,:,j)),'b')
    hold on
    plot(window(1):window(2),nanmean(t2det1(:,:,j)),'r')
    plot(window(1):window(2),nanmean(neutraldet1(:,:,j)),'g')
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    title([subjects{j} ' all conditions detrended1'])
    xlabel('time (ms)')
    ylabel('pupil area (detrended)')
    legend('t1','t2','neutral')
    
    figure
    plot(window(1):window(2),nanmean(t1det2(:,:,j)),'b')
    hold on
    plot(window(1):window(2),nanmean(t2det2(:,:,j)),'r')
    plot(window(1):window(2),nanmean(neutraldet2(:,:,j)),'g')
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    title([subjects{j} ' all conditions detrended2'])
    xlabel('time (ms)')
    ylabel('pupil area (detrended)')
    legend('t1','t2','neutral')
    
    figdir = [filedir '/' subjects{j}];
    
%     switch j
%         case 2
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/ca';
%             case 3
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/ec';
%             case 4
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/en';
%             case 5
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/ew';
%             case 6
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/jl';
%             case 7
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/jx';
%             case 8
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/ld';
%             case 9
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/rd';
%             case 10
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/sj';
%             case 11
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/ml';
%             case 12
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/id';    
%             case 1
%             figdir = '/Users/jakeparker/Documents/tempatten/E3_adjust/bl';
%     end
    
    fig = [2*j-1+4 2*j+4];
    
    fignames = {'all_conditions_detrended1' 'all_conditions_detrended2'};
    
    figprefix = 'ta';
    
    rd_saveAllFigs(fig,fignames,figprefix, figdir)
    
end
