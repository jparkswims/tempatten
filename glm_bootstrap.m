function gbs = glm_bootstrap(pa,snum,nboot,savedir,dbug,wnum)

gbs = struct('gboot',[]);
for f = 1:length(pa.fields)
    gbs.(pa.fields{f}) = struct('glm_params',nan(nboot,13),'bsind',nan(size(pa.(pa.fields{f}).(pa.subjects{snum}),1),nboot),'optimflag',nan(nboot,1));
end
rng(1)

parpool(wnum)

%test parpool function
parfor f = 1:wnum
    fprintf('%d\n',f)
end

for f = 1:length(pa.fields)
    
    [gBSmean,bsind] = bootstrp(nboot,@nanmean,pa.(pa.fields{f}).(pa.subjects{snum}));
    gboot = nan(nboot,13);
    optimflag = nan(nboot,1);

    parfor n = 1:nboot %parfor
        [gboot(n,:),optimflag(n)] = quick_glm_grid(gBSmean(n,:),pa,snum,dbug);
        if dbug > 0
            fprintf('Condition %s, bootstrap %d, flag %d\n',pa.fields{f},n,optimflag(n))
        end
    end
    fprintf('\n********** All %s bootstrapping completed **********\n',pa.fields{f})
    gbs.(pa.fields{f}).glm_params = gboot;
    gbs.(pa.fields{f}).bsind = bsind;
    gbs.(pa.fields{f}).optimflag = optimflag;
    save([savedir '/gbs_' pa.study pa.type '_' pa.subjects{snum}],'gbs')
    fprintf('Condition %s has been saved in %s\n\n',pa.fields{f},savedir)
    
end

fprintf('\nglm_bootstrap done for subject %s\n',pa.subjects{snum})

%save([savedir '/gbs_' pa.study pa.type '_' pa.subjects{snum}],'gbs')
    
    

