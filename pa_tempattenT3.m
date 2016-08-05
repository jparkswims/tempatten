function pac = pa_tempattenT3(pac)

for i = 1:length(pac.subjects)

    for j = 1:3
        switch j
            case 1
                a(1) = dir(sprintf('%s/%s/*_run01_P*.edf',pac.TAeyepath, pac.subjects{i})); 
            case 2
                a(2) = dir(sprintf('%s/%s/*_run01W_P*.edf',pac.TAeyepath, pac.subjects{i})); 
            case 3
                a(3) = dir(sprintf('%s/%s/*%s1W*.edf',pac.TAeyepath,pac.subjects{i}, pac.subjects{i}));
        end
    end



            %string of exact name of edffile to be extracted
            if isempty(a)
                fprintf('Broke on subject %s run 1',pac.subjects{i})
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
            cd([pac.TAeyepath pac.subjects{i}])

            %import data from edffile
            if length(a) == 1
                eye = edfmex(edffile);
            else
                for k = 1:length(a)
                    eval(sprintf('eye%d = edfmex(edffile%d);',k,k))
                end
            end

            %temp string for study specific .mat file


            b = dir(sprintf('%s/%s/*run01WW*Temp*.mat',pac.TAdatapath, pac.subjects{i}));

            %string of exact .mat file name
            if length(b) == 1
                matfile = b.name;
            else
                matfile = b(length(b)).name;
            end

            %change directory to folder containing file
            cd([pac.TAdatapath pac.subjects{i}])

            %load the .mat file variables
            eval(sprintf('load %s',matfile));

            %temporary matrix containing a trial-time series of all trials of
            %one run of a subject
            if length(a) == 1
                [trialmatx, rawpa] = eventtimeseries(eye,'pa','EVENT_CUE',pac.window,1000,0);
            else
                for k = 1:length(a)
                    eval(sprintf('[trialmatx%d rawpa%d etimepoints%d] = eventtimeseries(eye%d,''pa'',''EVENT_CUE'',pac.window,0);',k,k,k,k))
                end
    %             trialmatx2(end,:) = [];
    %             trialmatx = [trialmatx2 ; trialmatx1];
                rawpa = [rawpa1 rawpa2 rawpa3];
                trialmatx = [trialmatx1 ; trialmatx2 ; trialmatx3];
            end

            figure
            plot(1:length(rawpa),rawpa)
            title(sprintf('pa vs time (run 1, subject %s)',pac.subjects{i}))
            xlabel('time (ms)')
            ylabel('pa')

            figure
            imagesc(trialmatx)
            title(sprintf('imagesc (run 1, subject %s)',pac.subjects{i}))


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
                elseif all(trialmatx(j,-pac.window(1):pac.locs(end)-pac.window(1))) == 0  
                    trialmatx(j,:) = nan(1,duration);
                end
            end

            for j = 1:size(trialmatx,1)
                trialmatx(j,:) = blinkinterp(trialmatx(j,:),5,3,50,75);
            end

            figure
            imagesc(trialmatx)
            title(sprintf('imagesc (run 1, subject %s)',pac.subjects{i}))

            figdir = [pac.filedir '/' pac.subjects{i}];            
        
            fig = [1 2 3];

            fignames = {'run01' 'run01preblink' 'run01postblink'};

            figprefix = 'ta';

            rd_saveAllFigs(fig,fignames,figprefix,figdir)

            base = nanmean(trialmatx(:,1:-pac.window(1)),2);

            for j = 1:size(trialmatx,1)
                trialmatx(j,1:pac.duration) = (trialmatx(j,1:pac.duration)-base(j))/base(j);
            end

            pac.trialmat = trialmatx;
            
            idx = find(strcmp(expt.trials_headers,'cuedInterval'));

            t1x = zeros(length(find(trialsPresented(:,idx) == 1)),pac.duration);
            t2x = zeros(length(find(trialsPresented(:,idx) == 2)),pac.duration);
            t3x = zeros(length(find(trialsPresented(:,idx) == 3)),pac.duration);
            neutralx = zeros(length(find(trialsPresented(:,idx) == 0)),pac.duration);

            w = 1; x = 1; y = 1; z = 1;

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
                elseif trialsPresented(j,idx) == 3
                    t3x(w,:) = trialmatx(j,:);
                    w = w+1;
                end
            end

            pac.t1norm(:,:,i) = t1x;
            pac.t2norm(:,:,i) = t2x;
            pac.t3norm(:,:,i) = t3x;
            pac.neutralnorm(:,:,i) = neutralx;

            close all
            
            fprintf('\n')

