for i = 1:length(subjects)
    
    for r = 1:runs(i)
                    
    
        %temp string variable used to find specific edf file
        for cc = 1:length(pathsub)
            if any(pathsub{cc} == i)
                pind = cc;
            end
        end
        
        if strcmp(studystr,'E0') || strcmp(studystr,'E3') || strcmp(studystr,'E0E3')
            a = dir(sprintf(edffind,TAeyepaths{pind},subjects{i},locs(end-1),r));
        elseif strcmp(studystr,'E5')
            for j = 1:3
                switch j
                    case 1
                        a(1) = dir(sprintf('%s/%s/*_run01_P*.edf',TAeyepaths{pind}, subjects{i}));
                    case 2
                        a(2) = dir(sprintf('%s/%s/*_run01W_P*.edf',TAeyepaths{pind}, subjects{i}));
                    case 3
                        a(3) = dir(sprintf('%s/%s/*%s1W*.edf',TAeyepaths{pind}, subjects{i}, subjects{i}));
                end
            end
        end
%         a = dir(sprintf('%s/%s/*%d_run0%d*.edf',TAeyepaths{pind}, subjects{i},t2time,r)); 
           

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
        cd([TAeyepaths{pind} subjects{i}])

        %import data from edffile
        if length(a) == 1
            eye = edfmex(edffile);
        else
            for k = 1:length(a)
                eval(sprintf('eye%d = edfmex(edffile%d);',k,k))
            end
        end

        %temp string for study specific .mat file
        
        if strcmp(studystr,'E0') || strcmp(studystr,'E3') || strcmp(studystr,'E0E3')
            b = dir(sprintf(matfind,TAdatapaths{pind},subjects{i},locs(end-1),r));
        elseif strcmp(studystr,'E5')
            b = dir(sprintf(matfind,TAdatapaths{pind}, subjects{i}));
        end
        
        if length(b) == 1
            matfile = b.name;
        else
            matfile = b(length(b)).name;
        end
        
        cd([TAdatapaths{pind} subjects{i}])
        
        load(matfile)
        
%         b = dir(sprintf('%s/%s/*%d_run0%d*Temp*.mat',TAdatapath, subjects{i},t2time,r));

        %string of exact .mat file name
%         if length(b) == 1
%             matfile = b.name;
%         else
%             matfile = b(length(b)).name;
%         end
% 
%         %change directory to folder containing file
%         cd([TAdatapath subjects{i}])

        %load the .mat file variables
%         eval(sprintf('load %s',matfile));
        
        %temporary matrix containing a trial-time series of all trials of
        %one run of a subject
        if length(a) == 1
            [trialmatx, rawpa] = eventtimeseries(eye,'gx','EVENT_CUE',window,1000,0);
        else
            for k = 1:length(a)
                eval(sprintf('[trialmatx%d rawpa%d] = eventtimeseries(eye%d,''gx'',''EVENT_CUE'',window,0);',k,k,k))
            end
            trialmatx2(end,:) = [];
            trialmatx = [trialmatx2 ; trialmatx1];
            rawpa = [rawpa2 rawpa1];
        end

%         figure
%         plot(1:length(rawpa),rawpa)
%         title(sprintf('pa vs time (run %d, subject %s)',r,subjects{i}))
%         xlabel('time (ms)')
%         ylabel('pa')

%         figure
%         imagesc(trialmatx)
%         title(sprintf('imagesc (run %d, subject %s)',r,subjects{i}))
        

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
            elseif all(trialmatx(j,-window(1)+1:postcue-window(1)+1)) == 0  
                trialmatx(j,:) = nan(1,duration);
            end
        end
        
        trialmatx(trialmatx > 10000) = nan;
        
        trialmatx(trialmatx < -10000) = nan;
        
        trialmatx(trialmatx == -32768) = nan;
        
%         figure
%         imagesc(trialmatx)
%         title(sprintf('imagesc (run %d, subject %s)',r,subjects{i}))
        
