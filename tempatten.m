close all

study = input('For E0 enter 0\nFor E2 enter 2\nFor E3 enter 3\nSelect Study:');

homedir = '/Users/jakeparker/Documents/MATLAB';

if study == 0
    
    subjects = {'ad' 'bl' 'ec' 'ty' 'vp' 'zw'}; %E0 'ad' 'bl' 'ec' 'ty' 'vp' 'zw'
    TAeyepath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/eyedata/E0_cb/';
    TAdatapath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/data/E0_cb/';
    filedir = '/Users/jakeparker/Documents/tempatten/E0_cb';
    trials = 640;
    t1time = 1000;
    t2time = 1250;
    postcue = t2time + 500;
    t1p = 0.4;
    t2p = 0.4;
    ntp = 0.2;
    runs = 2;
    window = [-400 2500];
    duration = window(2)-window(1)+1;
    trialmat = zeros(trials,duration,length(subjects));
    t1 = zeros(trials*.4,duration,length(subjects));
    t1norm = zeros(trials*.4,duration,length(subjects));
    t2 = zeros(trials*.4,duration,length(subjects));
    t2norm = zeros(trials*.4,duration,length(subjects));
    neutral = zeros(trials*.2,duration,length(subjects));
    neutralnorm = zeros(trials*.2,duration,length(subjects));

elseif study == 3
    
    subjects = {'bl' 'ca' 'ec' 'en' 'ew' 'id' 'jl' 'jx' 'ld' 'ml' 'rd' 'sj'}; %E3 'bl' 'ca' 'ec' 'en' 'ew' 'id' 'jl' 'jx' 'ld' 'ml' 'rd' 'sj'
    % subject id sample rate = 500
    TAeyepath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/eyedata/E3_adjust/';
    TAdatapath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/data/E3_adjust/';
    filedir = '/Users/jakeparker/Documents/tempatten/E3_adjust';
    trials = 640;
    t1time = 1000;
    t2time = 1250;
    postcue = t2time + 500;
    t1p = 0.4;
    t2p = 0.4;
    ntp = 0.2;
    runs = 4;
    window = [-400 2500];
    duration = window(2)-window(1)+1;
    trialmat = zeros(trials,duration,length(subjects));
    t1 = zeros(trials*.4,duration,length(subjects));
    t1norm = zeros(trials*.4,duration,length(subjects));
    t2 = zeros(trials*.4,duration,length(subjects));
    t2norm = zeros(trials*.4,duration,length(subjects));
    neutral = zeros(trials*.2,duration,length(subjects));
    neutralnorm = zeros(trials*.2,duration,length(subjects));
    
elseif study == 2
    
    subjects = {'hl' 'ho' 'rd' 'vp'}; %E2 'hl' 'ho' 'rd' 'vp'
    TAeyepath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/eyedata/E2_soa_cbD6/';
    TAdatapath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/data/E2_soa_cbD6/';
    filedir = '/Users/jakeparker/Documents/tempatten/E2_soa_cbD6';
    trials = 160;
    t1time = 1000;
    t2time = 1100;
    postcue = t2time + 500;
    t1p = 0.4;
    t2p = 0.4;
    ntp = 0.2;
    runs = 1;
    window = [-400 2500];
    duration = window(2)-window(1)+1;
    trialmat = zeros(trials,duration,length(subjects));
    t1 = zeros(trials*.4,duration,length(subjects));
    t1norm = zeros(trials*.4,duration,length(subjects));
    t2 = zeros(trials*.4,duration,length(subjects));
    t2norm = zeros(trials*.4,duration,length(subjects));
    neutral = zeros(trials*.2,duration,length(subjects));
    neutralnorm = zeros(trials*.2,duration,length(subjects));
    soa = 10;
    soas = [100:50:500 800];
    
else
    
    fprintf('No\n')
end

for iSOA = 1:numel(soas)
    soa = soas(iSOA);
    t2time = t1time + soa;
    postcue = t2time + 500;
    
    pa_TempAtten
end

if study == 0 || study == 3
    
    pa_TempAtten
    
elseif study == 2
    
    for s=1:soa
        
        pa_TempAtten
        
        if t2time < 1500
            
            t2time = t2time + 50;
            
            postcue = t2time + 500;
            
            
        else
            
            t2time = t2time + 300;
            
            postcue = t2time + 500;
        end
    end
end