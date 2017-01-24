function output = ss_tot(y)

ymean = nanmean(y);

output = sum((y-ymean).^2);