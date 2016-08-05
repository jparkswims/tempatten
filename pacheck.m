TAeyepath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/eyedata/E5_T3_cbD15/';
TAdatapath = '/Volumes/purplab/EXPERIMENTS/1_Current Experiments/Rachel/Temporal_Attention/data/E5_T3_cbD15/';

subject = 'ds';
r = 1;
window = [-400 3500];
duration = window(2)-window(1)+1;
mblink = 5;

t1time = 1000;
t2time = 1250;
t3time = 1500;
postcue = t3time + 500;

for i = 1:3
    switch i
        case 1
            a(1) = dir(sprintf('%s/%s/*_run0%d_P*.edf',TAeyepath, subject,r)); 
        case 2
            a(2) = dir(sprintf('%s/%s/*_run0%dW_P*.edf',TAeyepath, subject,r)); 
        case 3
            a(3) = dir(sprintf('%s/%s/*%s1W*.edf',TAeyepath, subject, subject));
    end
end
    
           

        %string of exact name of edffile to be extracted
        if isempty(a)
            fprintf('Broke on subject %s run %d',1,r)
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
        cd([TAeyepath subject])

        %import data from edffile
        if length(a) == 1
            eye = edfmex(edffile);
        else
            for k = 1:length(a)
                eval(sprintf('eye%d = edfmex(edffile%d);',k,k))
            end
        end

        %temp string for study specific .mat file
        
            
        b = dir(sprintf('%s/%s/*run0%dWW*Temp*.mat',TAdatapath, subject,r));

        %string of exact .mat file name
        if length(b) == 1
            matfile = b.name;
        else
            matfile = b(length(b)).name;
        end

        %change directory to folder containing file
        cd([TAdatapath subject])

        %load the .mat file variables
        eval(sprintf('load %s',matfile));
        
        %temporary matrix containing a trial-time series of all trials of
        %one run of a subject
        if length(a) == 1
            [trialmatx, rawpa] = eventtimeseries(eye,'pa','EVENT_CUE',window,1000,0);
        else
            for k = 1:length(a)
                eval(sprintf('[trialmatx%d rawpa%d etimepoints%d] = eventtimeseries(eye%d,''pa'',''EVENT_CUE'',window,0);',k,k,k,k))
            end
%             trialmatx2(end,:) = [];
%             trialmatx = [trialmatx2 ; trialmatx1];
            rawpa = [rawpa1 rawpa2 rawpa3];
            trialmatx = [trialmatx1 ; trialmatx2 ; trialmatx3];
        end
        
        figure
        plot(1:length(rawpa),rawpa)
        title(sprintf('pa vs time (run %d, subject %s)',r,subject))
        xlabel('time (ms)')
        ylabel('pa')

        figure
        imagesc(trialmatx)
        title(sprintf('imagesc (run %d, subject %s)',r,subject))
        

        %variables of data from .mat file defined to allow data to be
        %manipulated according to code
        trialsPresented = expt.trialsPresented.trials;
        trialOrder = expt.trialOrder;

        %first if loop determines if each trial is a valid trial in that no
        %blinks occured or fixation was broken using data from .mat file
        %these trials eliminated
        %second series of nested if loops check if pupil area was ever
        %recorded as being zero in the time series and NaN's the trials
        for j = length(expt.eye.fixRespCue):-1:1
            if expt.eye.fixRespCue(j) == 0
                trialmatx(j,:) = [];
                trialsPresented(j,:) = [];
                trialOrder(j,:) = [];
            elseif all(trialmatx(j,-window(1):postcue-window(1))) == 0  
                trialmatx(j,:) = nan(1,duration);
            end
        end
        
        for j = 1:size(trialmatx,1)
            trialmatx(j,:) = blinkinterp(trialmatx(j,:),5,3,50,75);
        end
        
        figure
        imagesc(trialmatx)
        title(sprintf('imagesc (run %d, subject %s)',r,subject))