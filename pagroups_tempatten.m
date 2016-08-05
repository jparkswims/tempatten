function pa = pagroups_tempatten(subjects, runs, TAeyepath, t2time, TAdatapath, window, postcue, duration, mblink, pa, trials,pafields)

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

%         figure
%         plot(1:length(rawpa),rawpa)
%         title(sprintf('pa vs time (run %d, subject %s)',r,subjects{i}))
%         xlabel('time (ms)')
%         ylabel('pa')
% 
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
            elseif all(trialmatx(j,-window(1):postcue-window(1))) == 0  
                trialmatx(j,:) = nan(1,duration);
            end
        end
        
        for j = 1:size(trialmatx,1)
            trialmatx(j,:) = blinkinterp(trialmatx(j,:),5,3,50,75);
        end
        
        %trialmatx = noblink(trialmatx,1,-window(1),100,-window(1)+1,-window(1)+1000,0,0,mblink);
        
        %trialmatx = noblink(trialmatx,postcue-window(1),duration,100,-window(1)+1,-window(1)+1000,0,0,mblink);
        
        base = nanmean(trialmatx(:,1:-window(1)),2);
        
        for j = 1:size(trialmatx,1)
            trialmatx(j,1:duration) = (trialmatx(j,1:duration)-base(j))/base(j);
        end
        
        ir = abs((trials/runs) - (trials/runs)*r);
        
        pa.trialmat(ir+1:ir+(trials/runs),1:duration,i) = trialmatx;
%         figure
%         imagesc(trialmatx)
%         title(sprintf('imagesc (run %d, subject %s)',r,subjects{i}))
%         
%         figdir = [filedir '/' subjects{i}];            
%         
%         fig = [1 2 3];
%         
%         fignames = {sprintf('run%d',r) sprintf('run%dpreblink',r) sprintf('run%dpostblink',r)};
%         
%         figprefix = 'ta';
%         
%         rd_saveAllFigs(fig,fignames,figprefix,figdir)
        
        %use data from .mat file to preload variables of each condition
        ival = find(strcmp(expt.trials_headers,'cueValidity'));
        icor = find(strcmp(expt.trials_headers,'correct'));
        icue = find(strcmp(expt.trials_headers,'respInterval'));

        x1 = 1; x2 = 1; x3 = 1; x4 = 1; x5 = 1; x6 = 1;
        y1 = 1; y2 = 1; y3 = 1; y4 = 1; y5 = 1; y6 = 1;

        t1acx = []; t1ucx = []; t1ncx = []; t1aix = []; t1uix = []; t1nix = [];
        t2acx = []; t2ucx = []; t2ncx = []; t2aix = []; t2uix = []; t2nix = [];

        for j = 1:size(trialmatx,1)
            if trialsPresented(j,icue) == 1
                if trialsPresented(j,icor) == 1
                    switch trialsPresented(j,ival)
                        case 1
                            t1acx(x1,:) = trialmatx(j,:);
                            x1 = x1+1;
                        case 2
                            t1ucx(x2,:) = trialmatx(j,:);
                            x2 = x2+1;
                        case 3
                            t1ncx(x3,:) = trialmatx(j,:);
                            x3 = x3+1;
                    end
                elseif trialsPresented(j,icor) == 0
                    switch trialsPresented(j,ival)
                        case 1
                            t1aix(x4,:) = trialmatx(j,:);
                            x4 = x4+1;
                        case 2
                            t1uix(x5,:) = trialmatx(j,:);
                            x5 = x5+1;
                        case 3
                            t1nix(x3,:) = trialmatx(j,:);
                            x6 = x6+1;
                    end
                end
            elseif trialsPresented(j,icue) == 2
                if trialsPresented(j,icor) == 1
                    switch trialsPresented(j,ival)
                        case 1
                            t2acx(y1,:) = trialmatx(j,:);
                            y1 = y1+1;
                        case 2
                            t2ucx(y2,:) = trialmatx(j,:);
                            y2 = y2+1;
                        case 3
                            t2ncx(y3,:) = trialmatx(j,:);
                            y3 = y3+1;
                    end
                elseif trialsPresented(j,icor) == 0
                    switch trialsPresented(j,ival)
                        case 1
                            t2aix(y4,:) = trialmatx(j,:);
                            y4 = y4+1;
                        case 2
                            t2uix(y5,:) = trialmatx(j,:);
                            y5 = y5+1;
                        case 3
                            t2nix(y6,:) = trialmatx(j,:);
                            y6 = y6+1;
                    end
                end
            end
        end

        

