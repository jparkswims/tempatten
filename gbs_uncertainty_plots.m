function gbs_uncertainty_plots()
close all
type = 'ta';
datadir = '/Users/jakeparker/Google Drive/TA_Pupil/HPC/';
basedir = '/Users/jakeparker/Documents/MATLAB';
xlab = {'pcB','t1B','t2B','rcB','decB','pcL','t1L','t2L','rcL','tmax','yint'};
exp1 = 1:9;
exp2 = 10:21;
pind = [1:9 12 13];

% t1color = [0 55 127; 1 110 255; 60 144 255] ./ 255;
% t2color = [127 0 0; 255 1 0; 255 60 59] ./ 255;
% tacolor = reshape([t1color t2color]',3,6)';

% tvccolor3 = [0.1 0 1; 0 0.40 0.75; 0 0.6 0.6; 1 0 0.1; 0.75 0.40 0; 0.5 0.5 0];
% tvccolor3 = reshape([tvccolor3(1:3,:) tvccolor3(4:6,:)]',3,6)';

% t1colors = {
%     [123 146 202]./255
%     [167 179 219]./255
%     [204 208 233]./255};
%  
% t2colors = {
%     [242 123 96]./255
%     [247 161 140]./255
%     [251 197 185]./255};
%  
% cuecondcolors = {
%     t1colors{1}
%     t2colors{1}
%     [.5 .5 .5]};
% 
% pacolors = {
%     [123 146 202]./255
%     [242 123 96]./255
%     [167 179 219]./255
%     [247 161 140]./255
%     [204 208 233]./255
%     [251 197 185]./255
%     [123 146 202]./255
%     [242 123 96]./255
%     [167 179 219]./255
%     [247 161 140]./255
%     [204 208 233]./255
%     [251 197 185]./255};
% 
% pamarker = {
%     [123 146 202]./255
%     [242 123 96]./255
%     [167 179 219]./255
%     [247 161 140]./255
%     [204 208 233]./255
%     [251 197 185]./255
%     'none'
%     'none'
%     'none'
%     'none'
%     'none'
%     'none'};
% 
% black = {[0 0 0]};
% blue = {
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     'none'
%     'none'
%     'none'
%     'none'
%     'none'
%     'none'};
% red = {
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     'none'
%     'none'
%     'none'
%     'none'
%     'none'
%     'none'};
% expcolor = {
%     [0 0 1]
%     [1 0 0]};
% 
% blue2 = {
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]
%     [0 0 1]};
% red2 = {
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]
%     [1 0 0]};

% set(0,'DefaultAxesColorOrder',tvccolor3)

cd([datadir type '_all/fit'])
load(['gbs_E0E3' type '_ALL'])

% gbsall.gbserror.gmeans = [];
% gbsall.gbserror.gmeans.eci = nan(2,11,length(gbsall.fields));
% gbsall.gbserror.gmeans.peci = nan(2,11,length(gbsall.fields));
% gbsall.gbserror.smeans = [];
% gbsall.gbserror.smeans.leci = nan(length(gbsall.subjects),11,length(gbsall.fields));
% gbsall.gbserror.smeans.ueci = gbsall.gbserror.smeans.leci;

gbsall.medians.gmeans = nan(length(gbsall.fields),11);
gbsall.medians.smeds = nan(length(gbsall.fields),11,length(gbsall.subjects));

for ff = 1:length(gbsall.fields)
%     gbsall.gbserror.gmeans.eci(:,:,ff) = mean(gbsall.gbserror.(gbsall.fields{ff}).eci,3);
%     gbsall.gbserror.gmeans.peci(:,:,ff) = mean(gbsall.gbserror.(gbsall.fields{ff}).peci,3);
    gbsall.medians.gmeans(ff,:) = mean(gbsall.medians.(gbsall.fields{ff}),1);
    for ss = 1:length(gbsall.subjects)
        gbsall.medians.smeds(ff,:,ss) = gbsall.medians.(gbsall.fields{ff})(ss,:);
%         gbsall.gbserror.smeans.leci(ss,:,ff) = gbsall.gbserror.(gbsall.fields{ff}).eci(1,:,ss);
%         gbsall.gbserror.smeans.ueci(ss,:,ff) = gbsall.gbserror.(gbsall.fields{ff}).eci(2,:,ss);
    end
end

