function pa_param_plots(pa,m)

close all

t1color = [0 55 127; 1 110 255; 60 144 255] ./ 255;
t2color = [127 0 0; 255 1 0; 255 60 59] ./ 255;
tacolor = reshape([t1color t2color]',3,6)';

set(0,'DefaultAxesColorOrder',distinguishable_colors(12))

bmeans = nan(length(pa.fields),5);
lmeans = nan(length(pa.fields),4);
tmeans = nan(length(pa.fields),1);
ymeans = nan(length(pa.fields),1);
bste = bmeans;
lste = lmeans;
tste = tmeans;
yste = ymeans;

xlab = {'pcB','t1B','t2B','rcB','decB','pcL','t1L','t2L','rcL','tmax','yint'};

for ff = 1:length(pa.fields)
    bmeans(ff,:) = mean(pa.(pa.fields{ff}).models(m).betas,1);
    lmeans(ff,:) = mean(pa.(pa.fields{ff}).models(m).locations,1);
    tmeans(ff,:) = mean(pa.(pa.fields{ff}).models(m).tmax,1);
    ymeans(ff,:) = mean(pa.(pa.fields{ff}).models(m).yint,1);
    bste(ff,:) = ste(pa.(pa.fields{ff}).models(m).betas,0,1);
    lste(ff,:) = ste(pa.(pa.fields{ff}).models(m).locations,0,1);
    tste(ff,:) = ste(pa.(pa.fields{ff}).models(m).tmax,0,1);
    yste(ff,:) = ste(pa.(pa.fields{ff}).models(m).yint,0,1);
end

%betas
figure(1)
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 840 630])
errorbar(repmat(1:5,length(pa.fields),1)',bmeans',bste','-o')
xlim([0 6])
set(gca,'XTick',1:5)
set(gca,'XTickLabel',xlab(1:5))
title('Condition Group Means, Amplitude')
legend(pa.fields)

%latency
figure(2)
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 840 630])
errorbar(repmat(1:4,length(pa.fields),1)',lmeans' - repmat([0 1000 1250 1750],length(pa.fields),1)',lste','-o')
xlim([0 5])
set(gca,'XTick',1:4)
set(gca,'XTickLabel',xlab(6:9))
title('Condition Group Means, Latency')
legend(pa.fields)