% %
%         
%         x1 = 1; x2 = 1; x3 = 1; x4 = 1;
%         y1 = 1; y2 = 1; y3 = 1; y4 = 1;
%         z1 = 1; z2 = 2;
% 
%         
%         
%         t1vcx = [];
%         t2vcx = [];
%         t1vix = [];
%         t2vix = [];
%         t1icx = [];
%         t2icx = [];
%         t1iix = [];
%         t2iix = [];
%         ncx = [];
%         nix = [];
%         
%         for j = 1:size(trialmatx,1) %%%%%
%             if trialsPresented(j,icue) == 1
%                 if trialsPresented(j,ival) == 1 && trialsPresented(j,icor) == 1
%                     t1vcx(x1,:) = trialmatx(j,:);
%                     x1 = x1+1;
%                 elseif trialsPresented(j,ival) == 1 && trialsPresented(j,icor) == 0
%                     t1vix(x2,:) = trialmatx(j,:);
%                     x2 = x2+1;
%                 elseif trialsPresented(j,ival) == 2 && trialsPresented(j,icor) == 1
%                     t1icx(x3,:) = trialmatx(j,:);
%                     x3 = x3+1;
%                 elseif trialsPresented(j,ival) == 2 && trialsPresented(j,icor) == 0
%                     t1iix(x4,:) = trialmatx(j,:);
%                     x4 = x4+1;
%                 end
%             elseif trialsPresented(j,icue) == 2
%                 if trialsPresented(j,ival) == 1 && trialsPresented(j,icor) == 1
%                     t2vcx(y1,:) = trialmatx(j,:);
%                     y1 = y1+1;
%                 elseif trialsPresented(j,ival) == 1 && trialsPresented(j,icor) == 0
%                     t2vix(y2,:) = trialmatx(j,:);
%                     y2 = y2+1;
%                 elseif trialsPresented(j,ival) == 2 && trialsPresented(j,icor) == 1
%                     t2icx(y3,:) = trialmatx(j,:);
%                     y3 = y3+1;
%                 elseif trialsPresented(j,ival) == 2 && trialsPresented(j,icor) == 0
%                     t2iix(y4,:) = trialmatx(j,:);
%                     y4 = y4+1;
%                 end
%             elseif trialsPresented(j,icue) == 0
%                 if trialsPresented(j,icor) == 1 && trialsPresented(j,ival) == 3
%                     ncx(z1,:) = trialmatx(j,:);
%                     z1 = z1+1;
%                 elseif trialsPresented(j,icor) == 0 && trialsPresented(j,ival) == 3
%                     nix(z2,:) = trialmatx(j,:);
%                     z2 = z2+1;
%                 end
%             end
%         end

%


        for hi = 1:length(pafields)-2
            pa.(pafields{hi}).(subjects{i}) = [pa.(pafields{hi}).(subjects{i}) ; eval([pafields{hi} 'x'])];
%         pa.t1vc.(subjects{i}) = [pa.t1vc.(subjects{i}) ; t1vcx];
%         pa.t2vc.(subjects{i}) = [pa.t2vc.(subjects{i}) ; t2vcx];
%         pa.t1vi.(subjects{i}) = [pa.t1vi.(subjects{i}) ; t1vix];
%         pa.t2vi.(subjects{i}) = [pa.t2vi.(subjects{i}) ; t2vix];
%         pa.t1ic.(subjects{i}) = [pa.t1ic.(subjects{i}) ; t1icx];
%         pa.t2ic.(subjects{i}) = [pa.t2ic.(subjects{i}) ; t2icx];
%         pa.t1ii.(subjects{i}) = [pa.t1ii.(subjects{i}) ; t1iix];
%         pa.t2ii.(subjects{i}) = [pa.t2ii.(subjects{i}) ; t2iix];
%         pa.nc.(subjects{i}) = [pa.nc.(subjects{i}) ; ncx];
%         pa.ni.(subjects{i}) = [pa.ni.(subjects{i}) ; nix];
        end
        
    end
        
end 

for hi = 1:length(pafields)-2
    for j = 1:length(subjects)
        pa.(pafields{hi}).smeans(j,:) = nanmean(pa.(pafields{hi}).(subjects{j}),1);
        pa.(pafields{hi}).count(j,:) = sum(~isnan(pa.(pafields{hi}).(subjects{j})),1);