gbsall.lci = nan(length(gbsall.fields),11,length(gbsall.subjects));
gbsall.uci = nan(length(gbsall.fields),11,length(gbsall.subjects));
gbsall.mlci = nan(length(gbsall.fields),11,length(gbsall.subjects));
gbsall.muci = nan(length(gbsall.fields),11,length(gbsall.subjects));
gbsall.group.lci = nan(length(gbsall.fields),11);
gbsall.group.uci = nan(length(gbsall.fields),11);
gbsall.group.mlci = nan(length(gbsall.fields),11);
gbsall.group.muci = nan(length(gbsall.fields),11);
for ff = 1:length(gbsall.fields)
    for ss = 1:length(gbsall.subjects)
        temp = gbsall.(gbsall.subjects{ss}).(gbsall.fields{ff}).glm_params(:,pind);
        gbsall.lci(ff,:,ss) = prctile(reshape(temp(~isnan(temp)),length(temp(~isnan(temp)))/11,11),2.5,1);
        gbsall.uci(ff,:,ss) = prctile(reshape(temp(~isnan(temp)),length(temp(~isnan(temp)))/11,11),97.5,1);
        gbsall.mlci(ff,:,ss) = gbsall.lci(ff,:,ss) - nanmedian(gbsall.(gbsall.subjects{ss}).(gbsall.fields{ff}).glm_params(:,pind),1);
        gbsall.muci(ff,:,ss) = gbsall.uci(ff,:,ss) - nanmedian(gbsall.(gbsall.subjects{ss}).(gbsall.fields{ff}).glm_params(:,pind),1);
    end
end

for ff = 1:length(gbsall.fields)
    gbsall.group.lci(ff,:) = mean(gbsall.lci(ff,:,:),3);
    gbsall.group.uci(ff,:) = mean(gbsall.uci(ff,:,:),3);
    gbsall.group.mlci(ff,:) = mean(gbsall.mlci(ff,:,:),3);
    gbsall.group.muci(ff,:) = mean(gbsall.muci(ff,:,:),3);
end

smeds = gbsall.medians.smeds;
smeds(:,6:9,:) = smeds(:,6:9,:) - repmat([0 1000 1250 1750],size(smeds,1),1,size(smeds,3));
gmeans = gbsall.medians.gmeans;
gmeans(:,6:9) = gmeans(:,6:9) - repmat([0 1000 1250 1750],size(gmeans,1),1);
mlci = gbsall.mlci;
muci = gbsall.muci;
gmlci = gbsall.group.mlci;
gmuci = gbsall.group.muci;

fields = gbsall.fields;
subjects = gbsall.subjects;

%beta plot
uncertplot(1,mean(gmeans,1),mean(gmlci,1),mean(gmuci,1),1,1:5,1,black,black,xlab);
title('Global Group Mean 95CI, Amplitude')


%latency plot
uncertplot(2,mean(gmeans,1),mean(gmlci,1),mean(gmuci,1),1,6:9,1,black,black,xlab);
title('Global Group Mean 95CI, Latency')

%tmax
uncertplot(3,mean(gmeans,1),mean(gmlci,1),mean(gmuci,1),1,10,1,black,black,xlab);
title('Global Group Mean 95CI, tmax')

%yint
uncertplot(4,mean(gmeans,1),mean(gmlci,1),mean(gmuci,1),1,11,1,black,black,xlab);
title('Global Group Mean 95CI, yint')

%condition betas
uncertplot(5,gmeans,gmlci,gmuci,1,1:5,1,pacolors,pamarker,xlab,'jitter');
title('Condition Group Means 95CI, amplitude')
legend(fields)
xlabel('jittered by condition')


%condition latencies
uncertplot(6,gmeans,gmlci,gmuci,1,6:9,1,pacolors,pamarker,xlab,'jitter');
title('Condition Group Means 95CI, latency')
legend(fields)
xlabel('jittered by condition')

%condition tmaxes
uncertplot(7,gmeans,gmlci,gmuci,1,10,1,pacolors,pamarker,xlab,'jitter');
title('Condition Group Means 95CI, tmax')
legend(fields)
xlabel('jittered by condition')

%condition yint
uncertplot(8,gmeans,gmlci,gmuci,1,11,1,pacolors,pamarker,xlab,'jitter');
title('Condition Group Means 95CI, yint')
legend(fields)
xlabel('jittered by condition')

fig = 1:8;
fignames = {'amp_global_uncert','latency_global_uncert','tmax_global_uncert','yint_global_uncert','amp_condition_uncert','latency_condition_uncert','tmax_condition_uncert','yint_condition_uncert'};
figprefix = '';
filedir = [datadir type '_all/plot'];

rd_saveAllFigs(fig,fignames,figprefix, filedir)

%%
close all
set(0,'DefaultAxesColorOrder',distinguishable_colors(21))

