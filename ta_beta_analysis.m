studies = {'E0' 'E3' 'E0E3' 'E5'};
types = {'cue' 'ta' 'tvc'};
dec_type = 'box';
tmax_type = 'tmax_param';
B_type = 'unbounded';
loc_type = 'all';

close all

for s = 1:length(studies)
    
    study = studies{s};
    
    for t = 1:length(types)
        
        type = types{t};
        load([study type '.mat'])
        
        if strcmp(type,'cue')
            
            pa_cue = pa_beta_analysis(pa_cue,dec_type,tmax_type,B_type,loc_type);
            save([study type '.mat'],'pa_cue')
            clear pa_cue
            
        elseif strcmp(type,'ta')
            
            pa_ta = pa_beta_analysis(pa_ta,dec_type,tmax_type,B_type,loc_type);
            save([study type '.mat'],'pa_ta')
            clear pa_ta
            
        elseif strcmp(type,'tvc')
            
            pa_tvc = pa_beta_analysis(pa_tvc,dec_type,tmax_type,B_type,loc_type);
            save([study type '.mat'],'pa_tvc')
            clear pa_tvc
            
        end
        
    end
    
end