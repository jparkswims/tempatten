function gbs = glm_bootstrap(pa,snum,nboot,savedir,dbug)

% t1vcBSmean = bootstrp(nboot,@nanmean,pa.t1vc.(pa.subjects{snum}));
% gboot = nan(nboot,13);

gbs = struct('gboot',[]);
rng(1)

for f = 1:length(pa.fields)
    
    gBSmean = bootstrp(nboot,@nanmean,pa.(pa.fields{f}).(pa.subjects{snum}));
    gboot = nan(nboot,13);

    parfor n = 1:nboot %parfor
        if dbug == 1
            fprintf('Condition: %s\n',pa.fields{f})
            fprintf('Bootstrap Number: %d\n',n)
        end
        gboot(n,:) = quick_glm_grid(gBSmean(n,:),pa,snum,dbug);
    end
    
    gbs.gboot.(pa.fields{f}) = gboot;
    
end

save([savedir '/gbs_' pa.study pa.type '_' pa.subjects{snum}],'gbs')
    
    