for ff = 1:length(gbsall.fields)
    figure(1)
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 430*4 315])
    subplot(1,4,1)
    hold on
    plot(1:5,gbsall.medians.(gbsall.fields{ff})(1:5,1:5),'-o')
    xlim([0 6])
    set(gca,'XTick',1:5)
    set(gca,'XTickLabel',xlab(1:5))
    title('All Subject 1-5 Medians, Amplitude')
    ylim([0 15])
    
    subplot(1,4,2)
    hold on
    plot(1:5,gbsall.medians.(gbsall.fields{ff})(6:10,1:5),'-o')
    xlim([0 6])
    set(gca,'XTick',1:5)
    set(gca,'XTickLabel',xlab(1:5))
    title('All Subject 6-10 Medians, Amplitude')
    ylim([0 15])
    
    subplot(1,4,3)
    hold on
    plot(1:5,gbsall.medians.(gbsall.fields{ff})(11:15,1:5),'-o')
    xlim([0 6])
    set(gca,'XTick',1:5)
    set(gca,'XTickLabel',xlab(1:5))
    title('All Subject 11-15 Medians, Amplitude')
    ylim([0 15])
    
    subplot(1,4,4)
    hold on
    plot(1:5,gbsall.medians.(gbsall.fields{ff})(16:21,1:5),'-o')
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
    plot(1:4,gbsall.medians.(gbsall.fields{ff})(1:5,6:9) - repmat([0 1000 1250 1750],5,1),'-o')
    xlim([0 5])
    set(gca,'XTick',1:4)
    set(gca,'XTickLabel',xlab(6:9))
    ylim([-500 500])
    title('All Subject 1-5 Medians, Latency')
    
    subplot(1,4,2)
    hold on
    plot(1:4,gbsall.medians.(gbsall.fields{ff})(6:10,6:9) - repmat([0 1000 1250 1750],5,1),'-o')
    xlim([0 5])
    set(gca,'XTick',1:4)
    set(gca,'XTickLabel',xlab(6:9))
    ylim([-500 500])
    title('All Subject 6-10 Medians, Latency')
    
    subplot(1,4,3)
    hold on
    plot(1:4,gbsall.medians.(gbsall.fields{ff})(11:15,6:9) - repmat([0 1000 1250 1750],5,1),'-o')
    xlim([0 5])
    set(gca,'XTick',1:4)
    set(gca,'XTickLabel',xlab(6:9))
    ylim([-500 500])
    title('All Subject 11-15 Medians, Latency')
    
    subplot(1,4,4)
    hold on
    plot(1:4,gbsall.medians.(gbsall.fields{ff})(16:21,6:9) - repmat([0 1000 1250 1750],6,1),'-o')
    xlim([0 5])
    set(gca,'XTick',1:4)
    set(gca,'XTickLabel',xlab(6:9))
    ylim([-500 500])
    title('All Subject 16-21 Medians, Latency')
    
    figure(3)
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 430*4 315])
    subplot(1,4,1)
    hold on
    plot(1,gbsall.medians.(gbsall.fields{ff})(1:5,10),'o')
    xlim([0 2])
    set(gca,'XTick',1)
    set(gca,'XTickLabel',xlab(10))
    ylim([600 2000])
    title('All Subject 1-5 Medians, tmax')
    
    subplot(1,4,2)
    hold on
    plot(1,gbsall.medians.(gbsall.fields{ff})(6:10,10),'o')
    xlim([0 2])
    set(gca,'XTick',1)
    set(gca,'XTickLabel',xlab(10))
    ylim([600 2000])
    title('All Subject 6-10 Medians, tmax')
    
    subplot(1,4,3)
    hold on
    plot(1,gbsall.medians.(gbsall.fields{ff})(11:15,10),'o')
    xlim([0 2])
    set(gca,'XTick',1)
    set(gca,'XTickLabel',xlab(10))
    ylim([600 2000])
    title('All Subject 11-15 Medians, tmax')
    
    subplot(1,4,4)
    hold on
    plot(1,gbsall.medians.(gbsall.fields{ff})(16:21,10),'o')
    xlim([0 2])
    set(gca,'XTick',1)
    set(gca,'XTickLabel',xlab(10))
    ylim([600 2000])
    title('All Subject 16-21 Medians, tmax')
    
    figure(4)
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 430*4 315])
    subplot(1,4,1)
    hold on
    plot(1,gbsall.medians.(gbsall.fields{ff})(1:5,11),'o')
    xlim([0 2])
    set(gca,'XTick',1)
    set(gca,'XTickLabel',xlab(11))
    ylim([-0.035 0.01])
    title('All Subject 1-5 Medians, yint')
    
    subplot(1,4,2)
    hold on
    plot(1,gbsall.medians.(gbsall.fields{ff})(6:10,11),'o')
    xlim([0 2])
    set(gca,'XTick',1)
    set(gca,'XTickLabel',xlab(11))
    ylim([-0.035 0.01])
    title('All Subject 6-10 Medians, yint')
    
    subplot(1,4,3)
    hold on
    plot(1,gbsall.medians.(gbsall.fields{ff})(16:21,11),'o')
    xlim([0 2])
    set(gca,'XTick',1)
    set(gca,'XTickLabel',xlab(11))
    ylim([-0.035 0.01])
    title('All Subject 16-21 Medians, tmax')
    
    subplot(1,4,4)
    hold on
    plot(1,gbsall.medians.(gbsall.fields{ff})(16:21,11),'o')
    xlim([0 2])
    set(gca,'XTick',1)
    set(gca,'XTickLabel',xlab(11))
    ylim([-0.035 0.01])
    title('All Subject 16-21 Medians, tmax')
    