%         base = nanmean(trialmatx(:,1:-window(1)),2);
%         
%         for j = 1:size(trialmatx,1)
%             trialmatx(j,1:duration) = trialmatx(j,1:duration)-base(j);
%         end
        
%         idx = find(strcmp(expt.trials_headers,'cuedInterval'));
%         
%         t1x = zeros(length(find(trialsPresented(:,idx) == 1)),duration);
%         t2x = zeros(length(find(trialsPresented(:,idx) == 2)),duration);
%         neutralx = zeros(length(find(trialsPresented(:,idx) == 0)),duration);
% 
%         x = 1;
%         y = 1;
%         z = 1;
% 
%         %place trials from trialmatx into one of the three condition variables
%         %using information from the .mat file
%         for j = 1:size(trialmatx,1)
%             if trialsPresented(j,idx) == 1
%                 t1x(x,:) = trialmatx(j,:);
%                 x = x+1;
%             elseif trialsPresented(j,idx) == 2
%                 t2x(y,:) = trialmatx(j,:);
%                 y = y+1;
%             elseif trialsPresented(j,idx) == 0
%                 neutralx(z,:) = trialmatx(j,:);
%                 z = z+1;
%             end
%         end
%         figdir = [filedir '/' subjects{i}];            
%         
%         fig = [1 2 3];
%         
%         fignames = {sprintf('run%d',r) sprintf('run%dpreblink',r) sprintf('run%dpostblink',r)};
%         
%         figprefix = 'ta';
%         
%         rd_saveAllFigs(fig,fignames,figprefix,figdir)
        
        %trialmatx = trialmatx - nanmean(nanmean(trialmatx));
        
        ir = abs((trials/runs(i)) - (trials/runs(i))*r);
        
        gtrialmat(ir+1:ir+(trials/runs(i)),1:duration,i) = trialmatx;
        
%         gt1((ir*t1p)+1:(ir*t1p)+(trials/runs(r)*t1p),1:duration,i) = t1x;
%         
%         gt2((ir*t2p)+1:(ir*t2p)+(trials/runs(r)*t2p),1:duration,i) = t2x;
%         
%         gneutral((ir*ntp)+1:(ir*ntp)+(trials/runs(r)*ntp),1:duration,i) = neutralx;
            
%         close all
        
        fprintf('\n')
        
    end
    
    figure
    imagesc(gtrialmat(:,:,i))
    colorbar
    
    
end

cd(homedir)

% if study == 0
%     load eyedataE0.mat
%     filedir = '/Users/jakeparker/Documents/tempatten/E0_cb/xposition';
% elseif study == 3
%     load eyedataE3.mat
%     filedir = '/Users/jakeparker/Documents/tempatten/E3_adjust/xposition';
% end
% 
% gtrialmat(isnan(trialmat)) = nan;
% gt1(isnan(t1)) = nan;
% gt2(isnan(t2)) = nan;
% gneutral(isnan(neutral)) = nan;
% 
% gt1det = nan(1,duration,length(subjects));
% gt2det = nan(1,duration,length(subjects));
% gneutraldet = nan(1,duration,length(subjects));
% 
% for ji = 1:length(subjects)
%     gt1det(1,:,ji) = padetrend(gt1(:,:,ji),nanmean([nanmean(gt1(:,:,ji));nanmean(gt2(:,:,ji));nanmean(gneutral(:,:,ji))]));
%     gt2det(1,:,ji) = padetrend(gt2(:,:,ji),nanmean([nanmean(gt1(:,:,ji));nanmean(gt2(:,:,ji));nanmean(gneutral(:,:,ji))]));
%     gneutraldet(1,:,ji) = padetrend(gneutral(:,:,ji),nanmean([nanmean(gt1(:,:,ji));nanmean(gt2(:,:,ji));nanmean(gneutral(:,:,ji))]));
% end
% 
% 
% gazefigs
% 
% close all