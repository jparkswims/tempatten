close all

study = input('For E0 enter 0\nFor E2 enter 2\nFor E3 enter 3\nSelect Study:');

homedir = '/Users/jakeparker/Documents/MATLAB';

if study == 0
    
    subjects = {'ma' 'ad' 'bl' 'ec' 'ty' 'vp' 'zw'}; %E0 'ma' 'ad' 'bl' 'ec' 'ty' 'vp' 'zw'
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
    window = [-400 3000];
    duration = window(2)-window(1)+1;
    trialmat = nan(trials,duration,length(subjects));
    t1 = nan(trials*.4,duration,length(subjects));
    t1norm = nan(trials*.4,duration,length(subjects));
    t2 = nan(trials*.4,duration,length(subjects));
    t2norm = nan(trials*.4,duration,length(subjects));
    neutral = nan(trials*.2,duration,length(subjects));
    neutralnorm = nan(trials*.2,duration,length(subjects));
    soas = 250;
    mblink = 5;

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
    window = [-400 3000];
    duration = window(2)-window(1)+1;
    trialmat = nan(trials,duration,length(subjects));
    t1 = nan(trials*.4,duration,length(subjects));
    t1norm = nan(trials*.4,duration,length(subjects));
    t2 = nan(trials*.4,duration,length(subjects));
    t2norm = nan(trials*.4,duration,length(subjects));
    neutral = nan(trials*.2,duration,length(subjects));
    neutralnorm = nan(trials*.2,duration,length(subjects));
    soas = 250;
    mblink = 5;
    
elseif study == 2
    
    subjects = {'hl' 'ho' 'rd' 'vp'}; %E2 'hl' 'ho' 'kc' 'rd' 'vp'
    % subject kc has no .mat files
    % subject vp run 1 soa 400 trialmatx incorrectly loaded for some
    % reason, 325 in length instead of 160
    % subject ho run 1 soa 450 trialmatx length 333
    TAeyepath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/eyedata/E2_soa_cbD6/';
    TAdatapath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/data/E2_soa_cbD6/';
    filedir = '/Users/jakeparker/Documents/tempatten/E2_soa_cbD6';
    trials = 960;
    t1time = 1000;
    t2time = 1100;
    postcue = t2time + 500;
    t1p = 0.4;
    t2p = 0.4;
    ntp = 0.2;
    runs = 6;
    window = [-400 3000];
    duration = window(2)-window(1)+1;
    trialmat = nan(trials,duration,length(subjects));
    t1 = nan(trials*.4,duration,length(subjects));
    t1norm = nan(trials*.4,duration,length(subjects));
    t2 = nan(trials*.4,duration,length(subjects));
    t2norm = nan(trials*.4,duration,length(subjects));
    neutral = nan(trials*.2,duration,length(subjects));
    neutralnorm = nan(trials*.2,duration,length(subjects));
    soas = [100:50:500 800]; %100:50:500 800
    mblink = 5;
    
else
    
    fprintf('No\n')
end

for iSOA = 1:numel(soas)
    
    t2time = t1time + soas(iSOA);
    postcue = t2time + 500;
    
    if study == 2
           
        filedir = ['/Users/jakeparker/Documents/tempatten/E2_soa_cbD6/' int2str(soas(iSOA))];
            
    end
    
    pa_TempAtten
end