end

fig = 1:4;
fignames = {'amp_all_sjmedians','latency_all_sjmedians','tmax_all_sjmedians','yint_all_sjmedians'};
figprefix = '';
filedir = [datadir type '_all/plot'];

rd_saveAllFigs(fig,fignames,figprefix, filedir)
%%
close all

%beta plot
uncertplot(1,[mean(mean(smeds(:,:,exp1),1),3) ; mean(mean(smeds(:,:,exp2),1),3)],[mean(mean(mlci(:,:,exp1),1),3) ; mean(mean(mlci(:,:,exp2),1),3)],[mean(mean(muci(:,:,exp1),1),3) ; mean(mean(muci(:,:,exp2),1),3)],1,1:5,1,expcolor,expcolor,xlab,'jitter');
title('Global Group Mean 95CI, Amplitude')
legend({'Discrimination','Estimation'})

%latency plot
uncertplot(2,[mean(mean(smeds(:,:,exp1),1),3) ; mean(mean(smeds(:,:,exp2),1),3)],[mean(mean(mlci(:,:,exp1),1),3) ; mean(mean(mlci(:,:,exp2),1),3)],[mean(mean(muci(:,:,exp1),1),3) ; mean(mean(muci(:,:,exp2),1),3)],1,6:9,1,expcolor,expcolor,xlab,'jitter');
title('Global Group Mean 95CI, Latency')
legend({'Discrimination','Estimation'})

%tmax
uncertplot(3,[mean(mean(smeds(:,:,exp1),1),3) ; mean(mean(smeds(:,:,exp2),1),3)],[mean(mean(mlci(:,:,exp1),1),3) ; mean(mean(mlci(:,:,exp2),1),3)],[mean(mean(muci(:,:,exp1),1),3) ; mean(mean(muci(:,:,exp2),1),3)],1,10,1,expcolor,expcolor,xlab,'jitter');
title('Global Group Mean 95CI, tmax')
legend({'Discrimination','Estimation'})

%yint
uncertplot(4,[mean(mean(smeds(:,:,exp1),1),3) ; mean(mean(smeds(:,:,exp2),1),3)],[mean(mean(mlci(:,:,exp1),1),3) ; mean(mean(mlci(:,:,exp2),1),3)],[mean(mean(muci(:,:,exp1),1),3) ; mean(mean(muci(:,:,exp2),1),3)],1,11,1,expcolor,expcolor,xlab,'jitter');
title('Global Group Mean 95CI, yint')
legend({'Discrimination','Estimation'})

fig = 1:4;
fignames = {'amp_global_exp_uncert','latency_global_exp_uncert','tmax_global_exp_uncert','yint_global_exp_uncert'};
figprefix = '';
filedir = [datadir type '_all/plot'];

rd_saveAllFigs(fig,fignames,figprefix, filedir)

%%
close all

%beta plot
uncertplot(1,mean(smeds(:,:,exp1),3),mean(mlci(:,:,exp1),3),mean(muci(:,:,exp1),3),1,1:5,1,blue2,blue,xlab,'jitter')
hold on
uncertplot(1,mean(smeds(:,:,exp2),3),mean(mlci(:,:,exp2),3),mean(muci(:,:,exp2),3),1,1:5,1,red2,red,xlab,'jitter')
title('Exp Condition Means 95CI, Amplitude')
xlabel('Exp1 = Blue, Exp2 = Red     jittered by condition')

