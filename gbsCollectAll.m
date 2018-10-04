%gbsCollectAll
type = 'ta';
datadir = '/Users/jakeparker/Google Drive/TA_Pupil/HPC/';

load(['E0E3' type '_noL.mat'])
subjects = pa_ta.subjects;
fields = pa_ta.fields;
clear pa_ta gbs

gbsall = struct('subjects',{subjects},'fields',{fields});
for s = 1:length(subjects)
    load([datadir type '_noL/fit/gbs_E0E3' type '_' subjects{s} '.mat'])
    gbsall.(subjects{s}) = gbs;
end

save([datadir type '_noL/fit/gbs_E0E3' type '_ALL.mat'],'gbsall')