function pa = ta_preprocess(pa,study,type)

if strcmp(study,'E0')
    TAeyepaths = {'/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/eyedata/E0_cb/'...
        '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/eyedata/E2_SOA_cbD6/'...
        '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/eyedata/pilot/'};
    TAdatapaths = {'/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/data/E0_cb/'...
        '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/data/E2_SOA_cbD6/'...
        '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/data/pilot/'};
    pathsub = {[1:6] [7 8] [9]};
    edffind = '%s/%s/*%d_run0%d*.edf';
    matfind = '%s/%s/*%d_run0%d*Temp*.mat';
elseif strcmp(study, 'E3')
    TAeyepaths = {'/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/eyedata/E3_adjust/'};
    TAdatapaths = {'/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/data/E3_adjust/'};
    pathsub = {[1:12]};
    edffind = '%s/%s/*%d_run0%d*.edf';
    matfind = '%s/%s/*%d_run0%d*Temp*.mat';
elseif strcmp(study, 'E5')
    TAeyepaths = {'/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/eyedata/E5_T3_cbD15/'};
    TAdatapaths = {'/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/data/E5_T3_cbD15/'};
    pathsub = {[1:10]};
    edffind = 'lol';
    matfind = '%s/%s/*run01WW*Temp*.mat';
end


for p = 1:length(TAeyepaths)
    for s = pathsub{p}
        TAeyepath = TAeyepaths{p};
        TAdatapath = TAdatapaths{p};
        pa = trialsx(pa,TAeyepath,TAdatapath,edffind,matfind,pa.subjects{s},study,type,s);
    end
end

cd('/Users/jakeparker/Documents/MATLAB')

for hi = 1:length(pa.fields)
    for e = 1:length(pa.subjects)
        pa.(pa.fields{hi}).smeans(e,:) = nanmean(pa.(pa.fields{hi}).(pa.subjects{e}),1);
        pa.(pa.fields{hi}).count(e,:) = sum(~isnan(pa.(pa.fields{hi}).(pa.subjects{e})),1);
    end
end
    
for hi = 1:length(pa.fields)
    pa.(pa.fields{hi}).gmean = wmean(pa.(pa.fields{hi}).smeans,pa.(pa.fields{hi}).count);
end
            
for hi = 1:length(pa.fields)
    pa.(pa.fields{hi}).se = wste(pa.(pa.fields{hi}).smeans,pa.(pa.fields{hi}).gmean,pa.(pa.fields{hi}).count);
end

pa.det = zeros(length(pa.fields),pa.duration,length(pa.subjects));

for e = 1:length(pa.subjects)
    for hi = 1:length(pa.fields)
        pa.det(hi,:,e) = pa.(pa.fields{hi}).smeans(e,:);
    end
end

pa.det = squeeze(nanmean(pa.det,1))';

for hi = 1:length(pa.fields)
    for e = 1:length(pa.subjects)
        pa.(pa.fields{hi}).sdetmeans(e,:) = padetrend(pa.(pa.fields{hi}).(pa.subjects{e}),pa.det(e,:));
    end
end

for hi = 1:length(pa.fields)
    pa.(pa.fields{hi}).gdetmean = wmean(pa.(pa.fields{hi}).sdetmeans,pa.(pa.fields{hi}).count);
end

for hi = 1:length(pa.fields)
    pa.(pa.fields{hi}).detse = wste(pa.(pa.fields{hi}).sdetmeans,pa.(pa.fields{hi}).gdetmean,pa.(pa.fields{hi}).count);
end

end

            