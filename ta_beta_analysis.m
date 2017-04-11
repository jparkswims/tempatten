studies = {'E0' 'E3' 'E0E3'};
types = {'ta' 'tvc'};
modelnum = [1 2 3 4];
Btype = {'target' 'precue' 't1' 't2' 'postcue' 'decision'};

close all

for s = 1:length(studies)
    
    study = studies{s};
    
    for t = 1:length(types)
        
        type = types{t};
        load([study type '.mat'])
        
        for b = 1:length(Btype)
            
            for m = modelnum
                
                if strcmp(type,'cue')
                    
                    pa_cue = pa_beta_analysis(pa_cue,m,Btype{b});
                    %             save([study type '.mat'],'pa_cue')
                    %             clear pa_cue
                    
                elseif strcmp(type,'ta')
                    
                    pa_ta = pa_beta_analysis(pa_ta,m,Btype{b});
                    %             save([study type '.mat'],'pa_ta')
                    %             clear pa_ta
                    
                elseif strcmp(type,'tvc')
                    
                    pa_tvc = pa_beta_analysis(pa_tvc,m,Btype{b});
                    %             save([study type '.mat'],'pa_tvc')
                    %             clear pa_tvc
                    
                end
                
            end
            
        end
        
    end
    
end

close all