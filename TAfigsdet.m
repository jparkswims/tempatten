t1gmean = t1det1wm; % m: nanmean(t1det1,3)  wm: t1det1wm
t2gmean = t2det1wm; % m: nanmean(t2det1,3)  wm: t2det1wm
ngmean = neutraldet1wm; % m: nanmean(neutraldet1,3) wm: neutraldet1wm

t1se = nanstd(t1det1,0,3)/sqrt(numel(subjects)); % std: nanstd(t1det1,0,3) wstd: wstd(squeeze(t1det1)',t1det1wm,countt1)
t2se = nanstd(t2det1,0,3)/sqrt(numel(subjects)); % std: nanstd(t2det1,0,3) wstd: wstd(squeeze(t2det1)',t2det1wm,countt2)
nse = nanstd(neutraldet1,0,3)/sqrt(numel(subjects)); % std: nanstd(neutraldet1,0,3)  wstd: wstd(squeeze(neutraldet1)',neutraldet1wm,countn)

ymin = -0.1;
ymax = 0.1;

%subject means
figure
subplot(3,1,1)
plot(window(1):window(2), squeeze(t1det1))
hold on
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
hold on
plot(window(1):window(2), squeeze(neutraldet1))
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('neutral subject averages of detrended1 data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
% legend('ad','bl','ec','ty','vp','zw')
xlim([window(1) window(2)])
ylim([-0.01 0.01])

ymin = -0.1;
ymax = 0.1;



%group means
figure
shadedErrorBar(window(1):window(2),t1gmean,t1se,'b',1) %%%%
hold on
shadedErrorBar(window(1):window(2),t2gmean,t2se,'r',1) %%%%
shadedErrorBar(window(1):window(2),ngmean,nse,'g',1) %%%%
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
hold on
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('neutral subject averages of detrended2 data')
xlabel('time (ms)')
ylabel('pupil area (detrended)')
% legend('ad','bl','ec','ty','vp','zw')
xlim([window(1) window(2)])
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
    plot(window(1):window(2),t1det1(:,:,j),'b')
    hold on
    plot(window(1):window(2),t2det1(:,:,j),'r')
    plot(window(1):window(2),neutraldet1(:,:,j),'g')
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    title([subjects{j} ' all conditions detrended1'])
    xlabel('time (ms)')
    ylabel('pupil area (detrended)')
    legend('t1','t2','neutral')
    
    figure
    plot(window(1):window(2),t1det2(:,:,j),'b')
    hold on
    plot(window(1):window(2),t2det2(:,:,j),'r')
    plot(window(1):window(2),neutraldet2(:,:,j),'g')
    plot([0 0],[ymin ymax],'k')
    plot([1000 1000],[ymin ymax],'k')
    plot([t2time t2time],[ymin ymax],'k')
    plot([postcue postcue],[ymin ymax],'k')
    title([subjects{j} ' all conditions detrended2'])
    xlabel('time (ms)')
    ylabel('pupil area (detrended)')
    legend('t1','t2','neutral')
    
    figdir = [filedir '/' subjects{j}];
    
    fig = [2*j-1+4 2*j+4];
    
    fignames = {'all_conditions_detrended1' 'all_conditions_detrended2'};
    
    figprefix = 'ta';
    
    rd_saveAllFigs(fig,fignames,figprefix, figdir)
    
end
