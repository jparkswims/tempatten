function r_anova(pa,varargin)

cd('/Users/jakeparker/Documents/R/code/tempatten')

bdf = pa.bdf;

if strcmp(varargin,'positive')
    study_type = pa.type;
    study_type(end) = [];
    
    for i = size(bdf,1):-1:1
        
        if bdf(i,end-1) == 2
            
            bdf(i,:) = [];
            
        end
        
    end
    
    bdf(:,end-1) = [];
    
else
    
    study_type = pa.type;
    
end

save('paANOVA.mat','bdf','study_type')

cd('/Users/jakeparker/Documents/MATLAB')