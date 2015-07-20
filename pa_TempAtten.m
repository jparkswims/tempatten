%define study specific variables
subjects = {'ad' 'bl' 'ec' 'ty' 'vp' 'zw'}; %ad bl ec ty vp zw

homedir = pwd;

%directories of folders containing specific data files
TAeyepath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/eyedata/E0_cb/';
TAdatapath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/data/E0_cb/';

trials = 640;

runs = 2;

window = [-400 2200];

duration = window(2)-window(1)+1;

trialmat = zeros(trials,duration,length(subjects));

%t1, t2, and neutral (the 3 conditions of the experiment) preloaded
%norm means the set of data has been normalized
t1 = zeros(trials*.4,duration,length(subjects));
t1norm = zeros(trials*.4,duration,length(subjects));

t2 = zeros(trials*.4,duration,length(subjects));
t2norm = zeros(trials*.4,duration,length(subjects));

neutral = zeros(trials*.2,duration,length(subjects));
neutralnorm = zeros(trials*.2,duration,length(subjects));

for i = 1:length(subjects)
    
    for r = 1:runs
    
        %temp string variable used to find specific edf file
        a = dir(sprintf('%s/%s/*0_run0%d*.edf',TAeyepath, subjects{i},r));

        %string of exact name of edffile to be extracted
        if length(a) == 1
            edffile = a.name;
        else
            for k = 1:length(a)
                eval(sprintf('edffile%d = a(%d).name;',k,k))
            end
        end

        %set matlab directory to folder containing file
        cd([TAeyepath subjects{i}])

        %import data from edffile
        if length(a) == 1
            eye = edfmex(edffile);
        else
            for k = 1:length(a)
                eval(sprintf('eye%d = edfmex(edffile%d);',k,k))
            end
        end

        %temp string for study specific .mat file
        b = dir(sprintf('%s/%s/*0_run0%d*Temp*.mat',TAdatapath, subjects{i},r));

        %string of exact .mat file name
        if length(b) == 1
            matfile = b.name;
        else
            matfile = b(length(b)).name;
        end

        %change directory to folder containing file
        cd([TAdatapath subjects{i}])

        %load the .mat file variables
        eval(sprintf('load %s',matfile));
        
        %temporary matrix containing a trial-time series of all trials of
        %one run of a subject
        if length(a) == 1
            [trialmatx, rawpa] = eventtimeseries(eye,'pa','EVENT_CUE',window,0);
        else
            for k = 1:length(a)
                eval(sprintf('[trialmatx%d rawpa%d] = eventtimeseries(eye%d,''pa'',''EVENT_CUE'',window,0);',k,k,k))
            end
            trialmatx2(end,:) = [];
            trialmatx = [trialmatx2 ; trialmatx1];
            rawpa = [rawpa2 rawpa1];
        end

        figure
        plot(1:length(rawpa),rawpa)
        title(sprintf('pa vs time (run %d, subject %s)',r,subjects{i}))
        xlabel('time (ms)')
        ylabel('pa')

        figure
        imagesc(trialmatx)
        title(sprintf('imagesc (run %d, subject %s)',r,subjects{i}))
        

        %variables of data from .mat file defined to allow data to be
        %manipulated according to code
        trialsPresented = expt.trialsPresented.trials;
        trialOrder = expt.trialOrder;

        %first if loop determines if each trial is a valid trial in that no
        %blinks occured or fixation was broken using data from .mat file
        %these trials eliminated
        %second series of nested if loops check if pupil area was ever
        %recorded as being zero in the time series and NaN's the trials
        for j = length(expt.eye.fixT2):-1:1
            if expt.eye.fixT2(j) == 0
                trialmatx(j,:) = [];
                trialsPresented(j,:) = [];
                trialOrder(j,:) = [];
            elseif all(trialmatx(j,-window(1):1750-window(1))) == 0
                trialmatx(j,:) = nan(1,duration);
            end
        end
        
        for j = 1:(trials/2)
            if all(trialmatx(j,1:-window(1))) == 0
                I(1) = find(trialmatx(j,1:-window(1)) == 0,1,'first');
                if I(1) < 21
                   
                    I(1) = 21;
                end
                I(2) = find(trialmatx(j,1:-window(1)) == 0,1,'last');
                if I(2) > -window(1)-50
                    
                    I(2) = -window(1)-50;
                end
                trialmatx(j,I(1)-20:I(2)+50) = nan(1,I(2)-I(1)+71);
            end
            if all(trialmatx(j,1750-window(1)+1:duration)) == 0
                I(1) = find(trialmatx(j,1750-window(1)+1:duration) == 0,1,'first');
                if I(1) < 21
                    
                    I(1) = 21;
                end
                I(2) = find(trialmatx(j,1750-window(1)+1:duration) == 0,1,'last');
                if I(2) > 401
        
                    I(2) = 401;
                end
                trialmatx(j,I(1)-20+1750-window(1):I(2)+50+1750-window(1)) = nan(1,I(2)-I(1)+71);
            end
        end
        
        figure
        imagesc(trialmatx)
        title(sprintf('imagesc (run %d, subject %s)',r,subjects{i}))
        
        switch i
            case 2
            figdir = '/Users/jakeparker/Documents/tempatten/bl';
            case 3
            figdir = '/Users/jakeparker/Documents/tempatten/ec';
            case 4
            figdir = '/Users/jakeparker/Documents/tempatten/ty';
            case 5
            figdir = '/Users/jakeparker/Documents/tempatten/vp';
            case 6
            figdir = '/Users/jakeparker/Documents/tempatten/zw';
            case 1
            figdir = '/Users/jakeparker/Documents/tempatten/ad';
        end
        
        fig = [(3*r-2)+(i-1)*6 (3*r-1)+(i-1)*6 (3*r)+(i-1)*6];
        
        fignames = {sprintf('run%d',r) sprintf('run%dpreblink',r) sprintf('run%dpostblink',r)};
        
        figprefix = 'ta';
        
        rd_saveAllFigs(fig,fignames,figprefix,figdir)
        
        %use data from .mat file to preload variables of each condition
        idx = find(strcmp(expt.trials_headers,'cuedInterval'));

        t1x = zeros(length(find(trialsPresented(:,idx) == 1)),duration);
        t2x = zeros(length(find(trialsPresented(:,idx) == 2)),duration);
        neutralx = zeros(length(find(trialsPresented(:,idx) == 0)),duration);

        x = 1;
        y = 1;
        z = 1;

        %place trials from trialmatx into one of the three condition variables
        %using information from the .mat file
        for j = 1:size(trialmatx,1)
            if trialsPresented(j,idx) == 1
                t1x(x,:) = trialmatx(j,:);
                x = x+1;
            elseif trialsPresented(j,idx) == 2
                t2x(y,:) = trialmatx(j,:);
                y = y+1;
            elseif trialsPresented(j,idx) == 0
                neutralx(z,:) = trialmatx(j,:);
                z = z+1;
            end
        end

        %set baseline values for normalization
        t1base = nanmean(t1x(:,1:-window(1)),2);
        t2base = nanmean(t2x(:,1:-window(1)),2);
        neutralbase = nanmean(neutralx(:,1:-window(1)),2);

        %preload variables for normalized data
        t1normx = zeros(size(t1x,1),duration);
        t2normx = zeros(size(t2x,1),duration);
        neutralnormx = zeros(size(neutralx,1),duration);

        %generate normalized data for each condition type
        for j = 1:size(t1x,1)
            t1normx(j,1:duration) = (t1x(j,1:duration)-t1base(j))/(t1base(j));
        end

        for j = 1:size(t2x,1)
            t2normx(j,1:duration) = (t2x(j,1:duration)-t2base(j))/(t2base(j));
        end

        for j = 1:size(neutralx,1)
            neutralnormx(j,1:duration) = (neutralx(j,1:duration)-neutralbase(j))/(neutralbase(j));
        end
        
        %generate a value based on the predifined variables so that the global time series
        %matrices can be ammended with data in the temprary variables
        ir = abs((trials/2) - (trials/2)*r);
        
        %input data from the temporary (x) variables into the corresponding
        %global matrices
        trialmat(ir+1:ir+(trials/2),1:duration,i) = trialmatx;

        t1((ir*0.4)+1:(ir*0.4)+(trials*0.2),1:duration,i) = t1x;
        t1norm((ir*0.4)+1:(ir*0.4)+(trials*0.2),1:duration,i) = t1normx;

        t2((ir*0.4)+1:(ir*0.4)+(trials*0.2),1:duration,i) = t2x;
        t2norm((ir*0.4)+1:(ir*0.4)+(trials*0.2),1:duration,i) = t2normx;

        neutral((ir*0.2)+1:(ir*0.2)+(trials*0.1),1:duration,i) = neutralx;
        neutralnorm((ir*0.2)+1:(ir*0.2)+(trials*0.1),1:duration,i) = neutralnormx;
        
    end
   
    
end

cd(homedir)