%latency plot
uncertplot(2,mean(smeds(:,:,exp1),3),mean(mlci(:,:,exp1),3),mean(muci(:,:,exp1),3),1,6:9,1,blue2,blue,xlab,'jitter')
hold on
uncertplot(2,mean(smeds(:,:,exp2),3),mean(mlci(:,:,exp2),3),mean(muci(:,:,exp2),3),1,6:9,1,red2,red,xlab,'jitter')
title('Exp Condition Means 95CI, Latency')
xlabel('Exp1 = Blue, Exp2 = Red     jittered by condition')

%tmax plot
uncertplot(3,mean(smeds(:,:,exp1),3),mean(mlci(:,:,exp1),3),mean(muci(:,:,exp1),3),1,10,1,blue2,blue,xlab,'jitter')
hold on
uncertplot(3,mean(smeds(:,:,exp2),3),mean(mlci(:,:,exp2),3),mean(muci(:,:,exp2),3),1,10,1,red2,red,xlab,'jitter')
title('Exp Condition Means 95CI, tmax')
xlabel('Exp1 = Blue, Exp2 = Red     jittered by condition')

%beta plot
uncertplot(4,mean(smeds(:,:,exp1),3),mean(mlci(:,:,exp1),3),mean(muci(:,:,exp1),3),1,11,1,blue2,blue,xlab,'jitter')
hold on
uncertplot(4,mean(smeds(:,:,exp2),3),mean(mlci(:,:,exp2),3),mean(muci(:,:,exp2),3),1,11,1,red2,red,xlab,'jitter')
title('Exp Condition Means 95CI, yint')
xlabel('Exp1 = Blue, Exp2 = Red     jittered by condition')

% for ff = 1:length(gbsall.fields)
%     
%     %beta plot
%     figure(1)
%     set(gcf,'Color',[1 1 1])
%     set(gcf,'Position',[100 100 840 630])
%     hold on
%     errorbar(repmat(1:5,2,1)',[mean(gbsall.medians.smeds(ff,1:5,exp1),3) ; mean(gbsall.medians.smeds(ff,1:5,exp2),3)]',[mean(gbsall.mlci(ff,1:5,exp1),1) ; mean(gbsall.mlci(ff,1:5,exp2),1)]',[mean(gbsall.muci(ff,1:5,exp1),1) ; mean(gbsall.muci(ff,1:5,exp2),1)]','-o')
%     xlim([0 6])
%     set(gca,'XTick',1:5)
%     set(gca,'XTickLabel',xlab(1:5))
%     title('Exp Condition Means 95CI, Amplitude')
%     legend({'Discrimination','Estimation'})
%     
%     %latency plot
%     figure(2)
%     set(gcf,'Color',[1 1 1])
%     set(gcf,'Position',[100 100 840 630])
%     hold on
%     errorbar(repmat(1:4,2,1)',[mean(gbsall.medians.smeds(ff,6:9,exp1),3) - [0 1000 1250 1750] ; mean(gbsall.medians.smeds(ff,6:9,exp2),3) - [0 1000 1250 1750]]',[mean(gbsall.mlci(ff,6:9,exp1),1) ; mean(gbsall.mlci(ff,6:9,exp2),1)]',[mean(gbsall.muci(ff,6:9,exp1),1) ; mean(gbsall.muci(ff,6:9,exp2),1)]','-o')
%     xlim([0 5])
%     set(gca,'XTick',1:4)
%     set(gca,'XTickLabel',xlab(6:9))
%     title('Exp Condition Means 95CI, Latency')
%     legend({'Discrimination','Estimation'})
%     
%     %tmax
%     figure(3)
%     set(gcf,'Color',[1 1 1])
%     set(gcf,'Position',[100 100 840 630])
%     hold on
%     errorbar([1 1; 1 1]',[mean(gbsall.medians.smeds(ff,10,exp1),3) mean(gbsall.medians.smeds(ff,10,exp1),3) ; mean(gbsall.medians.smeds(ff,10,exp2),3) mean(gbsall.medians.smeds(ff,10,exp2),3)]',[mean(gbsall.mlci(ff,10,exp1),1) mean(gbsall.mlci(ff,10,exp1),1) ; mean(gbsall.mlci(ff,10,exp2),1) mean(gbsall.mlci(ff,10,exp2),1)]',[mean(gbsall.muci(ff,10,exp1),1) mean(gbsall.muci(ff,10,exp1),1) ; mean(gbsall.muci(ff,10,exp2),1) mean(gbsall.muci(ff,10,exp2),1)]','-o')
%     xlim([0 2])
%     set(gca,'XTick',1)
%     set(gca,'XTickLabel',xlab(10))
%     title('Exp Condition Means 95CI, tmax')
%     legend({'Discrimination','Estimation'})
%     
%     %yint
%     figure(4)
%     set(gcf,'Color',[1 1 1])
%     set(gcf,'Position',[100 100 840 630])
%     hold on
%     errorbar([1 1; 1 1]',[mean(gbsall.medians.smeds(ff,11,exp1),3) mean(gbsall.medians.smeds(ff,11,exp1),3) ; mean(gbsall.medians.smeds(ff,11,exp2),3) mean(gbsall.medians.smeds(ff,11,exp2),3)]',[mean(gbsall.mlci(ff,11,exp1),1) mean(gbsall.mlci(ff,11,exp1),1) ; mean(gbsall.mlci(ff,11,exp2),1) mean(gbsall.mlci(ff,11,exp2),1)]',[mean(gbsall.muci(ff,11,exp1),1) mean(gbsall.muci(ff,11,exp1),1) ; mean(gbsall.muci(ff,11,exp2),1) mean(gbsall.muci(ff,11,exp2),1)]','-o')
%     xlim([0 2])
%     set(gca,'XTick',1)
%     set(gca,'XTickLabel',xlab(11))
%     title('Exp Condition Means 95CI, yint')
%     legend({'Discrimination','Estimation'})
%     
% end

