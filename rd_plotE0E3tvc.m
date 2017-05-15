% rd_plotE0E3tvc.m

%% load data
load E0E3tvc.mat

%% setup
ts = {'t1','t2'};
vs = {'v','n','i'};
cs = {'c','f'};

nTs = numel(ts);
nVs = numel(vs);
nCs = numel(cs);

m = 'gmean';

%% plot setup
figure
defaultColors = get(gca,'ColorOrder');
close(gcf)
colors = defaultColors([1 3 2],:);
lineStyles = {'-','--'};

%% single target per panel, all cue validities and accuracies
figure
strs = [];
for iT = 1:nTs
    t = ts{iT};
    subplot(1,nTs,iT)
    hold on
    idx = 1;
    for iV = 1:nVs
        v = vs{iV};
        for iC = 1:nCs
            c = cs{iC};
            str = sprintf('%s%s%s',t,v,c);
            vals = pa_tvc.(str).(m);
            p1 = plot(vals);
            set(p1, 'color', colors(iV,:), 'lineStyle', lineStyles{iC})
            strs{idx} = str;
            idx = idx+1;
        end
    end
    legend(strs);
    title(ts{iT})
    xlabel('time (ms)')
    ylabel('pupil area')
end