function pa = pa_pairwise(pa,modelnum)

im = modelnum;
pa.Tpairwise = [];
pa.Lpairwise = [];
pa.Bpairwise = [];

conditions = reshape(pa.fields,pa.targets,length(pa.fields)/pa.targets)';
conditions = reshape(conditions,3,length(pa.fields)/3);

for i = 1:size(conditions,2)
    
    target = conditions{1,i}(1:2);
    
    [pa.Tpairwise.([conditions{1,i} '_' conditions{2,i}])(1),...
        pa.Tpairwise.([conditions{1,i} '_' conditions{2,i}])(2)]  = ttest(pa.(conditions{1,i}).models(im).(target),pa.(conditions{2,i}).models(im).(target));
  
    [pa.Tpairwise.([conditions{1,i} '_' conditions{3,i}])(1),...
        pa.Tpairwise.([conditions{1,i} '_' conditions{3,i}])(2)]  = ttest(pa.(conditions{1,i}).models(im).(target),pa.(conditions{3,i}).models(im).(target));
    
    [pa.Tpairwise.([conditions{2,i} '_' conditions{3,i}])(1),...
        pa.Tpairwise.([conditions{2,i} '_' conditions{3,i}])(2)]  = ttest(pa.(conditions{2,i}).models(im).(target),pa.(conditions{3,i}).models(im).(target));
    
    for j = 1:length(pa.locs)
        
        [pa.Lpairwise.([pa.loclabels{j} '_' conditions{1,i} '_' conditions{2,i}])(1),...
            pa.Lpairwise.([pa.loclabels{j} '_' conditions{1,i} '_' conditions{2,i}])(2)]  = ttest(pa.(conditions{1,i}).models(im).locations(:,j),pa.(conditions{2,i}).models(im).locations(:,j));
        
        [pa.Lpairwise.([pa.loclabels{j} '_' conditions{1,i} '_' conditions{3,i}])(1),...
            pa.Lpairwise.([pa.loclabels{j} '_' conditions{1,i} '_' conditions{3,i}])(2)]  = ttest(pa.(conditions{1,i}).models(im).locations(:,j),pa.(conditions{3,i}).models(im).locations(:,j));
        
        [pa.Lpairwise.([pa.loclabels{j} '_' conditions{2,i} '_' conditions{3,i}])(1),...
            pa.Lpairwise.([pa.loclabels{j} '_' conditions{2,i} '_' conditions{3,i}])(2)]  = ttest(pa.(conditions{2,i}).models(im).locations(:,j),pa.(conditions{3,i}).models(im).locations(:,j));
        
    end
    
    for j = 1:length(pa.models(im).Blabels)
        
        [pa.Bpairwise.([pa.models(im).Blabels{j} '_' conditions{1,i} '_' conditions{2,i}])(1),...
            pa.Bpairwise.([pa.models(im).Blabels{j} '_' conditions{1,i} '_' conditions{2,i}])(2)]  = ttest(pa.(conditions{1,i}).models(im).(pa.models(im).Blabels{j}),pa.(conditions{2,i}).models(im).(pa.models(im).Blabels{j}));
        
        [pa.Bpairwise.([pa.models(im).Blabels{j} '_' conditions{1,i} '_' conditions{3,i}])(1),...
            pa.Bpairwise.([pa.models(im).Blabels{j} '_' conditions{1,i} '_' conditions{3,i}])(2)]  = ttest(pa.(conditions{1,i}).models(im).(pa.models(im).Blabels{j}),pa.(conditions{3,i}).models(im).(pa.models(im).Blabels{j}));
        
        [pa.Bpairwise.([pa.models(im).Blabels{j} '_' conditions{2,i} '_' conditions{3,i}])(1),...
            pa.Bpairwise.([pa.models(im).Blabels{j} '_' conditions{2,i} '_' conditions{3,i}])(2)]  = ttest(pa.(conditions{2,i}).models(im).(pa.models(im).Blabels{j}),pa.(conditions{3,i}).models(im).(pa.models(im).Blabels{j}));
        
    end
    
  
end

if strcmp(pa.type,'tvc')
    
    for i = 1:pa.targets
        
        target = ['t' num2str(i)];
        
        [pa.Tpairwise.([target 'vc_' target 'if'])(1),...
            pa.Tpairwise.([target 'vc_' target 'if'])(2)] = ttest(pa.([target 'vc']).models(im).(target),pa.([target 'if']).models(im).(target));
        
        for j = 1:length(pa.locs)
            
            [pa.Lpairwise.([pa.loclabels{j} '_' target 'vc_' target 'if'])(1),...
                pa.Lpairwise.([pa.loclabels{j} '_' target 'vc_' target 'if'])(2)] = ttest(pa.([target 'vc']).models(im).locations(:,j),pa.([target 'if']).models(im).locations(:,j));
            
        end
        
        for j = 1:length(pa.models(im).Blabels)
            
            [pa.Bpairwise.([pa.models(im).Blabels{j} '_' target 'vc_' target 'if'])(1),...
                pa.Bpairwise.([pa.models(im).Blabels{j} '_' target 'vc_' target 'if'])(2)] = ttest(pa.([target 'vc']).models(im).(pa.models(im).Blabels{j}),pa.([target 'if']).models(im).(pa.models(im).Blabels{j}));
            
        end
            
        
    end
    
end

if strcmp(pa.type,'ta')
    
    pa.Lttest = [];
    
    locsum = zeros(length(pa.subjects),length(pa.locs));
    
    for i = 1:length(pa.fields)
        
        locsum = locsum + pa.(pa.fields{i}).models(im).locations;
        
    end
    
    pa.locmeans = locsum ./ length(pa.fields);
    
    for i = 1:length(pa.locs)
        
        [pa.Lttest.(pa.loclabels{i})(1),...
            pa.Lttest.(pa.loclabels{i})(2)] = ttest(pa.locmeans(:,i),pa.locs(i));
        
    end
    
end
    
    
    