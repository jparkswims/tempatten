function gbs = glm_bootstrap(pa,snum,nboot,savedir,dbug,wnum)

gbs = struct('gboot',[]);
for f = 1:length(pa.fields)
    gbs.(pa.fields{f}) = struct('glm_params',nan(nboot,13),'bsind',nan(size(pa.(pa.fields{f}).(pa.subjects{snum}),1),nboot),'optimflag',nan(nboot,1));
end
rng(1)

parpool(wnum)

for f = 1:length(pa.fields)
    
    [gBSmean,bsind] = bootstrp(nboot,@nanmean,pa.(pa.fields{f}).(pa.subjects{snum}));
    gboot = nan(nboot,13);
    optimflag = nan(nboot,1);

    parfor n = 1:nboot %parfor
        if dbug > 0
            fprintf('Condition: %s\n',pa.fields{f})
            fprintf('Bootstrap Number: %d\n',n)
        end
        [gboot(n,:),optimflag(n)] = quick_glm_grid(gBSmean(n,:),pa,snum,dbug);
    end
    fprintf('Condition %s bootstrapping completed\n',pa.fields{f})
    gbs.(pa.fields{f}).glm_params = gboot;
    gbs.(pa.fields{f}).bsind = bsind;
    gbs.(pa.fields{f}).optimflag = optimflag;
    save([savedir '/gbs_' pa.study pa.type '_' pa.subjects{snum}],'gbs')
    fprintf('\nCondition %s has been saved in %s\n\n',pa.fields{f},savedir)
    
end

%save([savedir '/gbs_' pa.study pa.type '_' pa.subjects{snum}],'gbs')
    
    

