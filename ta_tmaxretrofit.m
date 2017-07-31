%ta_tmaxretrofit
studies = {'E0E3' 'E0' 'E3'};
types = {'cue' 'ta' 'tvc'};

close all

for s = 1:length(studies)
    
    study = studies{s};
    
    for t = 1:length(types)
        
        type = types{t};
        
        load([study type '.mat'])
        
        if strcmp(type,'cue')
            
            pa_cue = tmaxretrofit(pa_cue);
            save([study type '.mat'],'pa_cue')
            clear pa_cue
            
        elseif strcmp(type,'ta')
            
            pa_ta = tmaxretrofit(pa_ta);
            save([study type '.mat'],'pa_ta')
            clear pa_ta
            
        elseif strcmp(type,'tvc')
            
            pa_tvc = tmaxretrofit(pa_tvc);
            save([study type '.mat'],'pa_tvc')
            clear pa_tvc
            
        end
        
    end
    
end