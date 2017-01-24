studies = {'E0' 'E3' 'E0E3' 'E5'};
types = {'cue' 'ta' 'tvc'};

close all

for s = 1:length(studies)
    
    study = studies{s};
    
    for t = 1:length(types)
        
        type = types{t};
        load([study type '.mat'])
        
        if strcmp(type,'cue')
            
            pa_cue = pa_best_model(pa_cue);
            save([study type '.mat'],'pa_cue')
            clear pa_cue
            
        elseif strcmp(type,'ta')
            
            pa_ta = pa_best_model(pa_ta);
            save([study type '.mat'],'pa_ta')
            clear pa_ta
            
        elseif strcmp(type,'tvc')
            
            pa_tvc = pa_best_model(pa_tvc);
            save([study type '.mat'],'pa_tvc')
            clear pa_tvc
            
        end
        
    end
    
end
            
        
        