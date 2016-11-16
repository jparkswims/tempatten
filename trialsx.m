function pa = trialsx(pa,TAeyepath,TAdatapath,edffind,matfind,subject,study,type,s)

for r = 1:pa.runs(s)
    
    % E0s1-6 and E3
    %a = dir(sprintf('%s/%s/*%d_run0%d*.edf',TAeyepath, subjects{i},t2time,r));
    
    %E0s7-9
    %a = dir(sprintf('%s/%s/*%d_run0%d*.edf',pac.TAeyepath, pac.subjects{i},pac.locs(3),r));
    if strcmp(study,'E0') || strcmp(study,'E3')
        a = dir(sprintf(edffind,TAeyepath,subject,pa.locs(end-1),r));
    elseif strcmp(study,'E5')
        for j = 1:3
            switch j
                case 1
                    a(1) = dir(sprintf('%s/%s/*_run01_P*.edf',TAeyepath, subject));
                case 2
                    a(2) = dir(sprintf('%s/%s/*_run01W_P*.edf',TAeyepath, subject));
                case 3
                    a(3) = dir(sprintf('%s/%s/*%s1W*.edf',TAeyepath, subject, subject));
            end
        end
    end
    
    if isempty(a)
        fprintf('Broke on subject %s run %d',subject,r)
        error('No edf file found')
    end
    
    if length(a) == 1
        edffile = a.name;
    else
        for k = 1:length(a)
            eval(sprintf('edffile%d = a(%d).name;',k,k))
        end
    end
    
    cd([TAeyepath subject])
    
    if length(a) == 1
        eye = edfmex(edffile);
    else
        for k = 1:length(a)
            eval(sprintf('eye%d = edfmex(edffile%d);',k,k))
        end
    end
    
    
    %E0s1-6 and E3
    %b = dir(sprintf('%s/%s/*%d_run0%d*Temp*.mat',TAdatapath, subjects{i},t2time,r));
    
    %E07-9
    %b = dir(sprintf('%s/%s/*%d_run0%d*Temp*.mat',pac.TAdatapath, pac.subjects{i},pac.locs(3),r));
    
    %E5
    %b = dir(sprintf('%s/%s/*run01WW*Temp*.mat',pac.TAdatapath, pac.subjects{i}));
    if strcmp(study,'E0') || strcmp(study,'E3')
        b = dir(sprintf(matfind,TAdatapath,subject,pa.locs(end-1),r));
    elseif strcmp(study,'E5')
        b = dir(sprintf(matfind,TAdatapath, subject));
    end
    
    if length(b) == 1
        matfile = b.name;
    else
        matfile = b(length(b)).name;
    end
    
    cd([TAdatapath subject])
    
    load(matfile)
    
    if strcmp(study,'E0') || strcmp(study,'E3')
        if length(a) == 1
            [trialmatx, rawpa] = eventtimeseries(eye,'pa','EVENT_CUE',pa.window,1000,0);
        else
            for k = 1:length(a)
                eval(sprintf('[trialmatx%d rawpa%d] = eventtimeseries(eye%d,''pa'',''EVENT_CUE'',pa.window,1000,0);',k,k,k))
            end
            trialmatx2(end,:) = [];
            trialmatx = [trialmatx2 ; trialmatx1];
            rawpa = [rawpa2 rawpa1];
        end
    elseif strcmp(study,'E5')
        if length(a) == 1
            [trialmatx, rawpa] = eventtimeseries(eye,'pa','EVENT_CUE',pa.window,1000,0);
        else
            for k = 1:length(a)
                eval(sprintf('[trialmatx%d rawpa%d etimepoints%d] = eventtimeseries(eye%d,''pa'',''EVENT_CUE'',pa.window,1000,0);',k,k,k,k))
            end
            rawpa = [rawpa1 rawpa2 rawpa3];
            trialmatx = [trialmatx1 ; trialmatx2 ; trialmatx3];
        end
    end
    
    figure
    plot(1:length(rawpa),rawpa)
    title(sprintf('pa vs time (run %d, subject %s)',r,subject))
    xlabel('time (ms)')
    ylabel('pa')
    
    figure
    imagesc(trialmatx)
    title(sprintf('imagesc (run %d, subject %s)',r,subject))
    
    trialsPresented = expt.trialsPresented.trials;
    trialOrder = expt.trialOrder;
    
    fixx = fields(expt.eye);
    
    fixx = fixx{end};
    
    fix = expt.eye.(fixx);
    
    for j = length(fix):-1:1
        if fix(j) == 0 %%%%%%%%%%%%
            trialmatx(j,:) = [];
            trialsPresented(j,:) = [];
            trialOrder(j,:) = [];
        elseif all(trialmatx(j,-pa.window(1):pa.locs(end)-pa.window(1))) == 0
            trialmatx(j,:) = nan(1,pa.duration);
        end
    end
    
    for j = 1:size(trialmatx,1)
        trialmatx(j,:) = blinkinterp(trialmatx(j,:),5,3,50,75);
    end
    
    figure
    imagesc(trialmatx)
    title(sprintf('imagesc (run %d, subject %s)',r,subject))
    
    figdir = [pa.filedir '/' subject];
    
    fig = [1 2 3];
    
    fignames = {sprintf('run%d',r) sprintf('run%dpreblink',r) sprintf('run%dpostblink',r)};
    
    figprefix = 'ta';
    
    rd_saveAllFigs(fig,fignames,figprefix,figdir)
    
    base = nanmean(trialmatx(:,1:-pa.window(1)),2);
    
    for j = 1:size(trialmatx,1)
        trialmatx(j,1:pa.duration) = (trialmatx(j,1:pa.duration)-base(j))/base(j);
    end
    
    figure
    imagesc(trialmatx)
    title(sprintf('imagesc (run %d, subject %s)',r,subject))
    
    ir = abs((pa.trials/pa.runs(s)) - (pa.trials/pa.runs(s))*r);
    
    pa.trialmat(ir+1:ir+(pa.trials/pa.runs(s)),1:pa.duration,s) = trialmatx;
    
    if strcmp(type,'cue')
        
        icue = find(strcmp(expt.trials_headers,'cuedInterval'));
        
        x = 1; y = 1; z = 1;
        t1x = []; t2x = []; nx = [];
        
        for j = 1:size(trialmatx,1)
            
            switch trialsPresented(j,icue)
                case 1
                    t1x(x,:) = trialmatx(j,:);
                    x = x+1;
                case 2
                    t2x(y,:) = trialmatx(j,:);
                    y = y+1;
                case 0
                    nx(z,:) = trialmatx(j,:);
                    z = z+1;
            end
            
        end
        
    elseif strcmp(type,'ta')
        
        icue = find(strcmp(expt.trials_headers,'cuedInterval'));
        
        x1 = 1; x2 = 1; x3 = 1;
        
        t1ax = []; t1ux = []; t1nx = [];
        t2ax = []; t2ux = []; t2nx = [];
        
        for j = 1:size(trialmatx,1)
            
            switch trialsPresented(j,icue)
                case 1
                    t1ax(x1,:) = trialmatx(j,:);
                    t2ux(x1,:) = trialmatx(j,:);
                    x1 = x1+1;
                case 2
                    t1ux(x2,:) = trialmatx(j,:);
                    t2ax(x2,:) = trialmatx(j,:);
                    x2 = x2+1;
                case 0
                    t1nx(x3,:) = trialmatx(j,:);
                    t2nx(x3,:) = trialmatx(j,:);
                    x3 = x3+1;
            end
            
        end
        
    elseif strcmp(type,'tvc')
        
        ival = find(strcmp(expt.trials_headers,'cueValidity'));
        icor = find(strcmp(expt.trials_headers,'correct'));
        icue = find(strcmp(expt.trials_headers,'respInterval'));
        
        x1 = 1; x2 = 1; x3 = 1; x4 = 1; x5 = 1; x6 = 1;
        y1 = 1; y2 = 1; y3 = 1; y4 = 1; y5 = 1; y6 = 1;
        
        t1acx = []; t1ucx = []; t1ncx = []; t1afx = []; t1ufx = []; t1nfx = [];
        t2acx = []; t2ucx = []; t2ncx = []; t2afx = []; t2ufx = []; t2nfx = [];
        
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
                            t1afx(x4,:) = trialmatx(j,:);
                            x4 = x4+1;
                        case 2
                            t1ufx(x5,:) = trialmatx(j,:);
                            x5 = x5+1;
                        case 3
                            t1nfx(x3,:) = trialmatx(j,:);
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
                            t2afx(y4,:) = trialmatx(j,:);
                            y4 = y4+1;
                        case 2
                            t2ufx(y5,:) = trialmatx(j,:);
                            y5 = y5+1;
                        case 3
                            t2nfx(y6,:) = trialmatx(j,:);
                            y6 = y6+1;
                    end
                end
            end
        end
    end
    
    for j = 1:length(pa.fields)
        pa.(pa.fields{j}).(subject) = [pa.(pa.fields{j}).(subject) ; eval([pa.fields{j} 'x'])];
    end
    
    close all
    
    fprintf('\n')
    
end