function pac = pa_tempattenT2(pac)

for i = 1:length(pac.subjects)
    
    for r = pac.runs
    
        a = dir(sprintf('%s/%s/*%d_run0%d*.edf',pac.TAeyepath, pac.subjects{i},pac.locs(3),r));
        
        if isempty(a)
            fprintf('Broke on subject %s run %d',i,r)
            break
        end
        
        if length(a) == 1
            edffile = a.name;
        else
            for j = 1:length(a)
                eval(sprintf('edffile%d = a(%d).name;',j,j))
            end
        end
        
        cd([pac.TAeyepath pac.subjects{i}])

        if length(a) == 1
            eye = edfmex(edffile);
        else
            for j = 1:length(a)
                eval(sprintf('eye%d = edfmex(edffile%d);',j,j))
            end
        end
        
         b = dir(sprintf('%s/%s/*%d_run0%d*Temp*.mat',pac.TAdatapath, pac.subjects{i},pac.locs(3),r));
         
         if length(b) == 1
            matfile = b.name;
        else
            matfile = b(length(b)).name;
         end
        
         cd([pac.TAdatapath pac.subjects{i}])
         
         eval(sprintf('load %s',matfile));
         
         if length(a) == 1
             [trialmatx, rawpa] = eventtimeseries(eye,'pa','EVENT_CUE',pac.window,1000,0);
         else
             for k = 1:length(a)
                 eval(sprintf('[trialmatx%d rawpa%d] = eventtimeseries(eye%d,''pa'',''EVENT_CUE'',pac.window,0);',k,k,k))
             end
             trialmatx2(end,:) = [];
             trialmatx = [trialmatx2 ; trialmatx1];
             rawpa = [rawpa2 rawpa1];
         end
         
         figure
         plot(1:length(rawpa),rawpa)
         title(sprintf('pa vs time (run %d, subject %s)',r,pac.subjects{i}))
         xlabel('time (ms)')
         ylabel('pa')
         
         figure
         imagesc(trialmatx)
         title(sprintf('imagesc (run %d, subject %s)',r,pac.subjects{i}))
         
         trialsPresented = expt.trialsPresented.trials;
         trialOrder = expt.trialOrder;
         
         for j = length(expt.eye.fixT2):-1:1
             if expt.eye.fixT2(j) == 0
                 trialmatx(j,:) = [];
                 trialsPresented(j,:) = [];
                 trialOrder(j,:) = [];
             elseif all(trialmatx(j,-pac.window(1):pac.locs(end)-pac.window(1))) == 0
                 trialmatx(j,:) = nan(1,pac.duration);
             end
         end
         
         for j = 1:size(trialmatx,1)
            trialmatx(j,:) = blinkinterp(trialmatx(j,:),5,3,50,75);
         end
         
         figure
         imagesc(trialmatx)
         title(sprintf('imagesc (run %d, subject %s)',r,pac.subjects{i}))
         
         figdir = [pac.filedir '/' pac.subjects{i}];
         
         fig = [1 2 3];
         
         fignames = {sprintf('run%d',r) sprintf('run%dpreblink',r) sprintf('run%dpostblink',r)};
         
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
         neutralx = zeros(length(find(trialsPresented(:,idx) == 0)),pac.duration);

         
         x = 1;
         y = 1;
         z = 1;
         
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
         
         pac.t1.(pac.subjects{i}) = [pac.t1.(pac.subjects{i}) ; t1x];
         pac.t2.(pac.subjects{i}) = [pac.t2.(pac.subjects{i}) ; t2x];
         pac.neutral.(pac.subjects{i}) = [pac.neutral.(pac.subjects{i}) ; neutralx];
         
         close all
         
         fprintf('\n')
         
    end
    
end

countt1 = zeros(length(pac.subjects),pac.duration);
countt2 = zeros(length(pac.subjects),pac.duration);
countn = zeros(length(pac.subjects),pac.duration);

for fs = 1:length(pac.subjects)
    countt1(fs,:) = sum(~isnan(pac.t1.(pac.subjects{fs})),1);
    pac.t1.smeans(fs,:) = nanmean(pac.t1.(pac.subjects{fs}),1);
    countt2(fs,:) = sum(~isnan(pac.t2.(pac.subjects{fs})),1);
    pac.t2.smeans(fs,:) = nanmean(pac.t2.(pac.subjects{fs}),1);
    countn(fs,:) = sum(~isnan(pac.neutral.(pac.subjects{fs})),1);
    pac.neutral.smeans(fs,:) = nanmean(pac.neutral.(pac.subjects{fs}),1);
end
         
pac.t1normwm = wmean(pac.t1.smeans,countt1);
pac.t2normwm = wmean(pac.t2.smeans,countt2);
pac.neutralnormwm = wmean(pac.neutral.smeans,countn);

pac.t1se = wste(pac.t1.smeans,pac.t1normwm,countt1);
pac.t2se = wste(pac.t2.smeans,pac.t2normwm,countt2);
pac.nse = wste(pac.neutral.smeans,pac.neutralnormwm,countn);

cd('/Users/jakeparker/Documents/MATLAB')

close all

pac.t1det = zeros(length(pac.subjects),pac.duration);
pac.t2det = zeros(length(pac.subjects),pac.duration);
pac.neutraldet = zeros(length(pac.subjects),pac.duration);

for i = 1:length(pac.subjects)
    pac.t1det(i,:) = padetrend(pac.t1.(pac.subjects{i}),nanmean([pac.t1.smeans(i,:) ; pac.t2.smeans(i,:) ; pac.neutral.smeans(i,:)]));
    pac.t2det(i,:) = padetrend(pac.t2.(pac.subjects{i}),nanmean([pac.t1.smeans(i,:) ; pac.t2.smeans(i,:) ; pac.neutral.smeans(i,:)]));
    pac.neutraldet(i,:) = padetrend(pac.neutral.(pac.subjects{i}),nanmean([pac.t1.smeans(i,:) ; pac.t2.smeans(i,:) ; pac.neutral.smeans(i,:)]));
end
         
pac.t1detwm = wmean(pac.t1det,countt1);
pac.t2detwm = wmean(pac.t2det,countt2);
pac.neutraldetwm = wmean(pac.neutraldet,countn);

pac.t1detse = wste(pac.t1det,pac.t1detwm,countt1);
pac.t2detse = wste(pac.t2det,pac.t2detwm,countt2);
pac.neutraldetse = wste(pac.neutraldet,pac.neutraldetwm,countn);
        