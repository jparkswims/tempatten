s = 4;

t1norm(:,:,s) = [];
t2norm(:,:,s) = [];
neutralnorm(:,:,s) = [];

countt1(s,:) = [];
countt2(s,:) = [];
countn(s,:) = [];

t1normwm = wmean(squeeze(nanmean(t1norm))',countt1);
t2normwm = wmean(squeeze(nanmean(t2norm))',countt2);
neutralnormwm = wmean(squeeze(nanmean(neutralnorm))',countn);

t1det1(:,:,s) = [];
t2det1(:,:,s) = [];
neutraldet1(:,:,s) = [];

t1det1wm = wmean(squeeze(t1det1)',countt1);
t2det1wm = wmean(squeeze(t2det1)',countt2);
neutraldet1wm = wmean(squeeze(neutraldet1)',countn);