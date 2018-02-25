%gbs fit figs
close all
type = 'tvc';
datadir = '/Users/jakeparker/Google Drive/TA_Pupil/HPC/';
basedir = '/Users/jakeparker/Documents/MATLAB';
eind = [1:9 12 13];

cd(basedir)
load(['E0E3' type '_12_12_17.mat'])
eval(['pa = pa_' type ';'])
cd([datadir type '_all/fit'])
load(['gbs_E0E3' type '_ALL'])

conditions = reshape(gbsall.fields,2,length(gbsall.fields)/2)';
conditions = reshape(conditions,3,length(gbsall.fields)/3);

%subject box-whisker plots
for ss = 1:length(gbsall.subjects)
    
    figure(1)
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 (840) (315*size(conditions,2)/2)])
    figure(2)
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 (840) (315*size(conditions,2)/2)])
    
    for cc = 1:size(conditions,2)
        
        tt = conditions{1,cc}(1:2);
        if strcmp(type,'tvc')
            gtitle = [tt conditions{1,cc}(4) ' vni'];
        elseif strcmp(type,'ta')
            gtitle = [tt ' anu'];
        end
        
        if strcmp(tt,'t1')
            pind = [2 7];
        elseif strcmp(tt,'t2')
            pind = [3 8];
        end
        
        %Beta plot
        figure(1)
        subplot(size(conditions,2)/2,2,cc)
        tempmat1 = [gbsall.(gbsall.subjects{ss}).(conditions{1,cc}).glm_params(:,pind(1)) gbsall.(gbsall.subjects{ss}).(conditions{2,cc}).glm_params(:,pind(1)) gbsall.(gbsall.subjects{ss}).(conditions{3,cc}).glm_params(:,pind(1))];
        tempmat2 = [pa.(conditions{1,cc}).models.betas(ss,pind(1)) pa.(conditions{2,cc}).models.betas(ss,pind(1)) pa.(conditions{3,cc}).models.betas(ss,pind(1))];
        bplot(tempmat1,'outliers');
        hold on
        plot(1:3,tempmat2,'*g')
        set(gca,'XTick',[1 2 3])
        set(gca,'XTickLabel',{conditions{1,cc} conditions{2,cc} conditions{3,cc}})
        title([gbsall.subjects{ss} ' ' gtitle ' Amplitude'])
        set(gcf,'Color',[1 1 1])
        set(gcf,'Position',[100 100 (840) (315*size(conditions,2)/2)])
%         xl = xlim;
%         yl = ylim;
%         xlim([xl(1)-1 xl(2)+2])
%         ylim([yl(1)-1 yl(2)+1])
%         legend(leg)
    
        %Latency plot
        figure(2)
        subplot(size(conditions,2)/2,2,cc)
        tempmat1 = [gbsall.(gbsall.subjects{ss}).(conditions{1,cc}).glm_params(:,pind(2)) gbsall.(gbsall.subjects{ss}).(conditions{2,cc}).glm_params(:,pind(2)) gbsall.(gbsall.subjects{ss}).(conditions{3,cc}).glm_params(:,pind(2))];
        tempmat2 = [pa.(conditions{1,cc}).models.locations(ss,pind(2)-5) pa.(conditions{2,cc}).models.locations(ss,pind(2)-5) pa.(conditions{3,cc}).models.locations(ss,pind(2)-5)];
        bplot(tempmat1,'outliers');
        hold on
        plot(1:3,tempmat2,'*g')
        set(gca,'XTick',[1 2 3])
        set(gca,'XTickLabel',{conditions{1,cc} conditions{2,cc} conditions{3,cc}})
        title([gbsall.subjects{ss} ' ' gtitle ' Latency'])
        set(gcf,'Color',[1 1 1])
        set(gcf,'Position',[100 100 (840) (315*size(conditions,2)/2)])
%         leg = [leg 'actual'];
%         xl = xlim;
%         yl = ylim;
%         xlim([xl(1)-1 xl(2)+2])
%         ylim([yl(1)-1 yl(2)+1])
%         legend(leg)
        
    end
    
    fig = 1:2;
    fignames = {['gbs_' gbsall.subjects{ss} '_beta_bw'],['gbs_' gbsall.subjects{ss} '_latency_bw']};
    figprefix = '';
    filedir = [datadir type '_all/plot'];
    
    rd_saveAllFigs(fig,fignames,figprefix, filedir)
    
    close all
end

gbsall.group = [];
for f = 1:length(gbsall.fields)
    gbsall.group.(gbsall.fields{f}) = nan(100,11);
end