%tmax
figure(3)
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 840 630])
errorbar(repmat(1,length(pa.fields),1)',tmeans',tste','-o')
xlim([0 2])
set(gca,'XTick',1)
set(gca,'XTickLabel',xlab(10))
title('Condition Group Means, tmax')
legend(pa.fields)

%yint
figure(4)
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 840 630])
errorbar(repmat(1,length(pa.fields),1)',ymeans',yste','-o')
xlim([0 2])
set(gca,'XTick',1)
set(gca,'XTickLabel',xlab(11))
title('Condition Group Means, yint')
legend(pa.fields)

fig = 1:4;
fignames = {'amp_condition_means','latency_condition_means','tmax_condition_means','yint_condition_means'};
figprefix = '';
filedir = ['/Users/jakeparker/Google Drive/TA_Pupil/Figures/sumfigs_all/' pa.type];

rd_saveAllFigs(fig,fignames,figprefix, filedir)

close all

for ff = 1:length(pa.fields)
    
    figure(1)
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 430*4 315])
    subplot(1,4,1)
    hold on
    plot(1:5,pa.(pa.fields{ff}).models(m).betas(1:5,:),'-o')
    xlim([0 6])
    set(gca,'XTick',1:5)
    set(gca,'XTickLabel',xlab(1:5))
    title('All Subject 1-5 Medians, Amplitude')
    ylim([0 15])
    
    subplot(1,4,2)
    hold on
    plot(1:5,pa.(pa.fields{ff}).models(m).betas(6:10,:),'-o')
    xlim([0 6])
    set(gca,'XTick',1:5)
    set(gca,'XTickLabel',xlab(1:5))
    title('All Subject 6-10 Medians, Amplitude')
    ylim([0 15])
    
    subplot(1,4,3)
    hold on
    plot(1:5,pa.(pa.fields{ff}).models(m).betas(11:15,:),'-o')
    xlim([0 6])
    set(gca,'XTick',1:5)
    set(gca,'XTickLabel',xlab(1:5))
    title('All Subject 11-15 Medians, Amplitude')
    ylim([0 15])
    
    subplot(1,4,4)
    hold on
    plot(1:5,pa.(pa.fields{ff}).models(m).betas(16:21,:),'-o')
    xlim([0 6])
    set(gca,'XTick',1:5)
    set(gca,'XTickLabel',xlab(1:5))
    title('All Subject Medians 16-21, Amplitude')
    ylim([0 15])
    
    figure(2)
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 430*4 315])
    subplot(1,4,1)
    hold on
    plot(1:4,pa.(pa.fields{ff}).models(m).locations(1:5,:) - repmat([0 1000 1250 1750],5,1),'-o')
    xlim([0 5])
    set(gca,'XTick',1:4)
    set(gca,'XTickLabel',xlab(6:9))
    title('All Subject 1-5 Medians, Latency')
    
    subplot(1,4,2)
    hold on
    plot(1:4,pa.(pa.fields{ff}).models(m).locations(6:10,:) - repmat([0 1000 1250 1750],5,1),'-o')
    xlim([0 5])
    set(gca,'XTick',1:4)
    set(gca,'XTickLabel',xlab(6:9))
    title('All Subject 6-10 Medians, Latency')
    
    subplot(1,4,3)
    hold on
    plot(1:4,pa.(pa.fields{ff}).models(m).locations(11:15,:) - repmat([0 1000 1250 1750],5,1),'-o')
    xlim([0 5])
    set(gca,'XTick',1:4)
    set(gca,'XTickLabel',xlab(6:9))
    title('All Subject 11-15 Medians, Latency')
    
    subplot(1,4,4)
    hold on
    plot(1:4,pa.(pa.fields{ff}).models(m).locations(16:21,:) - repmat([0 1000 1250 1750],6,1),'-o')
    xlim([0 5])
    set(gca,'XTick',1:4)
    set(gca,'XTickLabel',xlab(6:9))
    title('All Subject 16-21 Medians, Latency')
    
    figure(3)
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 430*4 315])
    subplot(1,4,1)
    hold on
    plot(1,pa.(pa.fields{ff}).models(m).tmax(1:5,:),'o')
    xlim([0 2])
    set(gca,'XTick',1)
    set(gca,'XTickLabel',xlab(10))
    title('All Subject 1-5 Medians, tmax')
    
    subplot(1,4,2)
    hold on
    plot(1,pa.(pa.fields{ff}).models(m).tmax(6:10,:),'o')
    xlim([0 2])
    set(gca,'XTick',1)
    set(gca,'XTickLabel',xlab(10))
    title('All Subject 6-10 Medians, tmax')
    
    subplot(1,4,3)
    hold on
    plot(1,pa.(pa.fields{ff}).models(m).tmax(11:15,:),'o')
    xlim([0 2])
    set(gca,'XTick',1)
    set(gca,'XTickLabel',xlab(10))
    title('All Subject 11-15 Medians, tmax')
    
    subplot(1,4,4)
    hold on
    plot(1,pa.(pa.fields{ff}).models(m).tmax(16:21,:),'o')
    xlim([0 2])
    set(gca,'XTick',1)
    set(gca,'XTickLabel',xlab(10))
    title('All Subject 16-21 Medians, tmax')
    
    figure(4)
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 430*4 315])
    subplot(1,4,1)
    hold on
    plot(1,pa.(pa.fields{ff}).models(m).yint(1:5,:),'o')
    xlim([0 2])
    set(gca,'XTick',1)
    set(gca,'XTickLabel',xlab(11))
    title('All Subject 1-5 Medians, yint')
    
    subplot(1,4,2)
    hold on
    plot(1,pa.(pa.fields{ff}).models(m).yint(6:10,:),'o')
    xlim([0 2])
    set(gca,'XTick',1)
    set(gca,'XTickLabel',xlab(11))
    title('All Subject 6-10 Medians, yint')
    
    subplot(1,4,3)
    hold on
    plot(1,pa.(pa.fields{ff}).models(m).yint(11:15,:),'o')
    xlim([0 2])
    set(gca,'XTick',1)
    set(gca,'XTickLabel',xlab(11))
    title('All Subject 16-21 Medians, yint')
    
    subplot(1,4,4)
    hold on
    plot(1,pa.(pa.fields{ff}).models(m).yint(16:21,:),'o')
    xlim([0 2])
    set(gca,'XTick',1)
    set(gca,'XTickLabel',xlab(11))
    title('All Subject 16-21 Medians, yint')
    
end

fig = 1:4;
fignames = {'amp_all_sj','latency_all_sj','tmax_all_sj','yint_all_sj'};
figprefix = '';
filedir = ['/Users/jakeparker/Google Drive/TA_Pupil/Figures/sumfigs_all/' pa.type];

rd_saveAllFigs(fig,fignames,figprefix, filedir)

close all