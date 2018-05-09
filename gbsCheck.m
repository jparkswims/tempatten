function gbsCheck(file)

load(file)

xlab = {'pcB','t1B','t2B','rcB','decB','pcL','t1L','t2L','rcL','tmax','yint'};
gbsfields = fields(gbs);
gbsfields(1) = [];
temp = nan(2,11,length(gbsfields));
for i = 1:size(temp,3)
    temp(:,:,i) = gbs.(gbsfields{i}).glmparams(:,[1:9 12 13]);
end
hists2(temp,30,xlab,gbsfields)