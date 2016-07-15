close all

filedir = '/Users/jakeparker/Documents/tempatten/E0+E3/no_ec';

%TAallfigs
%det figs

t1gmean = t1det1wm; % m: nanmean(t1det1,3)  wm: t1det1wm
t2gmean = t2det1wm; % m: nanmean(t2det1,3)  wm: t2det1wm
ngmean = neutraldet1wm; % m: nanmean(neutraldet1,3) wm: neutraldet1wm

t1se = wste(squeeze(t1det1)',t1det1wm,countt1); % std: nanstd(t1det1,0,3) wstd: wstd(squeeze(t1det1)',t1det1wm,countt1)
t2se = wste(squeeze(t2det1)',t2det1wm,countt2); % std: nanstd(t2det1,0,3) wstd: wstd(squeeze(t2det1)',t2det1wm,countt2)
nse = wste(squeeze(neutraldet1)',neutraldet1wm,countn); % std: nanstd(neutraldet1,0,3)  wstd: wstd(squeeze(neutraldet1)',neutraldet1wm,countn)

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

close all

%norm figs

t1gmean = t1normwm; % m: nanmean(nanmean(t1norm),3) wm: t1normwm
t2gmean = t2normwm; % m: nanmean(nanmean(t2norm),3) wm: t2normwm
ngmean = neutralnormwm; % m :nanmean(nanmean(neutralnorm),3)    wm: neutralnormwm

t1se = wste(squeeze(nanmean(t1norm))',t1normwm,countt1); % std: nanstd(nanmean(t1norm),0,3)   wstd: wstd(squeeze(nanmean(t1norm))',t1normwm,countt1)
t2se = wste(squeeze(nanmean(t2norm))',t2normwm,countt2); % std: nanstd(nanmean(t2norm),0,3)   wstd: wstd(squeeze(nanmean(t2norm))',t2normwm,countt2)
nse = wste(squeeze(nanmean(neutralnorm))',neutralnormwm,countn); % std: nanstd(nanmean(neutralnorm),0,3)  wstd: wstd(squeeze(nanmean(neutralnorm))',neutralnormwm,countn)

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
shadedErrorBar(window(1):window(2),t1normwm,t1se,'b',1) %%%%%
hold on
shadedErrorBar(window(1):window(2),t2normwm,t2se,'r',1) %%%%
shadedErrorBar(window(1):window(2),neutralnormwm,nse,'g',1) %%%%
plot([0 0],[ymin ymax],'k')
plot([1000 1000],[ymin ymax],'k')
plot([t2time t2time],[ymin ymax],'k')
plot([postcue postcue],[ymin ymax],'k')
title('group averages (b=t1, r=t2, and g=neutral)')
xlabel('time (ms)')
ylabel('pupil area (normalized)')
ylim([-0.05 0.25])

figdir = filedir;
fig = [1 2];
fignames = {'subject_avgs' 'group_avgs'};
figprefix = 'ta';

rd_saveAllFigs(fig,fignames,figprefix, figdir)

close all

fig = 1;

figure
subplot(3,1,1)
plot(window(1):window(2),countt1)
title('Counts of valid data points t1')
xlabel('time(ms)')
ylabel('Number of valid data points')

subplot(3,1,2)
plot(window(1):window(2),countt2)
title('Counts of valid data points t2')
xlabel('time(ms)')
ylabel('Number of valid data points')

subplot(3,1,3)
plot(window(1):window(2),countn)
title('Counts of valid data points neutral')
xlabel('time(ms)')
ylabel('Number of valid data points')

fignames = {'ValidCount'};

rd_saveAllFigs(fig,fignames,figprefix, figdir)

close all

