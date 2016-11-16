function cost = best_model(pa)

cost = zeros(10,1);

for f = 1:length(pa.fields)
    
    for s = 1:length(pa.subjects)
        
        costx = model_comp(pa.(pa.fields{f}).smeans(s,:),pa);
        
        cost = cost + costx;
        
    end
    
end