fig = 1:4;
fignames = {'amp_condition_exp_uncert','latency_condition_exp_uncert','tmax_condition_exp_uncert','yint_condition_exp_uncert'};
figprefix = '';
filedir = [datadir type '_all/plot'];

rd_saveAllFigs(fig,fignames,figprefix, filedir)

%%
close all
%set(0,'DefaultAxesColorOrder',tvccolor3)

%condition betas
uncertplot(1,mean(smeds(:,:,exp1),3),mean(mlci(:,:,exp1),3),mean(muci(:,:,exp1),3),1,1:5,1,pacolors,pamarker,xlab,'jitter');
title('Condition Group Means 95CI, Amplitude')
legend(fields)
xlabel('jittered by condition')

%condition latencies
uncertplot(2,mean(smeds(:,:,exp1),3),mean(mlci(:,:,exp1),3),mean(muci(:,:,exp1),3),1,6:9,1,pacolors,pamarker,xlab,'jitter');
title('Condition Group Means 95CI, Latency')
legend(fields)
xlabel('jittered by condition')

%condition tmaxes
uncertplot(3,mean(smeds(:,:,exp1),3),mean(mlci(:,:,exp1),3),mean(muci(:,:,exp1),3),1,10,1,pacolors,pamarker,xlab,'jitter');
title('Condition Group Means 95CI, tmax')
legend(fields)
xlabel('jittered by condition')

%condition yint
uncertplot(4,mean(smeds(:,:,exp1),3),mean(mlci(:,:,exp1),3),mean(muci(:,:,exp1),3),1,11,1,pacolors,pamarker,xlab,'jitter');
title('Condition Group Means 95CI, yint')
legend(fields)
xlabel('jittered by condition')

%condition betas
uncertplot(5,mean(smeds(:,:,exp2),3),mean(mlci(:,:,exp2),3),mean(muci(:,:,exp2),3),1,1:5,1,pacolors,pamarker,xlab,'jitter');
title('Condition Group Means 95CI, Amplitude')
legend(fields)
xlabel('jittered by condition')

%condition latencies
uncertplot(6,mean(smeds(:,:,exp2),3),mean(mlci(:,:,exp2),3),mean(muci(:,:,exp2),3),1,6:9,1,pacolors,pamarker,xlab,'jitter');
title('Condition Group Means 95CI, Latency')
legend(fields)
xlabel('jittered by condition')

%condition tmaxes
uncertplot(7,mean(smeds(:,:,exp2),3),mean(mlci(:,:,exp2),3),mean(muci(:,:,exp2),3),1,10,1,pacolors,pamarker,xlab,'jitter');
title('Condition Group Means 95CI, tmax')
legend(fields)
xlabel('jittered by condition')

%condition yint
uncertplot(8,mean(smeds(:,:,exp2),3),mean(mlci(:,:,exp2),3),mean(muci(:,:,exp2),3),1,11,1,pacolors,pamarker,xlab,'jitter');
title('Condition Group Means 95CI, yint')
legend(fields)
xlabel('jittered by condition')

fig = 1:8;
fignames = {'amp_condition_exp1','latency_condition_exp1','tmax_condition_exp1','yint_condition_exp1','amp_condition_exp2','latency_condition_exp2','tmax_condition_exp2','yint_condition_exp2'};
figprefix = '';
filedir = [datadir type '_all/plot'];

