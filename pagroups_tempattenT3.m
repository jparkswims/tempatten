function pa = pagroups_tempattenT3(pa)

for i = 1:length(pa.subjects)

    for j = 1:3
        switch j
            case 1
                a(1) = dir(sprintf('%s/%s/*_run01_P*.edf',pa.TAeyepath, pa.subjects{i})); 
            case 2
                a(2) = dir(sprintf('%s/%s/*_run01W_P*.edf',pa.TAeyepath, pa.subjects{i})); 
            case 3
                a(3) = dir(sprintf('%s/%s/*%s1W*.edf',pa.TAeyepath,pa.subjects{i}, pa.subjects{i}));
        end
    end

    if isempty(a)
        fprintf('Broke on subject %s run 1',pa.subjects{i})
        break
    end

    if length(a) == 1
        break
    else
        for j = 1:length(a)
            eval(sprintf('edffile%d = a(%d).name;',j,j))
        end
    end

    cd([pa.TAeyepath pa.subjects{i}])

    for j = 1:length(a)
        eval(sprintf('eye%d = edfmex(edffile%d);',j,j))
    end

    b = dir(sprintf('%s/%s/*run01WW*Temp*.mat',pa.TAdatapath, pa.subjects{i}));

    if length(b) > 1
        break
    end
    
    matfile = b.name;

    cd([pa.TAdatapath pa.subjects{i}])

    eval(sprintf('load %s',matfile));

    for j = 1:length(a)
        eval(sprintf('[trialmatx%d rawpa%d etimepoints%d] = eventtimeseries(eye%d,''pa'',''EVENT_CUE'',pa.window,1000,0);',j,j,j,j))
    end

    trialmatx = [trialmatx1 ; trialmatx2 ; trialmatx3];

    trialsPresented = expt.trialsPresented.trials;
    trialOrder = expt.trialOrder;

    for j = length(expt.eye.fixRespCue):-1:1
        if expt.eye.fixRespCue(j) == 0
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

    base = nanmean(trialmatx(:,1:-pa.window(1)),2);
    
    for j = 1:size(trialmatx,1)
        trialmatx(j,1:pa.duration) = (trialmatx(j,1:pa.duration)-base(j))/base(j);
    end

    pa.trialmat = trialmatx;

    ival = find(strcmp(expt.trials_headers,'cueValidity'));
    icor = find(strcmp(expt.trials_headers,'correct'));
    icue = find(strcmp(expt.trials_headers,'respInterval'));

    x1 = 1; x2 = 1; x3 = 1; x4 = 1; x5 = 1; x6 = 1;
    y1 = 1; y2 = 1; y3 = 1; y4 = 1; y5 = 1; y6 = 1;
    z1 = 1; z2 = 1; z3 = 1; z4 = 1; z5 = 1; z6 = 1;

    t1acx = []; t1ucx = []; t1ncx = []; t1aix = []; t1uix = []; t1nix = [];
    t2acx = []; t2ucx = []; t2ncx = []; t2aix = []; t2uix = []; t2nix = [];
    t3acx = []; t3ucx = []; t3ncx = []; t3aix = []; t3uix = []; t3nix = [];

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
        elseif trialsPresented(j,icue) == 3
            if trialsPresented(j,icor) == 1
                switch trialsPresented(j,ival)
                    case 1
                        t3acx(z1,:) = trialmatx(j,:);
                        z1 = z1+1;
                    case 2
                        t3ucx(z2,:) = trialmatx(j,:);
                        z2 = z2+1;
                    case 3
                        t3ncx(z3,:) = trialmatx(j,:);
                        z3 = z3+1;
                end
            elseif trialsPresented(j,icor) == 0
                switch trialsPresented(j,ival)
                    case 1
                        t3aix(z4,:) = trialmatx(j,:);
                        z4 = z4+1;
                    case 2
                        t3uix(z5,:) = trialmatx(j,:);
                        z5 = z5+1;
                    case 3
                        t3nix(z6,:) = trialmatx(j,:);
                        z6 = z6+1;
                end
            end
        end
    end


    for j = 1:length(pa.fields)
        pa.(pa.fields{j}).(pa.subjects{i}) = [pa.(pa.fields{j}).(pa.subjects{i}) ; eval([pa.fields{j} 'x'])];
    end

end


for i = 1:length(pa.fields)
    for j = 1:length(pa.subjects)
        pa.(pa.fields{i}).smeans(j,:) = nanmean(pa.(pa.fields{i}).(pa.subjects{j}),1);
        pa.(pa.fields{i}).count(j,:) = sum(~isnan(pa.(pa.fields{i}).(pa.subjects{j})),1);
    end
end

for i = 1:length(pa.fields)
    pa.(pa.fields{i}).gmean = wmean(pa.(pa.fields{i}).smeans,pa.(pa.fields{i}).count);
end

for i = 1:length(pa.fields)
    pa.(pa.fields{i}).se = wste(pa.(pa.fields{i}).smeans,pa.(pa.fields{i}).gmean,pa.(pa.fields{i}).count);
end

pa.det = zeros(length(pa.fields),pa.duration,length(pa.subjects));

for j = 1:length(pa.subjects)
    for i = 1:length(pa.fields)
        pa.det(i,:,j) = pa.(pa.fields{i}).smeans(j,:);
    end
end

pa.det = squeeze(nanmean(pa.det,1))';

for i = 1:length(pa.fields)
    for j = 1:length(pa.subjects)
        pa.(pa.fields{i}).sdetmeans(j,:) = padetrend(pa.(pa.fields{i}).(pa.subjects{j}),pa.det(j,:));
    end
end

for i = 1:length(pa.fields)
    pa.(pa.fields{i}).gdetmean = wmean(pa.(pa.fields{i}).sdetmeans,pa.(pa.fields{i}).count);
end

for i = 1:length(pa.fields)
    pa.(pa.fields{i}).detse = wste(pa.(pa.fields{i}).sdetmeans,pa.(pa.fields{i}).gdetmean,pa.(pa.fields{i}).count);
end

cd('/Users/jakeparker/Documents/MATLAB')

save('paE5tvc','pa')



    