for f = 1:length(gbsall.fields)
    for ex = 1:100
        tempmat = nan(length(gbsall.subjects),11);
        for ss = 1:length(gbsall.subjects)
            tempmat(ss,:) = gbsall.(gbsall.subjects{ss}).(gbsall.fields{f}).glm_params(ex,eind);
        end
        gbsall.group.(gbsall.fields{f})(ex,:) = mean(tempmat,1);
    end
end

figure(1)
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (840) (315*size(conditions,2)/2)])
figure(2)
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (840) (315*size(conditions,2)/2)])
figure(3)
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (840) (315*size(conditions,2)/2)])
figure(4)
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (840) (315*size(conditions,2)/2)])

for cc = 1:size(conditions,2)
    
    tt = conditions{1,cc}(1:2);
    if strcmp(type,'tvc')
        gtitle = [tt conditions{1,cc}(4) ' vni'];
        ctitle = {[tt conditions{1,cc}(4) 'v-i'],[tt conditions{1,cc}(4) 'v-n'],[tt conditions{1,cc}(4) 'n-i']};
    elseif strcmp(type,'ta')
        gtitle = [tt ' anu'];
        ctitle = {[tt 'a-u'],[tt 'a-n'],[tt 'n-u']};
    end
    
    if strcmp(tt,'t1')
        pind = [2 7];
    elseif strcmp(tt,'t2')
        pind = [3 8];
    end
    
    figure(1)
    subplot(size(conditions,2)/2,2,cc)
    tempmat1 = [gbsall.group.(conditions{1,cc})(:,pind(1)) gbsall.group.(conditions{2,cc})(:,pind(1)) gbsall.group.(conditions{3,cc})(:,pind(1))];
    tempmat2 = [mean(pa.(conditions{1,cc}).models.betas(:,pind(1)),1) mean(pa.(conditions{2,cc}).models.betas(:,pind(1)),1) mean(pa.(conditions{3,cc}).models.betas(:,pind(1)),1)];
    bplot(tempmat1,'outliers');
    hold on
    plot(1:3,tempmat2,'*g')
    set(gca,'XTick',[1 2 3])
    set(gca,'XTickLabel',{conditions{1,cc} conditions{2,cc} conditions{3,cc}})
    title(['Group ' gtitle ' Amplitude'])
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 (840) (315*size(conditions,2)/2)])
    
    figure(3)
    subplot(size(conditions,2)/2,2,cc)
    bplot([tempmat1(:,1)-tempmat1(:,3) tempmat1(:,1)-tempmat1(:,2) tempmat1(:,2)-tempmat1(:,3)],'outliers');
    hold on
    plot(1:3,[tempmat2(1)-tempmat2(3) tempmat2(1)-tempmat2(3) tempmat2(2)-tempmat2(3)],'*g')
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',ctitle)
    title('Group Contrasts Amplitude')
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 (840) (315*size(conditions,2)/2)])
    
    figure(2)
    subplot(size(conditions,2)/2,2,cc)
    tempmat1 = [gbsall.group.(conditions{1,cc})(:,pind(2)) gbsall.group.(conditions{2,cc})(:,pind(2)) gbsall.group.(conditions{3,cc})(:,pind(2))];
    tempmat2 = [mean(pa.(conditions{1,cc}).models.locations(:,pind(2)-5),1) mean(pa.(conditions{2,cc}).models.locations(:,pind(2)-5),1) mean(pa.(conditions{3,cc}).models.locations(:,pind(2)-5),1)];
    bplot(tempmat1,'outliers');
    hold on
    plot(1:3,tempmat2,'*g')
    set(gca,'XTick',[1 2 3])
    set(gca,'XTickLabel',{conditions{1,cc} conditions{2,cc} conditions{3,cc}})
    title(['Group ' gtitle ' Latency'])
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 (840) (315*size(conditions,2)/2)])
    
    figure(4)
    subplot(size(conditions,2)/2,2,cc)
    bplot([tempmat1(:,1)-tempmat1(:,3) tempmat1(:,1)-tempmat1(:,2) tempmat1(:,2)-tempmat1(:,3)],'outliers');
    hold on
    plot(1:3,[tempmat2(1)-tempmat2(3) tempmat2(1)-tempmat2(3) tempmat2(2)-tempmat2(3)],'*g')
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',ctitle)
    title('Group Contrasts Latency')
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 (840) (315*size(conditions,2)/2)])
end

fig = 1:4;
fignames = {'gbs_group_beta_bw','gbs_group_latency_bw','gbs_group_contrast_beta','gbs_group_contrast_latency'};
figprefix = '';
filedir = [datadir type '_all/plot'];

rd_saveAllFigs(fig,fignames,figprefix, filedir)

close all

cd([datadir type '_all/fit'])
save(['gbs_E0E3' type '_ALL'],'gbsall')

    
    