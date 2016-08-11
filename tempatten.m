close all

groups = 0;
gaze = 0;

study = input('For E0 enter 0\nFor E2 enter 2\nFor E3 enter 3\nFor E5 enter 5\nSelect Study:');

homedir = '/Users/jakeparker/Documents/MATLAB';

if study == 0
    
    subjects = {'ma' 'ad' 'bl' 'ec' 'ty' 'zw'}; %E0 'ma' 'ad' 'bl' 'ec' 'ty' 'vp' 'zw'
    TAeyepath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/eyedata/E0_cb/';
    TAdatapath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/data/E0_cb/';
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
    if groups == 0
        if gaze == 0
            filedir = '/Users/jakeparker/Documents/tempatten/E0_cb/t1-t2-n';
            trialmat = nan(trials,duration,length(subjects));
            t1 = nan(trials*.4,duration,length(subjects));
            t1norm = nan(trials*.4,duration,length(subjects));
            t2 = nan(trials*.4,duration,length(subjects));
            t2norm = nan(trials*.4,duration,length(subjects));
            neutral = nan(trials*.2,duration,length(subjects));
            neutralnorm = nan(trials*.2,duration,length(subjects));
        elseif gaze == 1
            filedir = '/Users/jakeparker/Documents/tempatten/E0_cb/yposition';
            gtrialmat = nan(trials,duration,length(subjects));
            gt1 = nan(trials*.4,duration,length(subjects));
            gt2 = nan(trials*.4,duration,length(subjects));
            gneutral = nan(trials*.2,duration,length(subjects));
        end
    elseif groups == 1
        filedir = '/Users/jakeparker/Documents/tempatten/E0_cb';
        pa = struct('t1ac',[],'t2ac',[],'t1ai',[],'t2ai',[],'t1nc',[],'t2nc',[],'t1ni',[],'t2ni',[],'t1uc',[],'t2uc',[],'t1ui',[],'t2ui',[],'trialmat',nan(trials,duration,length(subjects)),'subjects',{subjects});
        pafields = fields(pa);
        for hi = 1:length(pafields)-2
            for ijk = 1:length(subjects)
                pa.(pafields{hi}).(subjects{ijk}) = [];
            end
        end
    end
    soas = 250;
    mblink = 5;

elseif study == 3
    
    subjects = {'bl' 'ca' 'ec' 'en' 'ew' 'id' 'jl' 'jx' 'ld' 'ml' 'rd' 'sj'}; %E3 'bl' 'ca' 'ec' 'en' 'ew' 'id' 'jl' 'jx' 'ld' 'ml' 'rd' 'sj'
    % subject id sample rate = 500
    TAeyepath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/eyedata/E3_adjust/';
    TAdatapath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/data/E3_adjust/';
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
    if groups == 0
        if gaze == 0
            filedir = '/Users/jakeparker/Documents/tempatten/E3_adjust/t1-t2-n';
            trialmat = nan(trials,duration,length(subjects));
            t1 = nan(trials*.4,duration,length(subjects));
            t1norm = nan(trials*.4,duration,length(subjects));
            t2 = nan(trials*.4,duration,length(subjects));
            t2norm = nan(trials*.4,duration,length(subjects));
            neutral = nan(trials*.2,duration,length(subjects));
            neutralnorm = nan(trials*.2,duration,length(subjects));
        elseif gaze == 1
            filedir = '/Users/jakeparker/Documents/tempatten/E3_adjust/yposition';
            gtrialmat = nan(trials,duration,length(subjects));
            gt1 = nan(trials*.4,duration,length(subjects));
            gt2 = nan(trials*.4,duration,length(subjects));
            gneutral = nan(trials*.2,duration,length(subjects));
        end
    elseif groups == 1
        filedir = '/Users/jakeparker/Documents/tempatten/E3_adjust';
        pa = struct('t1ac',[],'t2ac',[],'t1ai',[],'t2ai',[],'t1nc',[],'t2nc',[],'t1ni',[],'t2ni',[],'t1uc',[],'t2uc',[],'t1ui',[],'t2ui',[],'trialmat',nan(trials,duration,length(subjects)),'subjects',{subjects});
        pafields = fields(pa);
        for hi = 1:length(pafields)-2
            for ijk = 1:length(subjects)
                pa.(pafields{hi}).(subjects{ijk}) = [];
            end
        end
    end
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

