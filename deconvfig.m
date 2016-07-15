load eyedataE3.mat

close all

ymin = -0.1;
ymax = 0.1;

Xmat = zeros(duration-400,3,length(subjects));
Bmat = zeros(5,3,length(subjects));

for i = 1:length(subjects)
    
    [Xmat(:,1,i),Bmat(:,1,i)] = pupildeconv(nanmean(t1norm(:,:,i)),duration);
    [Xmat(:,2,i),Bmat(:,2,i)] = pupildeconv(nanmean(t2norm(:,:,i)),duration);
    [Xmat(:,3,i),Bmat(:,3,i)] = pupildeconv(nanmean(neutralnorm(:,:,i)),duration);
    
    figure
    subplot(1,3,1)
    bar(1:5,Bmat(:,1,i),'b')
    hold on
    title([subjects{i} ' t1'])
    xlabel('B number')
    xlim([0 6])
    set(gca,'XTickLabel',{'B1' 'B2' 'B3' 'B4' 'S'})
    
    subplot(1,3,2)
    bar(1:5,Bmat(:,2,i),'r')
    hold on
    title([subjects{i} ' t2'])
    xlabel('B number')
    xlim([0 6])
    set(gca,'XTickLabel',{'B1' 'B2' 'B3' 'B4' 'S'})
    
    subplot(1,3,3)
    bar(1:5,Bmat(:,3,i),'g')
    hold on
    title([subjects{i} ' neutral'])
    xlabel('B number')
    xlim([0 6])
    set(gca,'XTickLabel',{'B1' 'B2' 'B3' 'B4' 'S'})
    
    figure
    subplot(3,1,1)
    plot(window(1):window(2),nanmean(t1norm(:,:,i)),'b')
    hold on
    plot(Xmat(:,1,i),'r')
    plot([1000 1000],[ymin ymax])
    plot([1250 1250],[ymin ymax])
    plot([1750 1750],[ymin ymax])
    title([subjects{i} ' t1'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    
    subplot(3,1,2)
    plot(window(1):window(2),nanmean(t2norm(:,:,i)),'b')
    hold on
    plot(Xmat(:,2,i),'r')
    plot([1000 1000],[ymin ymax])
    plot([1250 1250],[ymin ymax])
    plot([1750 1750],[ymin ymax])
    title([subjects{i} ' t2'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    
    subplot(3,1,3)
    plot(window(1):window(2),nanmean(neutralnorm(:,:,i)),'b')
    hold on
    plot(Xmat(:,3,i),'r')
    plot([1000 1000],[ymin ymax])
    plot([1250 1250],[ymin ymax])
    plot([1750 1750],[ymin ymax])
    title([subjects{i} ' neutral'])
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    
    figdir = [filedir '/' subjects{i}];
    fig = [1 2];
    fignames = {'beta_weights' 'measured_vs_calculated'};
    figprefix = 'ta';
    
    rd_saveAllFigs(fig,fignames,figprefix, figdir)
    
    close all
    
end

X = zeros(duration-400,3);
B = zeros(5,3);

[X(:,1),B(:,1)] = pupildeconv(t1normwm,duration);
[X(:,2),B(:,2)] = pupildeconv(t2normwm,duration);
[X(:,3),B(:,3)] = pupildeconv(neutralnormwm,duration);

figure
subplot(1,3,1)
hold on
bar(1:5,B(:,1),'b')
title('group t1')
xlabel('B number')
xlim([0 6])
set(gca,'XTickLabel',{'B1' 'B2' 'B3' 'B4' 'S'})

subplot(1,3,2)
bar(1:5,B(:,2),'r')
hold on
title('group t2')
xlabel('B number')
xlim([0 6])
set(gca,'XTickLabel',{'B1' 'B2' 'B3' 'B4' 'S'})

subplot(1,3,3)
bar(1:5,B(:,3),'g')
hold on
title('group neutral')
xlabel('B number')
xlim([0 6])
set(gca,'XTickLabel',{'B1' 'B2' 'B3' 'B4' 'S'})

    figure
    subplot(3,1,1)
    plot(window(1):window(2),t1normwm,'b')
    hold on
    plot(X(:,1),'r')
    plot([1000 1000],[ymin ymax])
    plot([1250 1250],[ymin ymax])
    plot([1750 1750],[ymin ymax])
    title('group t1')
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    
    subplot(3,1,2)
    plot(window(1):window(2),t2normwm,'b')
    hold on
    plot(X(:,2),'r')
    plot([1000 1000],[ymin ymax])
    plot([1250 1250],[ymin ymax])
    plot([1750 1750],[ymin ymax])
    title('group t2')
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    
    subplot(3,1,3)
    plot(window(1):window(2),neutralnormwm,'b')
    hold on
    plot(X(:,3),'r')
    plot([1000 1000],[ymin ymax])
    plot([1250 1250],[ymin ymax])
    plot([1750 1750],[ymin ymax])
    title('group neutral')
    xlabel('time (ms)')
    ylabel('pupil area (normalized)')
    
figure
subplot(3,1,1)
bar(squeeze(Bmat(:,1,:)))
title('subject t1 B weights')
xlabel('B number')
xlim([0 6])
set(gca,'XTickLabel',{'B1' 'B2' 'B3' 'B4' 'S'})

subplot(3,1,2)
bar(squeeze(Bmat(:,2,:)))
title('subject t2 B weights')
xlabel('B number')
xlim([0 6])
set(gca,'XTickLabel',{'B1' 'B2' 'B3' 'B4' 'S'})

subplot(3,1,3)
bar(squeeze(Bmat(:,3,:)))
title('subject neutral weights')
xlabel('B number')
xlim([0 6])
set(gca,'XTickLabel',{'B1' 'B2' 'B3' 'B4' 'S'})

figure
subplot(1,3,1)
hold on
bar(1:5,mean(Bmat(:,1,:),3),'b')
title('IndAvg T1')
xlabel('B number')
xlim([0 6])
set(gca,'XTickLabel',{'B1' 'B2' 'B3' 'B4' 'S'})
errorbar(1:5,mean(Bmat(:,1,:),3),std(Bmat(:,1,:),0,3)/sqrt(length(Bmat(:,1,:))),'k','LineStyle','none')

subplot(1,3,2)
bar(1:5,mean(Bmat(:,2,:),3),'r')
hold on
title('IndAvg T2')
xlabel('B number')
xlim([0 6])
set(gca,'XTickLabel',{'B1' 'B2' 'B3' 'B4' 'S'})
errorbar(1:5,mean(Bmat(:,2,:),3),std(Bmat(:,2,:),0,3)/sqrt(length(Bmat(:,1,:))),'k','LineStyle','none')

subplot(1,3,3)
bar(1:5,mean(Bmat(:,3,:),3),'g')
hold on
title('IndAvg Neutral')
xlabel('B number')
xlim([0 6])
set(gca,'XTickLabel',{'B1' 'B2' 'B3' 'B4' 'S'})
errorbar(1:5,mean(Bmat(:,3,:),3),std(Bmat(:,3,:),0,3)/sqrt(length(Bmat(:,1,:))),'k','LineStyle','none')

sbpl = ceil(sqrt(length(subjects)));

if length(subjects) < sbpl^2
    Bmat = cat(3,Bmat,zeros(5,3,(sbpl^2)-length(subjects)));
end

figure

for i = 1:sbpl
    
    for j = 1:sbpl
            subplot(sbpl,sbpl,j+(i-1)*sbpl)
            bar([1 2],[Bmat(2,1,j+(i-1)*sbpl) Bmat(2,3,j+(i-1)*sbpl) Bmat(2,2,j+(i-1)*sbpl);...
            Bmat(3,1,j+(i-1)*sbpl) Bmat(3,3,j+(i-1)*sbpl) Bmat(3,2,j+(i-1)*sbpl)])
%             bar([1 2], [Bmat(2,1,j+(i-1)*sbpl); Bmat(3,1,j+(i-1)*sbpl)],'b','grouped')
%             hold on
%             bar([1 2], [Bmat(2,3,j+(i-1)*sbpl); Bmat(3,3,j+(i-1)*sbpl)],'g','grouped')
%             bar([1 2], [Bmat(2,2,j+(i-1)*sbpl); Bmat(3,2,j+(i-1)*sbpl)],'r','grouped')
            title(sprintf('%d',j+(i-1)*sbpl))
            set(gca,'XTickLabel',{'appT1' 'appT2'})
            xlim([0 3])
    end
end
%         bar([1 2],[Bmat(2,1,j+(i-1)*sbpl) Bmat(2,3,j+(i-1)*sbpl) Bmat(2,2,j+(i-1)*sbpl);...
%             Bmat(3,1,j+(i-1)*sbpl) Bmat(3,3,j+(i-1)*sbpl)
%             Bmat(3,2,j+(i-1)*sbpl)], 'b','g','r')



    figdir = filedir;
    fig = [1 2 3 4 5];
    fignames = {'groupBweights' 'group_mvc' 'subjectBweights' 'IndAvgBweights' 'T1T2comparisons'};
    figprefix = 'ta';
    
    rd_saveAllFigs(fig,fignames,figprefix, figdir)

    