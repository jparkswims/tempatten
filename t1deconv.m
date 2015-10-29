load eyedata.mat

h = hpupil(1:3000,10.1,930,1/(10^27));

ip = zeros(1,2601);

ip(1401) = 1;

o = conv(h,ip);

drift = polyfit(-400:2200,nanmean(nanmean(t1norm(:,1:2601,:)),3),1);

o = o + (drift(1) .* [-400:5199] + drift(2));

plot(o)