elseif study == 5
    
    pac.subjects = {'ds' 'gb' 'gb2' 'ht' 'ik' 'jg' 'jp' 'rd' 'xw' 'yz'};
    pac.TAeyepath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/eyedata/E5_T3_cbD15/';
    pac.TAdatapath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/data/E5_T3_cbD15/';
    pac.filedir = '/Users/jakeparker/Documents/tempatten/E5/t1-t2-t3-n';
    pac.window = [-400 3500];
    pac.duration = pac.window(2)-pac.window(1)+1;
    pac.locs = [0 1000 1250 1500 2000];
    trials = 960;
    if groups == 0
        pac.trialmat = nan(trials,pac.duration,length(pac.subjects));
%         tp = (4/5)*(1/3);
%         np = 1/5;
        for lol = 1:length(pac.subjects)
            pac.t1.(pac.subjects{lol}) = [];
            pac.t2.(pac.subjects{lol}) = [];
            pac.t3.(pac.subjects{lol}) = [];
            pac.neutral.(pac.subjects{lol}) = [];
        end
%         pac.t1 = nan(trials*tp,duration,length(subjects));
%         pac.t1norm = nan(265,pac.duration,length(pac.subjects));
%         pac.t2 = nan(trials*tp,duration,length(subjects));
%         pac.t2norm = nan(238,pac.duration,length(pac.subjects));
%         pac.t3 = nan(trials*tp,duration,length(subjects));
%         pac.t3norm = nan(265,pac.duration,length(pac.subjects));
%         pac.neutral = nan(trials*np,duration,length(subjects));
%         pac.neutralnorm = nan(trials*np,pac.duration,length(pac.subjects));
    end
        
else
    
    fprintf('No\n')
end

if study ~= 5
    for iSOA = 1:numel(soas)

        t2time = t1time + soas(iSOA);
        postcue = t2time + 500;

        if study == 2

            filedir = ['/Users/jakeparker/Documents/tempatten/E2_soa_cbD6/' int2str(soas(iSOA))];

        end

        if groups == 0 && gaze == 0
            pa_TempAtten
        elseif groups == 1 && gaze == 0
            pa = pagroups_tempatten(subjects, runs, TAeyepath, t2time, TAdatapath, window, postcue, duration, mblink, pa, trials,pafields);

            pafigs(pa.t1vc,pa.t2vc,pa.nc,postcue,t2time,window,subjects,[filedir '/v-c'])
            pafigs(pa.t1vi,pa.t2vi,pa.ni,postcue,t2time,window,subjects,[filedir '/v-i'])
            pafigs(pa.t1ic,pa.t2ic,pa.nc,postcue,t2time,window,subjects,[filedir '/i-c'])
            pafigs(pa.t1ii,pa.t2ii,pa.ni,postcue,t2time,window,subjects,[filedir '/i-i'])
        elseif groups == 0 && gaze ==1
            gxy_tempatten
        end
    %     pa_TempAtten
        %pa = pagroups_tempatten(subjects, runs, TAeyepath, t2time, TAdatapath, window, postcue, duration, mblink, pa, trials); 
        %pa_TempAtten or gxy_tempatten or pagroups_tempatten
    %     gxy_tempatten

    %     pafigs(pa.t1vc,pa.t2vc,pa.nc,postcue,t2time,window,subjects,[filedir '/v-c'])
    %     pafigs(pa.t1vi,pa.t2vi,pa.ni,postcue,t2time,window,subjects,[filedir '/v-i'])
    %     pafigs(pa.t1ic,pa.t2ic,pa.nc,postcue,t2time,window,subjects,[filedir '/i-c'])
    %     pafigs(pa.t1ii,pa.t2ii,pa.ni,postcue,t2time,window,subjects,[filedir '/i-i'])
    end
else
    pac = pa_tempattenT3(pac);

    T3figs(oac)

end
    