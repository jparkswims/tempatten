close all

notyvp = 0;

load eyedataE3.mat

countt1xx = countt1;
countt2xx = countt2;
countnxx = countn;

neutraldet1xx = neutraldet1;
neutraldet2xx = neutraldet2;
neutralnormxx = neutralnorm;

t1det1xx = t1det1;
t1det2xx = t1det1;
t1normxx = t1norm;

t2det1xx = t2det1;
t2det2xx = t2det2;
t2normxx = t2norm;

load eyedataE0.mat

countt1 = [countt1 ; countt1xx];
countt2 = [countt2 ; countt2xx];
countn = [countn ;  countnxx];

neutraldet1(:,:,8:19) = neutraldet1xx; %cat(3,neutraldet1,neutraldet1xx)
neutraldet2(:,:,8:19) = neutraldet2xx;
neutralnorm(:,:,8:19) = neutralnormxx;

t1det1(:,:,8:19) = t1det1xx;
t1det2(:,:,8:19) = t1det2xx;
t1norm(:,:,8:19) = t1normxx;

t2det1(:,:,8:19) = t2det1xx;
t2det2(:,:,8:19) = t2det2xx;
t2norm(:,:,8:19) = t2normxx;

if notyvp == 1
    countt1(6,:) = [];
    countt1(5,:) = [];
    countt2(6,:) = [];
    countt2(5,:) = [];
    countn(6,:) = [];
    countn(5,:) = [];
    neutraldet1(:,:,6) = [];
    neutraldet1(:,:,5) = [];
    neutraldet2(:,:,6) = [];
    neutraldet2(:,:,5) = [];
    neutralnorm(:,:,6) = [];
    neutralnorm(:,:,5) = [];
    t1det1(:,:,6) = [];
    t1det1(:,:,5) = [];
    t1det2(:,:,6) = [];
    t1det2(:,:,5) = [];
    t1norm(:,:,6) = [];
    t1norm(:,:,5) = [];
    t2det1(:,:,6) = [];
    t2det1(:,:,5) = [];
    t2det2(:,:,6) = [];
    t2det2(:,:,5) = [];
    t2norm(:,:,6) = [];
    t2norm(:,:,5) = [];
end

t1normwm = wmean(squeeze(nanmean(t1norm))',countt1); 
t2normwm = wmean(squeeze(nanmean(t2norm))',countt2);
neutralnormwm = wmean(squeeze(nanmean(neutralnorm))',countn);

t1det1wm = wmean(squeeze(t1det1)',countt1);
t2det1wm = wmean(squeeze(t2det1)',countt1);
neutraldet1wm = wmean(squeeze(neutraldet1)',countn);    

filedir = '/Users/jakeparker/Documents/tempatten/E0+E3';

%TAallfigs
%det figs

t1gmean = t1det1wm; % m: nanmean(t1det1,3)  wm: t1det1wm
t2gmean = t2det1wm; % m: nanmean(t2det1,3)  wm: t2det1wm
ngmean = neutraldet1wm; % m: nanmean(neutraldet1,3) wm: neutraldet1wm

t1se = wstd(squeeze(t1det1)',t1det1wm,countt1)/sqrt(19); % std: nanstd(t1det1,0,3) wstd: wstd(squeeze(t1det1)',t1det1wm,countt1)
t2se = wstd(squeeze(t2det1)',t2det1wm,countt2)/sqrt(19); % std: nanstd(t2det1,0,3) wstd: wstd(squeeze(t2det1)',t2det1wm,countt2)
nse = wstd(squeeze(neutraldet1)',neutraldet1wm,countn)/sqrt(19); % std: nanstd(neutraldet1,0,3)  wstd: wstd(squeeze(neutraldet1)',neutraldet1wm,countn)

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

t1se = wstd(squeeze(nanmean(t1norm))',t1normwm,countt1)/sqrt(19); % std: nanstd(nanmean(t1norm),0,3)   wstd: wstd(squeeze(nanmean(t1norm))',t1normwm,countt1)
t2se = wstd(squeeze(nanmean(t2norm))',t2normwm,countt2)/sqrt(19); % std: nanstd(nanmean(t2norm),0,3)   wstd: wstd(squeeze(nanmean(t2norm))',t2normwm,countt2)
nse = wstd(squeeze(nanmean(neutralnorm))',neutralnormwm,countn)/sqrt(19); % std: nanstd(nanmean(neutralnorm),0,3)  wstd: wstd(squeeze(nanmean(neutralnorm))',neutralnormwm,countn)

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

