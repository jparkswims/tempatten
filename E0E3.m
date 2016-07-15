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

E0E3figs