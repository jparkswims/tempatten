for i = 1:length(subjects)
    
    for r = 1:runs
                    
    
        %temp string variable used to find specific edf file
        
            
        a = dir(sprintf('%s/%s/*%d_run0%d*.edf',TAeyepath, subjects{i},t2time,r)); 
           

        %string of exact name of edffile to be extracted
        if isempty(a)
            fprintf('Broke on subject %s run %d',i,r)
            break
        end
        
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
        
            
        b = dir(sprintf('%s/%s/*%d_run0%d*Temp*.mat',TAdatapath, subjects{i},t2time,r));

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
            [trialmatx, rawpa] = eventtimeseries(eye,'pa','EVENT_CUE',window,1000,0);
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
            elseif all(trialmatx(j,-window(1):postcue-window(1))) == 0  
                trialmatx(j,:) = nan(1,duration);
            end
        end
        
        trialmatx = noblink(trialmatx,1,-window(1),100,-window(1)+1,-window(1)+1000,0,0,mblink);
        
        trialmatx = noblink(trialmatx,postcue-window(1),duration,100,-window(1)+1,-window(1)+1000,0,0,mblink);
        
        figure
        imagesc(trialmatx)
        title(sprintf('imagesc (run %d, subject %s)',r,subjects{i}))
        
        figdir = [filedir '/' subjects{i}];            
        
        fig = [1 2 3];
        
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
        ir = abs((trials/runs) - (trials/runs)*r);
        
        %input data from the temporary (x) variables into the corresponding
        %global matrices
        trialmat(ir+1:ir+(trials/runs),1:duration,i) = trialmatx;

        t1((ir*t1p)+1:(ir*t1p)+(trials/runs*t1p),1:duration,i) = t1x;
        t1norm((ir*t1p)+1:(ir*t1p)+(trials/runs*t1p),1:duration,i) = t1normx;

        t2((ir*t2p)+1:(ir*t2p)+(trials/runs*t2p),1:duration,i) = t2x;
        t2norm((ir*t2p)+1:(ir*t2p)+(trials/runs*t2p),1:duration,i) = t2normx;

        neutral((ir*ntp)+1:(ir*ntp)+(trials/runs*ntp),1:duration,i) = neutralx;
        neutralnorm((ir*ntp)+1:(ir*ntp)+(trials/runs*ntp),1:duration,i) = neutralnormx;
        
        close all
        
        fprintf('\n')
        
       
        
    end
   
    
end

t1normwm = zeros(1,duration);
t2normwm = zeros(1,duration);
neutralnormwm = zeros(1,duration);
countt1 = zeros(length(subjects),size(t1norm,2));
countt2 = zeros(length(subjects),size(t1norm,2));
countn = zeros(length(subjects),size(t1norm,2));

for fs = 1:length(subjects)
    countt1(fs,:) = sum(~isnan(t1norm(:,:,fs)),1);
    t1normwm = t1normwm + (nanmean(t1norm(:,:,fs),1) .* countt1(fs,:)); %nansum
    countt2(fs,:) = sum(~isnan(t2norm(:,:,fs)),1);
    t2normwm = t2normwm + (nanmean(t2norm(:,:,fs),1) .* countt2(fs,:)); %nansum
    countn(fs,:) = sum(~isnan(neutralnorm(:,:,fs)),1);
    neutralnormwm = neutralnormwm + (nanmean(neutralnorm(:,:,fs),1) .* countn(fs,:)); %nansum
end

t1normwm = t1normwm ./ sum(countt1,1);
t2normwm = t2normwm ./ sum(countt2,1);
neutralnormwm = neutralnormwm ./ sum(countn,1);

cd(homedir)

close all

TAfigs

close all

TAdetrend

TAfigsdet

close all

switch study
    case 0
        save eyedataE0.mat
    case 2
        eval(sprintf('save eyedataE2soa%d.mat',soas(iSOA)))
    case 3
        save eyedataE3.mat
end