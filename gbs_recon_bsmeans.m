function bsmeans = gbs_recon_bsmeans(gbs,pa,sj,cond)

bsmeans = nan(size(gbs.(sj).(cond).bsind,2),pa.window(2)-pa.window(1)+1);

for bs = 1:size(bsmeans,1)
    
    bsmeans(bs,:) = nanmean(pa.(cond).(sj)(gbs.(sj).(cond).bsind(:,bs),:));

end