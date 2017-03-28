function pafigs(b,r,g,pa,filedir,str)

set(0,'DefaultFigureColormap',jet)

close all

for j = 1:length(pa.subjects)
    
    if strcmp(pa.study,'E0E3')
        if j <= 9
            patch = 'E0';
        else
            patch = 'E3';
        end
    else
        patch = '';
    end
    
    ymin = -0.3;
    ymax = 0.3;
    
   figure
    subplot(3,1,1)
    plot(pa.window(1):pa.window(2),b.([pa.subjects{j} patch]),'color',[.7 .7 .75])
    hold on
    plotlines(pa.locs,[ymin ymax])
    plot(pa.window(1):pa.window(2),b.smeans(j,:),'b','LineWidth',3)
    title([pa.subjects{j} str{1} ' normalized'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    ylim([ymin ymax])
    
    subplot(3,1,2)
    plot(pa.window(1):pa.window(2),r.([pa.subjects{j} patch]),'color',[.75 .7 .7])
    hold on
    plotlines(pa.locs,[ymin ymax])
    plot(pa.window(1):pa.window(2),r.smeans(j,:),'r','LineWidth',3)
    title([pa.subjects{j} str{2} ' normalized'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    ylim([ymin ymax])
    
    subplot(3,1,3)
    plot(pa.window(1):pa.window(2),g.([pa.subjects{j} patch]),'color',[.7 .75 .7])
    hold on
    plotlines(pa.locs,[ymin ymax])
    plot(pa.window(1):pa.window(2),g.smeans(j,:),'g','LineWidth',3)
    title([pa.subjects{j} str{3} ' normalized'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    ylim([ymin ymax]) 
    
    figure
    plot(pa.window(1):pa.window(2),b.smeans(j,:),'b')
    hold on
    plot(pa.window(1):pa.window(2),r.smeans(j,:),'r')
    plot(pa.window(1):pa.window(2),g.smeans(j,:),'g')
    plotlines(pa.locs,[ymin ymax])
    title([pa.subjects{j} ' all conditions'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    legend(str{1},str{2},str{3})
    
    ymin = -0.02;
    ymax = 0.02;
    
    figure
    plot(pa.window(1):pa.window(2),b.sdetmeans(j,:),'b')
    hold on
    plot(pa.window(1):pa.window(2),r.sdetmeans(j,:),'r')
    plot(pa.window(1):pa.window(2),g.sdetmeans(j,:),'g')
    plotlines(pa.locs,[ymin ymax])
    title([pa.subjects{j} ' all conditions detrended'])
    xlabel('time (ms)')
    ylabel('pupil area (detrended)')
    legend(str{1},str{2},str{3})
    
    figdir = [filedir '/' pa.subjects{j}];
    
    fig = [1 2 3];
    
    fignames = {'conditions' 'all_conditions' 'all_conditions_det'};
    
    figprefix = 'ta';
    
    rd_saveAllFigs(fig,fignames,figprefix, figdir)
    
    close all
    
end

ymin = -0.1;
ymax = 0.3;

figure
subplot(3,1,1)
plot(pa.window(1):pa.window(2), b.smeans)
hold on
plotlines(pa.locs,[ymin ymax])
title([str{1} ' subject averages of normalized data'])
xlabel('time (ms)')
ylabel('pupil area (normalized)')
ylim([ymin ymax])

subplot(3,1,2)
plot(pa.window(1):pa.window(2), r.smeans)
hold on
plotlines(pa.locs,[ymin ymax])
title([str{2} ' subject averages of normalized data'])
xlabel('time (ms)')
ylabel('pupil area (normalized)')
ylim([ymin ymax])

subplot(3,1,3)
plot(pa.window(1):pa.window(2), g.smeans)
hold on
plotlines(pa.locs,[ymin ymax])
title([str{3} ' subject averages of normalized data'])
xlabel('time (ms)')
ylabel('pupil area (normalized)')
ylim([ymin ymax])

ymin = -0.05;
ymax = 0.25;

figure
shadedErrorBar(pa.window(1):pa.window(2),b.gmean,b.se,'b',1) 
hold on
shadedErrorBar(pa.window(1):pa.window(2),r.gmean,r.se,'r',1) 
shadedErrorBar(pa.window(1):pa.window(2),g.gmean,g.se,'g',1)
plotlines(pa.locs,[ymin ymax])
title(['group averages (b=' str{1} ', r=' str{2} ' and g=' str{3}])
xlabel('time (ms)')
ylabel('pupil area (normalized)')
ylim([ymin ymax])

ymin = -0.02;
ymax = 0.02;

figure
subplot(3,1,1)
plot(pa.window(1):pa.window(2), b.sdetmeans)
hold on
plotlines(pa.locs,[ymin ymax])
title([str{1} ' subject averages of detrended data'])
xlabel('time (ms)')
ylabel('pupil area (detrended)')
ylim([ymin ymax])

subplot(3,1,2)
plot(pa.window(1):pa.window(2), r.sdetmeans)
hold on
plotlines(pa.locs,[ymin ymax])
title([str{2} ' subject averages of detrended data'])
xlabel('time (ms)')
ylabel('pupil area (detrended)')
ylim([ymin ymax])

subplot(3,1,3)
plot(pa.window(1):pa.window(2), g.sdetmeans)
hold on
plotlines(pa.locs,[ymin ymax])
title([str{3} ' subject averages of detrended data'])
xlabel('time (ms)')
ylabel('pupil area (detrended)')
ylim([ymin ymax])

ymin = -0.015;
ymax = 0.015;

figure
shadedErrorBar(pa.window(1):pa.window(2),b.gdetmean,b.detse,'b',1) %%%%
hold on
shadedErrorBar(pa.window(1):pa.window(2),r.gdetmean,r.detse,'r',1) %%%%
shadedErrorBar(pa.window(1):pa.window(2),g.gdetmean,g.detse,'g',1) %%%%
plotlines(pa.locs,[ymin ymax])
title(['group averages (b=' str{1} ', r=' str{2} ' and g=' str{3}])
xlabel('time (ms)')
ylabel('pupil area (detrended)')
ylim([ymin ymax])

figdir = filedir;
fig = [1 2 3 4];
fignames = {'subject_avgs' 'group_avgs' 'subject_avgs_det' 'group_avgs_det'};
figprefix = 'ta';

rd_saveAllFigs(fig,fignames,figprefix, figdir)

close all