end

countt1 = zeros(length(pac.subjects),size(pac.t1norm,2));
countt2 = zeros(length(pac.subjects),size(pac.t1norm,2));
countt3 = zeros(length(pac.subjects),size(pac.t1norm,2));
countn = zeros(length(pac.subjects),size(pac.t1norm,2));

for fs = 1:length(subjects)
    countt1(fs,:) = sum(~isnan(pac.t1norm(:,:,fs)),1);
    countt2(fs,:) = sum(~isnan(pac.t2norm(:,:,fs)),1);
    countt3(fs,:) = sum(~isnan(pac.t3norm(:,:,fs)),1);
    countn(fs,:) = sum(~isnan(pac.neutralnorm(:,:,fs)),1);
end

pac.t1normwm = wmean(squeeze(nanmean(pac.t1norm))',countt1);
pac.t2normwm = wmean(squeeze(nanmean(pac.t2norm))',countt2);
pac.t3normwm = wmean(squeeze(nanmean(pac.t3norm))',countt3);
pac.neutralnormwm = wmean(squeeze(nanmean(pac.neutralnorm))',countn);

pac.t1se = wste(squeeze(nanmean(pac.t1norm))',pac.t1normwm,countt1);
pac.t2se = wste(squeeze(nanmean(pac.t2norm))',pac.t2normwm,countt2);
pac.t3se = wste(squeeze(nanmean(pac.t3norm))',pac.t3normwm,countt3);
pac.nse = wste(squeeze(nanmean(pac.neutralnorm))',pac.neutralnormwm,countn);

cd('/Users/jakeparker/Documents/MATLAB')

close all

pac.t1det = zeros(length(pac.subjects),pac.duration);
pac.t2det = zeros(length(pac.subjects),pac.duration);
pac.t3det = zeros(length(pac.subjects),pac.duration);
pac.neutraldet = zeros(length(pac.subjects),pac.duration);

for i = 1:length(pac.subjects)
    pac.t1det(i,:) = padetrend(pac.t1norm(:,:,i),nanmean([nanmean(pac.t1norm(:,:,i)) ; nanmean(pac.t2norm(:,:,i)) ; nanmean(pac.t3norm(:,:,i)) ; nanmean(pac.neutralnorm(:,:,i))]));
    pac.t2det(i,:) = padetrend(pac.t2norm(:,:,i),nanmean([nanmean(pac.t1norm(:,:,i)) ; nanmean(pac.t2norm(:,:,i)) ; nanmean(pac.t3norm(:,:,i)) ; nanmean(pac.neutralnorm(:,:,i))]));
    pac.t3det(i,:) = padetrend(pac.t3norm(:,:,i),nanmean([nanmean(pac.t1norm(:,:,i)) ; nanmean(pac.t2norm(:,:,i)) ; nanmean(pac.t3norm(:,:,i)) ; nanmean(pac.neutralnorm(:,:,i))]));
    pac.neutraldet(i,:) = padetrend(pac.neutralnorm(:,:,i),nanmean([nanmean(pac.t1norm(:,:,i)) ; nanmean(pac.t2norm(:,:,i)) ; nanmean(pac.t3norm(:,:,i)) ; nanmean(pac.neutralnorm(:,:,i))]));
end

pac.t1detwm = wmean(pac.t1det,countt1);
pac.t2detwm = wmean(pac.t2det,countt2);
pac.t3detwm = wmean(pac.t3det,countt3);
pac.neutraldetwm = wmean(pac.neutraldet,countn);

pac.t1detse = wste(pac.t1det,pac.t1detwm,countt1);
pac.t2detse = wste(pac.t2det,pac.t2detwm,countt2);
pac.t3detse = wste(pac.t3det,pac.t3detwm,countt3);
pac.neutraldetse = wste(pac.neutraldet,pac.neutraldetwm,countn);

% for j = 1:length(pac.subjects)
%     
%     ymin = -0.3;
%     ymax = 0.3;
%     
%     %individual subject conditions normalized data
%     figure
%     subplot(4,1,1)
%     plot(pac.window(1):pac.window(2),pac.t1norm(:,:,j),'color',[.7 .7 .75])
%     hold on
%     plotlines(pac.locs,[ymin ymax])
%     plot(pac.window(1):pac.window(2),nanmean(pac.t1norm(:,:,j)),'b','LineWidth',3)
%     title([pac.subjects{j} ' t1 normalized'])
%     xlabel('time (ms)')
%     ylabel('pupil area (normalized)')
%     ylim([-0.3 0.3])
%     
%     subplot(4,1,2)
%     plot([pac.window(1):pac.window(2),pac.t2norm(:,:,j),'color',[.75 .7 .7])
%     hold on
%     plotlines(pac.locs,[ymin ymax])
%     plot(pac.window(1):pac.window(2),nanmean(pac.t2norm(:,:,j)),'r','LineWidth',3)
%     title([pac.subjects{j} ' t2 normalized'])
%     xlabel('time (ms)')
%     ylabel('pupil area (normalized)')
%     ylim([-0.3 0.3])
% 
%     subplot(4,1,3)
%     plot([pac.window(1):pac.window(2),pac.t3norm(:,:,j),'color',[.75 .75 .7])
%     hold on
%     plotlines(pac.locs,[ymin ymax])
%     plot(pac.window(1):pac.window(2),nanmean(pac.t3norm(:,:,j)),'y','LineWidth',3)
%     title([pac.subjects{j} ' t3 normalized'])
%     xlabel('time (ms)')
%     ylabel('pupil area (normalized)')
%     ylim([-0.3 0.3])
% 
%     subplot(4,1,4)
%     plot(pac.window(1):pac.window(2),pac.neutralnorm(:,:,j),'color',[.7 .75 .7])
%     hold on
%     plotlines(pac.locs,[ymin ymax])
%     plot(pac.window(1):pac.window(2),nanmean(pac.neutralnorm(:,:,j)),'g','LineWidth',3)
%     title([pac.subjects{j} ' neutral normalized'])
%     xlabel('time (ms)')
%     ylabel('pupil area (normalized)')
%     ylim([-0.3 0.3])
% 
%     ymin = -0.1;
%     ymax = 0.3;
%     
%     figure
%     plot(pac.window(1):pac.window(2),nanmean(pac.t1norm(:,:,j)),'b')
%     hold on
%     plot(pac.window(1):pac.window(2),nanmean(pac.t2norm(:,:,j)),'r')
%     plot(pac.window(1):pac.window(2),nanmean(pac.t3norm(:,:,j)),'y')
%     plot(pac.window(1):pac.window(2),nanmean(pac.neutralnorm(:,:,j)),'g')
%     plotlines(pac.locs,[ymin ymax])
%     title([pac.subjects{j} ' all conditions'])
%     xlabel('time (ms)')
%     ylabel('pupil area (normalized)')
%     legend('t1','t2','t3','neutral')
% 
%     ymin = -0.02;
%     ymax = 0.02;
% 
%     figure
%     plot(pac.window(1):pac.window(2),pac.t1det(j,:),'b')
%     hold on
%     plot(pac.window(1):pac.window(2),pac.t2det(j,:),'r')
%     plot(pac.window(1):pac.window(2),pac.t3det(j,:),'y')
%     plot(pac.window(1):pac.window(2),pac.neutraldet(j,:),'g')
%     plotlines(pac.locs,[ymin ymax])
%     title([pac.subjects{j} ' all conditions det'])
%     xlabel('time (ms)')
%     ylabel('pupil area (detrended)')
%     legend('t1','t2','t3','neutral')
% 
%     figdir = [pac.filedir '/' pac.subjects{j}];
%     fig = [1 2 3];
%     fignames = {'conditions_norm' 'all_conditions_norm' 'all_conditions_det'};
%     figprefix = 'ta';
%     rd_saveAllFigs(fig,fignames,figprefix, figdir)
% 
%     close all
% 
% end
% 
% ymin = -0.1;
% ymax = 0.3;
% 
% figure
% subplot(4,1,1)
% plot(pac.window(1):pac.window(2), squeeze(nanmean(pac.t1norm)))
% hold on
% plotlines(pac.locs,[ymin ymax])
% title('t1 subject averages of normalized data')
% xlabel('time (ms)')
% ylabel('pupil area (normalized)')
% ylim([-0.1 0.3])
% 
% subplot(4,1,2)
% plot(pac.window(1):pac.window(2), squeeze(nanmean(pac.t2norm)))
% hold on
% plotlines(pac.locs,[ymin ymax])
% title('t2 subject averages of normalized data')
% xlabel('time (ms)')
% ylabel('pupil area (normalized)')
% ylim([-0.1 0.3])
% 
% subplot(4,1,3)
% plot(pac.window(1):pac.window(2), squeeze(nanmean(pac.t3norm)))
% hold on
% plotlines(pac.locs,[ymin ymax])
% title('t3 subject averages of normalized data')
% xlabel('time (ms)')
% ylabel('pupil area (normalized)')
% ylim([-0.1 0.3])
% 
% subplot(4,1,4)
% plot(pac.window(1):pac.window(2), squeeze(nanmean(pac.neutralnorm)))
% hold on
% plotlines(pac.locs,[ymin ymax])
% title('neutral subject averages of normalized data')
% xlabel('time (ms)')
% ylabel('pupil area (normalized)')
% ylim([-0.1 0.3])
% 
% ymin = -0.05;
% ymax = 0.25;
% 
% figure
% shadedErrorBar(pac.window(1):pac.window(2),pac.t1normwm,pac.t1se,'b',1) %%%%%
% hold on
% shadedErrorBar(pac.window(1):pac.window(2),pac.t2normwm,pac.t2se,'r',1) %%%%
% shadedErrorBar(pac.window(1):pac.window(2),pac.t3normwm,pac.t3se,'y',1) %%%%
% shadedErrorBar(pac.window(1):pac.window(2),pac.neutralnormwm,pac.nse,'g',1) %%%%
% plotlines(pac.locs,[ymin ymax])
% title('group averages (b=t1, r=t2, y=t3, and g=neutral)')
% xlabel('time (ms)')
% ylabel('pupil area (normalized)')
% ylim([-0.05 0.25])
% 
% ymin = -0.1;
% ymax = 0.1;
% 
% figure
% subplot(4,1,1)
% plot(pac.window(1):pac.window(2), pac.t1det)
% hold on
% plotlines(pac.locs,[ymin ymax])
% title('t1 subject averages of detrended data')
% xlabel('time (ms)')
% ylabel('pupil area (detrended)')
% ylim([-0.01 0.01])
% 
% subplot(4,1,2)
% plot(pac.window(1):pac.window(2), pac.t2det)
% hold on
% plotlines(pac.locs,[ymin ymax])
% title('t2 subject averages of detrended data')
% xlabel('time (ms)')
% ylabel('pupil area (detrended)')
% ylim([-0.01 0.01])
% 
% subplot(4,1,3)
% plot(pac.window(1):pac.window(2), pac.t3det)
% hold on
% plotlines(pac.locs,[ymin ymax])
% title('t3 subject averages of detrended data')
% xlabel('time (ms)')
% ylabel('pupil area (detrended)')
% ylim([-0.01 0.01])
% 
% subplot(4,1,4)
% plot(pac.window(1):pac.window(2), pac.neutraldet)
% hold on
% plotlines(pac.locs,[ymin ymax])
% title('neutral subject averages of detrended data')
% xlabel('time (ms)')
% ylabel('pupil area (detrended)')
% ylim([-0.01 0.01])
% 
% figure
% shadedErrorBar(pac.window(1):pac.window(2),pac.t1detwm,pac.t1detse,'b',1)
% hold on
% shadedErrorBar(pac.window(1):pac.window(2),pac.t2detwm,pac.t2detse,'r',1)
% shadedErrorBar(pac.window(1):pac.window(2),pac.t3detwm,pac.t3detse,'y',1)
% shadedErrorBar(pac.window(1):pac.window(2),pac.neutraldetwm,pac.neutraldetse,'g',1)
% plotlines(pac.locs,[ymin ymax])
% title('group averages det (b=t1, r=t2, y=3, and g=neutral)')
% xlabel('time (ms)')
% ylabel('pupil area (detrended)')
% ylim([-0.01 0.01])
% 
% figdir = pac.filedir;
% fig = [1 2 3 4];
% fignames = {'subject_means_norm' 'group_mean_norm' 'subject_means_det' 'group_mean_det'};
% figprefix = 'ta';
% rd_saveAllFigs(fig,fignames,figprefix, figdir)
% 
% close all

