trialcounts = nan(length(pa_tvc.fields),length(pa_tvc.subjects));
subjects = pa_tvc.subjects;
for i = 1:9
    subjects{i} = [subjects{i} 'E0'];
end
for i = 10:21
    subjects{i} = [subjects{i} 'E3'];
end


for i = 1:length(pa_tvc.fields)
    
    for j = 1:length(subjects)
        
        trialcounts(i,j) = size(pa_tvc.(pa_tvc.fields{i}).(subjects{j}),1);
    end
end
    