t1det1m = squeeze(t1det1)';
t2det1m = squeeze(t2det1)';
neutraldet1m = squeeze(neutraldet1)';

ptable = zeros(duration,2);

for i = 1:duration
    
    ptable(i,:) = anova_rm([t1det1m(:,i) t2det1m(:,i) neutraldet1m(:,i)],'off');
    
end

pvalues = ptable(:,1);

sigtimes = find(pvalues < 0.05);

dsigtimes = [diff(sigtimes) ; 0];

r = 1;
i = 1;

while i <= length(dsigtimes)
    
    clusters(r,1) = sigtimes(i);
    
    while dsigtimes(i) == 1
        
        i = i+1;
        
    end
       
    clusters(r,2) = sigtimes(i);
    
    r = r+1;
    i = i+1;
    
end

for i = 1:size(clusters,1)
    
    ptable2(i,:) = anova_rm([nanmean(t1det1m(:,clusters(i,1):clusters(i,2)),2) nanmean(neutraldet1m(:,clusters(i,1):clusters(i,2)),2) nanmean(t1det1m(:,clusters(i,1):clusters(i,2)),2)]);
    
end
    
    