function pa = trialsx(pa,TAeyepath,TAdatapath,edffind,matfind,subject,study,type,s)

close all

for r = 1:pa.runs(s)
    
    % E0s1-6 and E3
    %a = dir(sprintf('%s/%s/*%d_run0%d*.edf',TAeyepath, subjects{i},t2time,r));
    
    %E0s7-9
    %a = dir(sprintf('%s/%s/*%d_run0%d*.edf',pac.TAeyepath, pac.subjects{i},pac.locs(3),r));
    if strcmp(study,'E0') || strcmp(study,'E3') || strcmp(study,'E0E3')
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
    if strcmp(study,'E0') || strcmp(study,'E3') || strcmp(study,'E0E3')
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
    
    if strcmp(study,'E0') || strcmp(study,'E3') || strcmp(study,'E0E3')
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
    
    irt = find(strcmp(expt.trials_headers,'rt'));

    pa.dectime(s) = (median(trialsPresented(:,irt)) + expt.p.respCueSOA + expt.p.respGoSOA) * 1000;
    
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
    
    base = nanmean(trialmatx(:,(-pa.window)-pa.baseline+1:-pa.window),2);
    
    for j = 1:size(trialmatx,1)
        trialmatx(j,1:pa.duration) = (trialmatx(j,1:pa.duration)-base(j))/base(j);
    end
    
    figure
    imagesc(trialmatx)
    title(sprintf('imagesc (run %d, subject %s)',r,subject))
    
    ir = abs((pa.trials/pa.runs(s)) - (pa.trials/pa.runs(s))*r);
    
    pa.trialmat(ir+1:ir+(pa.trials/pa.runs(s)),1:pa.duration,s) = trialmatx;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    trialsort
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    for j = 1:length(pa.fields)
        if strcmp(study,'E0E3')
            if s <= 9
                pa.(pa.fields{j}).([subject 'E0']) = [pa.(pa.fields{j}).([subject 'E0']) ; eval([pa.fields{j} 'x'])];
                pa.(pa.fields{j}).dectime.([subject 'E0']) = [pa.(pa.fields{j}).dectime.([subject 'E0']) ((eval([pa.fields{j} 'dec']) + expt.p.respCueSOA + expt.p.respGoSOA) .* 1000)];
            else
                pa.(pa.fields{j}).([subject 'E3']) = [pa.(pa.fields{j}).([subject 'E3']) ; eval([pa.fields{j} 'x'])];
                pa.(pa.fields{j}).dectime.([subject 'E3']) = [pa.(pa.fields{j}).dectime.([subject 'E3']) ((eval([pa.fields{j} 'dec']) + expt.p.respCueSOA + expt.p.respGoSOA) .* 1000)];
            end
        else
            pa.(pa.fields{j}).(subject) = [pa.(pa.fields{j}).(subject) ; eval([pa.fields{j} 'x'])];
            pa.(pa.fields{j}).dectime.(subject) = [pa.(pa.fields{j}).dectime.(subject) ((eval([pa.fields{j} 'dec']) + expt.p.respCueSOA + expt.p.respGoSOA) .* 1000)];
        end
    end
    
    close all
    
    fprintf('\n')
    
end