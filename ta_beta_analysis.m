studies = {'E0' 'E3' 'E0E3'};
types = {'ta' 'tvc'};
modelnum = 5;

close all

for s = 1:length(studies)
    
    study = studies{s};
    
    for t = 1:length(types)
        
        type = types{t};
        load([study type '.mat'])
        
        if strcmp(type,'cue')
            
            pa_cue = pa_beta_analysis(pa_cue,modelnum);
            save([study type '.mat'],'pa_cue')
            clear pa_cue
            
        elseif strcmp(type,'ta')
            
            pa_ta = pa_beta_analysis(pa_ta,modelnum);
            save([study type '.mat'],'pa_ta')
            clear pa_ta
            
        elseif strcmp(type,'tvc')
            
            pa_tvc = pa_beta_analysis(pa_tvc,modelnum);
            save([study type '.mat'],'pa_tvc')
            clear pa_tvc
            
        end
        
    end
    
end

close all