%         pa.t2vc.smeans(j,:) = nanmean(pa.t2vc.(subjects{j}),1);
%         pa.t2vc.count(j,:) = sum(~isnan(pa.t2vc.(subjects{j})),1);
%         pa.t1vi.smeans(j,:) = nanmean(pa.t1vi.(subjects{j}),1);
%         pa.t1vi.count(j,:) = sum(~isnan(pa.t1vi.(subjects{j})),1);
%         pa.t2vi.smeans(j,:) = nanmean(pa.t2vi.(subjects{j}),1);
%         pa.t2vi.count(j,:) = sum(~isnan(pa.t2vi.(subjects{j})),1);
%         pa.t1ic.smeans(j,:) = nanmean(pa.t1ic.(subjects{j}),1);
%         pa.t1ic.count(j,:) = sum(~isnan(pa.t1ic.(subjects{j})),1);
%         pa.t2ic.smeans(j,:) = nanmean(pa.t2ic.(subjects{j}),1);
%         pa.t2ic.count(j,:) = sum(~isnan(pa.t2ic.(subjects{j})),1);
%         pa.t1ii.smeans(j,:) = nanmean(pa.t1ii.(subjects{j}),1);
%         pa.t1ii.count(j,:) = sum(~isnan(pa.t1ii.(subjects{j})),1);
%         pa.t2ii.smeans(j,:) = nanmean(pa.t2ii.(subjects{j}),1);
%         pa.t2ii.count(j,:) = sum(~isnan(pa.t2ii.(subjects{j})),1);
%         pa.nc.smeans(j,:) = nanmean(pa.nc.(subjects{j}),1);
%         pa.nc.count(j,:) = sum(~isnan(pa.nc.(subjects{j})),1);
%         pa.ni.smeans(j,:) = nanmean(pa.ni.(subjects{j}),1);
%         pa.ni.count(j,:) = sum(~isnan(pa.ni.(subjects{j})),1);
    end
end

for hi = 1:length(pafields)-2
    pa.(pafields{hi}).gmean = wmean(pa.(pafields{hi}).smeans,pa.(pafields{hi}).count);
%     pa.t2vc.gmean = wmean(pa.t2vc.smeans,pa.t2vc.count);
%     pa.t1vi.gmean = wmean(pa.t1vi.smeans,pa.t1vi.count);
%     pa.t2vi.gmean = wmean(pa.t2vi.smeans,pa.t2vi.count);
%     pa.t1ic.gmean = wmean(pa.t1ic.smeans,pa.t1ic.count);
%     pa.t2ic.gmean = wmean(pa.t2ic.smeans,pa.t2ic.count);
%     pa.t1ii.gmean = wmean(pa.t1ii.smeans,pa.t1ii.count);
%     pa.t2ii.gmean = wmean(pa.t2ii.smeans,pa.t2ii.count);
%     pa.nc.gmean = wmean(pa.nc.smeans,pa.nc.count);
%     pa.ni.gmean = wmean(pa.ni.smeans,pa.ni.count);
end

for hi = 1:length(pafields)-2
    pa.(pafields{hi}).se = wste(pa.(pafields{hi}).smeans,pa.(pafields{hi}).gmean,pa.(pafields{hi}).count);
%     pa.t2vc.se = wste(pa.t2vc.smeans,pa.t2vc.gmean,pa.t2vc.count);
%     pa.t1vi.se = wste(pa.t1vi.smeans,pa.t1vi.gmean,pa.t1vi.count);
%     pa.t2vi.se = wste(pa.t2vi.smeans,pa.t2vi.gmean,pa.t2vi.count);
%     pa.t1ic.se = wste(pa.t1ic.smeans,pa.t1ic.gmean,pa.t1ic.count);
%     pa.t2ic.se = wste(pa.t2ic.smeans,pa.t2ic.gmean,pa.t2ic.count);
%     pa.t1ii.se = wste(pa.t1ii.smeans,pa.t1ii.gmean,pa.t1ii.count);
%     pa.t2ii.se = wste(pa.t2ii.smeans,pa.t2ii.gmean,pa.t2ii.count);
%     pa.nc.se = wste(pa.nc.smeans,pa.nc.gmean,pa.nc.count);
%     pa.ni.se = wste(pa.ni.smeans,pa.ni.gmean,pa.ni.count);
end

pa.det = zeros(length(pafields)-1,duration,length(subjects));

for j = 1:length(subjects)
    for hi = 1:length(pafields)-2
        pa.det(hi,:,j) = pa.(pafields{hi}).smeans(j,:);
    end
end

pa.det = squeeze(nanmean(pa.det,1))';