rd_saveAllFigs(fig,fignames,figprefix, filedir)

%%
close all

for ff = 1:length(gbsall.fields)
    %beta plot
    uncertplot(1,smeds(ff,:,exp1),mlci(ff,:,exp1),muci(ff,:,exp1),3,1:5,1,blue2,blue2,xlab,'jitter')
    hold on
    uncertplot(1,smeds(ff,:,exp2),mlci(ff,:,exp2),muci(ff,:,exp2),3,1:5,1,red2,red2,xlab,'jitter')
%     figure(1)
%     set(gcf,'Color',[1 1 1])
%     set(gcf,'Position',[100 100 840 630])
%     errorbar(repmat([1:5]',1,length(exp1)),squeeze(gbsall.medians.smeds(ff,1:5,exp1)),gbsall.mlci(ff,1:5,exp1)',gbsall.muci(ff,1:5,exp1)','b-o')
%     hold on
%     errorbar(repmat([1:5]',1,length(exp2)),squeeze(gbsall.medians.smeds(ff,1:5,exp2)),gbsall.mlci(ff,1:5,exp2)',gbsall.muci(ff,1:5,exp2)','r-o')
%     xlim([0 6])
%     set(gca,'XTick',1:5)
%     set(gca,'XTickLabel',xlab(1:5))
    ylim([0 20])
    title('All Subject Medians 95CI, Amplitude')
    legend({'exp1','exp2'})
    xlabel('jittered by subject')
    
    
    %latency plot
%     figure(2)
%     set(gcf,'Color',[1 1 1])
%     set(gcf,'Position',[100 100 840 630])
%     errorbar(repmat([1:4]',1,length(exp1)),(squeeze(gbsall.medians.smeds(ff,6:9,exp1))' - repmat([0 1000 1250 1750],length(exp1),1))',gbsall.mlci(ff,6:9,exp1)',gbsall.muci(ff,6:9,exp1)','b-o')
%     hold on
%     errorbar(repmat([1:4]',1,length(exp2)),(squeeze(gbsall.medians.smeds(ff,6:9,exp2))' - repmat([0 1000 1250 1750],length(exp2),1))',gbsall.mlci(ff,6:9,exp2)',gbsall.muci(ff,6:9,exp2)','r-o')
%     xlim([0 5])
%     set(gca,'XTick',1:4)
%     set(gca,'XTickLabel',xlab(6:9))
    uncertplot(2,smeds(ff,:,exp1),mlci(ff,:,exp1),muci(ff,:,exp1),3,6:9,1,blue2,blue2,xlab,'jitter')
    hold on
    uncertplot(2,smeds(ff,:,exp2),mlci(ff,:,exp2),muci(ff,:,exp2),3,6:9,1,red2,red2,xlab,'jitter')
    title('All Subject Medians 95CI, Latency')
    legend({'exp1','exp2'})
    xlabel('jittered by subject')
    
    %tmax
%     figure(3)
%     set(gcf,'Color',[1 1 1])
%     set(gcf,'Position',[100 100 840 630])
%     errorbar(ones(1,length(exp1)),squeeze(gbsall.medians.smeds(ff,10,exp1))',gbsall.mlci(ff,10,exp1)',gbsall.muci(ff,10,exp1)','b-o')
%     hold on
%     errorbar(ones(1,length(exp2)),squeeze(gbsall.medians.smeds(ff,10,exp2))',gbsall.mlci(ff,10,exp2)',gbsall.muci(ff,10,exp2)','r-o')
%     xlim([0 2])
%     set(gca,'XTick',1)
%     set(gca,'XTickLabel',xlab(10))
    uncertplot(3,smeds(ff,:,exp1),mlci(ff,:,exp1),muci(ff,:,exp1),3,10,1,blue2,blue2,xlab,'jitter')
    hold on
    uncertplot(3,smeds(ff,:,exp2),mlci(ff,:,exp2),muci(ff,:,exp2),3,10,1,red2,red2,xlab,'jitter')
    title('All Subject Medians 95CI, tmax')
    legend({'exp1','exp2'})
    xlabel('jittered by subject')
    
    %yint
%     figure(4)
%     set(gcf,'Color',[1 1 1])
%     set(gcf,'Position',[100 100 840 630])
%     errorbar(ones(1,length(exp1)),squeeze(gbsall.medians.smeds(ff,11,exp1))',gbsall.mlci(ff,11,exp1)',gbsall.muci(ff,11,exp1)','b-o')
%     hold on
%     errorbar(ones(1,length(exp2)),squeeze(gbsall.medians.smeds(ff,11,exp2))',gbsall.mlci(ff,11,exp2)',gbsall.muci(ff,11,exp2)','r-o')
%     xlim([0 2])
%     set(gca,'XTick',1)
%     set(gca,'XTickLabel',xlab(11))
    uncertplot(4,smeds(ff,:,exp1),mlci(ff,:,exp1),muci(ff,:,exp1),3,11,1,blue2,blue2,xlab,'jitter')
    hold on
    uncertplot(4,smeds(ff,:,exp2),mlci(ff,:,exp2),muci(ff,:,exp2),3,11,1,red2,red2,xlab,'jitter')
    title('All Subject Medians 95CI, yint')
    legend({'exp1','exp2'})
    xlabel('jittered by subject')
end

fig = 1:4;
fignames = {'amp_allsj_exp','latency_allsj_exp','tmax_allsj_exp','yint_allsj_exp'};
figprefix = '';
filedir = [datadir type '_all/plot'];

rd_saveAllFigs(fig,fignames,figprefix, filedir)

%%
close all

repsjs = [3 10 4 12 8 20];
color2 = [0 0 1; 0 0 0.7; 1 0 0; 0.7 0 0; 0 1 0; 0 0.7 0];

repcolors = {
    [0 0 1]
    [0 0 1]
    [1 0 0]
    [1 0 0]
    [0 1 0]
    [0 1 0]};
repmarker = {
    [0 0 1]
    'none'
    [1 0 0]
    'none'
    [0 1 0]
    'none'};
    
set(0,'DefaultAxesColorOrder',color2)

for ff = 1:length(gbsall.fields)
    %beta plot
    uncertplot(1,smeds(ff,:,repsjs),mlci(ff,:,repsjs),muci(ff,:,repsjs),3,1:5,1,repcolors,repmarker,xlab,'jitter')
    legend(subjects(repsjs))
    title('Repeat Subject Medians 95CI, Latency')
    xlabel('jittered by subject')
    
    %latency plot
    uncertplot(2,smeds(ff,:,repsjs),mlci(ff,:,repsjs),muci(ff,:,repsjs),3,6:9,1,repcolors,repmarker,xlab,'jitter')
    title('Repeat Subject Medians 95CI, Latency')
    legend(subjects(repsjs))
    xlabel('jittered by subject')
    
    %tmax
    uncertplot(3,smeds(ff,:,repsjs),mlci(ff,:,repsjs),muci(ff,:,repsjs),3,10,1,repcolors,repmarker,xlab,'jitter')
    title('Repeat Subject Medians 95CI, tmax')
    legend(subjects(repsjs))
    xlabel('jittered by subject')
    
    %yint
    uncertplot(4,smeds(ff,:,repsjs),mlci(ff,:,repsjs),muci(ff,:,repsjs),3,11,1,repcolors,repmarker,xlab,'jitter')
    title('Repeat Subject Medians 95CI, yint')
    legend(subjects(repsjs))
    xlabel('jittered by subject')
end

fig = 1:4;
fignames = {'amp_repsj_exp','latency_repsj_exp','tmax_repsj_exp','yint_repsj_exp'};
figprefix = '';
filedir = [datadir type '_all/plot'];

rd_saveAllFigs(fig,fignames,figprefix, filedir)


function p = uncertplot(fignum,X,lci,uci,pdim,pmind,sjind,colorcell,markercell,xlab,varargin)
    
    if any(strcmp(varargin,'jitter'))
        rr = (0.05*size(X,pdim))/2;
        xjit = linspace(-rr,rr,size(X,pdim));
    else
        xjit = zeros(1,size(X,pdim));
    end
    
    figure(fignum)
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 840 630])
    hold on
    
    for pp = 1:size(X,pdim)
        if pdim == 1
            p = errorbar(pmind + xjit(pp),X(pp,pmind,sjind),lci(pp,pmind,sjind),uci(pp,pmind,sjind),'o','color',colorcell{pp},'MarkerFaceColor',markercell{pp});
        elseif pdim == 3
            p = errorbar(pmind + xjit(pp),X(sjind,pmind,pp),lci(sjind,pmind,pp),uci(sjind,pmind,pp),'o','color',colorcell{pp},'MarkerFaceColor',markercell{pp});
        end
    end
    
    xlim([min(pmind)-1 max(pmind)+1])
    set(gca,'XTick',pmind)
    set(gca,'XTickLabel',xlab(pmind))

end

end

