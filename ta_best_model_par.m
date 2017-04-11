studies = {'E0E3'};
types = {'ta' 'tvc'}; %use only two types

for i = 1:length(studies)

    for j = 1:length(types)   
        load([studies{i} types{j} '.mat'])    
    end
    
    parfor j = 1:length(types)
        
        if strcmp(types{j},'ta')
            
            pa_ta = pa_best_model(pa_ta);
            
        elseif strcmp(types{j},'tvc')
            
            pa_tvc = pa_best_model(pa_tvc);
            
        end
        
    end
    
end