for hi = 1:length(pafields)-2
    for k = 1:length(subjects)
        pa.(pafields{hi}).sdetmeans(k,:) = padetrend(pa.(pafields{hi}).(subjects{k}),pa.det(k,:));
%         pa.t2vc.sdetmeans(k,:) = padetrend(pa.t2vc.(subjects{k}),nanmean(pa.trialmat(:,:,k)));
%         pa.t1vi.sdetmeans(k,:) = padetrend(pa.t1vi.(subjects{k}),nanmean(pa.trialmat(:,:,k)));
%         pa.t2vi.sdetmeans(k,:) = padetrend(pa.t2vi.(subjects{k}),nanmean(pa.trialmat(:,:,k)));
%         pa.t1ic.sdetmeans(k,:) = padetrend(pa.t1ic.(subjects{k}),nanmean(pa.trialmat(:,:,k)));
%         pa.t2ic.sdetmeans(k,:) = padetrend(pa.t2ic.(subjects{k}),nanmean(pa.trialmat(:,:,k)));
%         pa.t1ii.sdetmeans(k,:) = padetrend(pa.t1ii.(subjects{k}),nanmean(pa.trialmat(:,:,k)));
%         pa.t2ii.sdetmeans(k,:) = padetrend(pa.t2ii.(subjects{k}),nanmean(pa.trialmat(:,:,k)));
%         pa.nc.sdetmeans(k,:) = padetrend(pa.nc.(subjects{k}),nanmean(pa.trialmat(:,:,k)));
%         pa.ni.sdetmeans(k,:) = padetrend(pa.ni.(subjects{k}),nanmean(pa.trialmat(:,:,k)));
    end
end

for hi = 1:length(pafields)-2
    pa.(pafields{hi}).gdetmean = wmean(pa.(pafields{hi}).sdetmeans,pa.(pafields{hi}).count);
%     pa.t2vc.gdetmean = wmean(pa.t2vc.sdetmeans,pa.t2vc.count);
%     pa.t1vi.gdetmean = wmean(pa.t1vi.sdetmeans,pa.t1vi.count);
%     pa.t2vi.gdetmean = wmean(pa.t2vi.sdetmeans,pa.t2vi.count);
%     pa.t1ic.gdetmean = wmean(pa.t1ic.sdetmeans,pa.t1ic.count);
%     pa.t2ic.gdetmean = wmean(pa.t2ic.sdetmeans,pa.t2ic.count);
%     pa.t1ii.gdetmean = wmean(pa.t1ii.sdetmeans,pa.t1ii.count);
%     pa.t2ii.gdetmean = wmean(pa.t2ii.sdetmeans,pa.t2ii.count);
%     pa.nc.gdetmean = wmean(pa.nc.sdetmeans,pa.nc.count);
%     pa.ni.gdetmean = wmean(pa.ni.sdetmeans,pa.ni.count);
end

for hi = 1:length(pafields)-2
    pa.(pafields{hi}).detse = wste(pa.(pafields{hi}).sdetmeans,pa.(pafields{hi}).gdetmean,pa.(pafields{hi}).count);
%     pa.t2vc.detse = wste(pa.t2vc.sdetmeans,pa.t2vc.gdetmean,pa.t2vc.count);
%     pa.t1vi.detse = wste(pa.t1vi.sdetmeans,pa.t1vi.gdetmean,pa.t1vi.count);
%     pa.t2vi.detse = wste(pa.t2vi.sdetmeans,pa.t2vi.gdetmean,pa.t2vi.count);
%     pa.t1ic.detse = wste(pa.t1ic.sdetmeans,pa.t1ic.gdetmean,pa.t1ic.count);
%     pa.t2ic.detse = wste(pa.t2ic.sdetmeans,pa.t2ic.gdetmean,pa.t2ic.count);
%     pa.t1ii.detse = wste(pa.t1ii.sdetmeans,pa.t1ii.gdetmean,pa.t1ii.count);
%     pa.t2ii.detse = wste(pa.t2ii.sdetmeans,pa.t2ii.gdetmean,pa.t2ii.count);
%     pa.nc.detse = wste(pa.nc.sdetmeans,pa.nc.gdetmean,pa.nc.count);
%     pa.ni.detse = wste(pa.ni.sdetmeans,pa.ni.gdetmean,pa.ni.count);
end

        
% switch study
%     case 0
%         save('eyedataE0.mat','pa','-append')
%     case 3
%         save('eyedataE3.mat','pa','-append')
% end        
%         
        