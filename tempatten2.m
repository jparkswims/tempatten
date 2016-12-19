study = 'E0';
type = 'cue';

if strcmp(type,'cue')
    pa_cue = ta_params(study,type);
    pa_cue = ta_preprocess(pa_cue,study,type);
    save([study type '.mat'],'pa_cue')
    if strcmp(study,'E0') || strcmp(study,'E3') || strcmp(study,'E0E3')
        pafigs(pa_cue.t1,pa_cue.t2,pa_cue.n,pa_cue,pa_cue.filedir,{'t1' 't2' 'n'})
    elseif strcmp(study,'E5')
        pafigs4(pa_cue.t1,pa_cue.t2,pa_cue.t3,pa_cue.n,pa_cue,pa_cue.filedir,{'t1' 't2' 't3' 'n'})
    end
    %model comp, cost analysis, optimization, etc
    %glm analysis
    %stats, figures, etc
elseif strcmp(type,'ta')
    pa_ta = ta_params(study,type);
    pa_ta = ta_preprocess(pa_ta,study,type);
    save([study type '.mat'],'pa_ta')
    pafigs(pa_ta.t1a,pa_ta.t1u,pa_ta.t1n,pa_ta,[pa_ta.filedir '/t1'],{'atten' 'unatten' 'neutral'})
    pafigs(pa_ta.t2a,pa_ta.t2u,pa_ta.t2n,pa_ta,[pa_ta.filedir '/t2'],{'atten' 'unatten' 'neutral'})
    if strcmp(study,'E5')
        pafigs(pa_ta.t3a,pa_ta.t3u,pa_ta.t3n,pa_ta,[pa_ta.filedir '/t3'],{'atten' 'unatten' 'neutral'})
    end    
elseif strcmp(type,'tvc')
    pa_tvc = ta_params(study,type);
    pa_tvc = ta_preprocess(pa_tvc,study,type);
    save([study type '.mat'],'pa_tvc')
    pafigs(pa_tvc.t1vc,pa_tvc.t1uc,pa_tvc.t1nc,pa_tvc,[pa_tvc.filedir '/t1c'],{'atten' 'unatten' 'neutral'})
    pafigs(pa_tvc.t1vf,pa_tvc.t1uf,pa_tvc.t1nf,pa_tvc,[pa_tvc.filedir '/t1f'],{'atten' 'unatten' 'neutral'})
    pafigs(pa_tvc.t2vc,pa_tvc.t2uc,pa_tvc.t2nc,pa_tvc,[pa_tvc.filedir '/t2c'],{'atten' 'unatten' 'neutral'})
    pafigs(pa_tvc.t2vf,pa_tvc.t2uf,pa_tvc.t2nf,pa_tvc,[pa_tvc.filedir '/t2f'],{'atten' 'unatten' 'neutral'})
    if strcmp(study,'E5')
        pafigs(pa_tvc.t3vc,pa_tvc.t3uc,pa_tvc.t3nc,pa_tvc,[pa_tvc.filedir '/t3c'],{'atten' 'unatten' 'neutral'})
        pafigs(pa_tvc.t3vf,pa_tvc.t3uf,pa_tvc.t3nf,pa_tvc,[pa_tvc.filedir '/t3f'],{'atten' 'unatten' 'neutral'})
    end
end

