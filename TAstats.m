t1det1m = squeeze(t1det1)';
t2det1m = squeeze(t2det1)';
neutraldet1m = squeeze(neutraldet1)';

ptable = zeros(duration,2);

for i = 1:duration
    
    ptable(i,:) = anova_rm([t1det1m(:,i) t2det1m(:,i) neutraldet1m(:,i)],'off');
    
end

pvalues = ptable(:,1);

sigtimes = find(pvalues < 0.05);

sigtimes2 = sigtimes(diff(sigtimes) == 1);

