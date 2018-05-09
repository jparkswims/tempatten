function pa_not_T1L500_sumfigs(pa,m)

conditions = reshape(pa.fields,2,length(pa.fields)/2)';
conditions = reshape(conditions,3,length(pa.fields)/3);
no5 = struct('fields',[]);
for ff = 1:length(pa.fields)
    no5.([pa.fields{ff} 'B']) = nan(length(pa.subjects),1);
    no5.([pa.fields{ff} 'L']) = nan(length(pa.subjects),1);
end
%no5.fields  = fields(no5);
figdir = '/Users/jakeparker/Google Drive/TA_Pupil/Figures/sumfigs_exclT1L500/';
close all

for cc = 1:size(conditions,2)
    
%     c1B = nan(length(pa.subjects),1);
%     c2B = nan(length(pa.subjects),1);
%     c3B = nan(length(pa.subjects),1);
%     c1L = nan(length(pa.subjects),1);
%     c2L = nan(length(pa.subjects),1);
%     c3L = nan(length(pa.subjects),1);
    tt = conditions{1,cc}(1:2);
    if strcmp(tt,'t1')
        lind = 2;
    elseif strcmp(tt,'t2')
        lind = 3;
    end
    
    for ss = 1:length(pa.subjects)
        if ~(pa.(conditions{1,cc}).models(1).locations(ss,2) < 510)
            no5.([conditions{1,cc} 'B'])(ss) = pa.(conditions{1,cc}).models(m).(tt)(ss);
            no5.([conditions{1,cc} 'L'])(ss) = pa.(conditions{1,cc}).models(m).locations(ss,lind);
%             c1B(ss) = pa.(conditions{1,cc}).models(m).(tt)(ss);
%             c1L(ss) = pa.(conditions{1,cc}).models(m).locations(ss,lind);
        end
        if ~(pa.(conditions{2,cc}).models(1).locations(ss,2) < 510)
            no5.([conditions{2,cc} 'B'])(ss) = pa.(conditions{2,cc}).models(m).(tt)(ss);
            no5.([conditions{2,cc} 'L'])(ss) = pa.(conditions{2,cc}).models(m).locations(ss,lind);
%             c2B(ss) = pa.(conditions{2,cc}).models(m).(tt)(ss);
%             c2L(ss) = pa.(conditions{2,cc}).models(m).locations(ss,lind);
        end
        if ~(pa.(conditions{3,cc}).models(1).locations(ss,2) < 510)
            no5.([conditions{3,cc} 'B'])(ss) = pa.(conditions{3,cc}).models(m).(tt)(ss);
            no5.([conditions{3,cc} 'L'])(ss) = pa.(conditions{3,cc}).models(m).locations(ss,lind);
%             c3B(ss) = pa.(conditions{3,cc}).models(m).(tt)(ss);
%             c3L(ss) = pa.(conditions{3,cc}).models(m).locations(ss,lind);
        end
    end
    
    %figure of subject fit scatter
    figure(1)
    subplot(size(conditions,2)/2,2,cc)
    plot(1:3,[no5.([conditions{1,cc} 'B']) no5.([conditions{2,cc} 'B']) no5.([conditions{3,cc} 'B'])],'o')
    hold on
    plot(1:3,nanmean([no5.([conditions{1,cc} 'B']) no5.([conditions{2,cc} 'B']) no5.([conditions{3,cc} 'B'])]),'k+')
    xlim([0 4])
    set(gca,'XTick',[1 2 3])
    set(gca,'XTickLabel',{conditions{1,cc} conditions{2,cc} conditions{3,cc}})
    title('Subject Amplitude Means excl. T1L500 fits')
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 (840) (315*size(conditions,2)/2)])
    
    figure(2)
    subplot(size(conditions,2)/2,2,cc)
    plot(1:3,[no5.([conditions{1,cc} 'L']) no5.([conditions{2,cc} 'L']) no5.([conditions{3,cc} 'L'])],'o')
    hold on
    plot(1:3,nanmean([no5.([conditions{1,cc} 'L']) no5.([conditions{2,cc} 'L']) no5.([conditions{3,cc} 'L'])]),'k+')
    xlim([0 4])
    set(gca,'XTick',[1 2 3])
    set(gca,'XTickLabel',{conditions{1,cc} conditions{2,cc} conditions{3,cc}})
    title('Subject Latency Means excl. T1L500 fits')
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 (840) (315*size(conditions,2)/2)])
    
    figure(3)
    subplot(1,size(conditions,2),cc)
    errorbar(1:3,nanmean([no5.([conditions{1,cc} 'B']) no5.([conditions{2,cc} 'B']) no5.([conditions{3,cc} 'B'])],1),nanste([no5.([conditions{1,cc} 'B']) no5.([conditions{2,cc} 'B']) no5.([conditions{3,cc} 'B'])],0,1),'ko','MarkerFaceColor','black')
    set(gca,'XTick',[1 2 3])
    set(gca,'XTickLabel',{conditions{1,cc} conditions{2,cc} conditions{3,cc}})
    title('Subject Amplitude Means excl. T1L500 fits')
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 (420*size(conditions,2)) (315)])
    
    figure(4)
    subplot(1,size(conditions,2),cc)
    errorbar(1:3,nanmean([no5.([conditions{1,cc} 'L']) no5.([conditions{2,cc} 'L']) no5.([conditions{3,cc} 'L'])],1),nanste([no5.([conditions{1,cc} 'L']) no5.([conditions{2,cc} 'L']) no5.([conditions{3,cc} 'L'])],0,1),'ko','MarkerFaceColor','black')
    set(gca,'XTick',[1 2 3])
    set(gca,'XTickLabel',{conditions{1,cc} conditions{2,cc} conditions{3,cc}})
    title('Subject Latency Means excl. T1L500 fits')
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 (420*size(conditions,2)) (315)])
    
end

if strcmp(pa.type,'tvc')
    
    figure(3)
    subplot(1,4,1)
    yl1 = ylim;
    subplot(1,4,2)
    yl2 = ylim;
    
    ymin = min([yl1 yl2]);
    ymax = max([yl1 yl2]);
    
    subplot(1,4,1)
    ylim([ymin ymax])
    subplot(1,4,2)
    ylim([ymin ymax])
    
    figure(3)
    subplot(1,4,3)
    yl1 = ylim;
    subplot(1,4,4)
    yl2 = ylim;
    
    ymin = min([yl1 yl2]);
    ymax = max([yl1 yl2]);
    
    subplot(1,4,3)
    ylim([ymin ymax])
    subplot(1,4,4)
    ylim([ymin ymax])
    
    figure(4)
    subplot(1,4,1)
    yl1 = ylim;
    subplot(1,4,2)
    yl2 = ylim;
    
    ymin = min([yl1 yl2]);
    ymax = max([yl1 yl2]);
    
    subplot(1,4,1)
    ylim([ymin ymax])
    subplot(1,4,2)
    ylim([ymin ymax])
    
    figure(4)
    subplot(1,4,3)
    yl1 = ylim;
    subplot(1,4,4)
    yl2 = ylim;
    
    ymin = min([yl1 yl2]);
    ymax = max([yl1 yl2]);
    
    subplot(1,4,3)
    ylim([ymin ymax])
    subplot(1,4,4)
    ylim([ymin ymax])
    
end

fig = 1:4;
fignames = {'_beta_scatter','_latency_scatter','_beta_error','_latency_error'};
figprefix = pa.type;
filedir = figdir;

rd_saveAllFigs(fig,fignames,figprefix, filedir)

close all

% if strcmp(pa.type,'tvc')
%     Bmat = nan(length(pa.subjects),2,3,2);
%     Lmat = nan(length(pa.subjects),2,3,2);
%     for ff = 1:length(pa.fields)
%         
% elseif strcmp(pa.type,'ta')
%     Bmat = nan(length(pa.subjects),2,3);
%     Lmat = nan(length(pa.subjects),2,3,2);
% end

if strcmp(pa.type,'tvc')
    
%     t1ind = [2 7];
%     t2ind = [3 8];
    
    %validity x target
    t1vB = [no5.t1vcB ; no5.t1vfB];
    t1vL = [no5.t1vcL ; no5.t1vfL];
    t1nB = [no5.t1ncB ; no5.t1nfB];
    t1nL = [no5.t1ncL ; no5.t1nfL];
    t1iB = [no5.t1icB ; no5.t1ifB];
    t1iL = [no5.t1icL ; no5.t1ifL];
    t2vB = [no5.t2vcB ; no5.t2vfB];
    t2vL = [no5.t2vcL ; no5.t2vfL];
    t2nB = [no5.t2ncB ; no5.t2nfB];
    t2nL = [no5.t2ncL ; no5.t2nfL];
    t2iB = [no5.t2icB ; no5.t2ifB];
    t2iL = [no5.t2icL ; no5.t2ifL];
    
    xax = {'V','N','I'};
    
    %amp
    figure(1)
    errorbar(1:3,nanmean([t1vB t1nB t1iB]),nanste([t1vB t1nB t1iB],0,1),'b')
    hold on
    errorbar(1:3,nanmean([t2vB t2nB t2iB]),nanste([t2vB t2nB t2iB],0,1),'r')
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',xax)
    legend('T1','T2')
    title('Validity x Target, Amplitude')
    
    %lat
    figure(2)
    errorbar(1:3,nanmean([t1vL t1nL t1iL]),nanste([t1vL t1nL t1iL],0,1),'b')
    hold on
    errorbar(1:3,nanmean([t2vL t2nL t2iL]),nanste([t2vL t2nL t2iL],0,1),'r')
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',xax)
    legend('T1','T2')
    title('Validity x Target, Latency')
    
    %accuracy x target
    t1cB = [no5.t1vcB ; no5.t1ncB ; no5.t1icB];
    t1cL = [no5.t1vcL ; no5.t1ncL ; no5.t1icL];
    t1fB = [no5.t1vfB ; no5.t1nfB ; no5.t1ifB];
    t1fL = [no5.t1vfL ; no5.t1nfL ; no5.t1ifL];
    t2cB = [no5.t2vcB ; no5.t2ncB ; no5.t2icB];
    t2cL = [no5.t2vcL ; no5.t2ncL ; no5.t2icL];
    t2fB = [no5.t2vfB ; no5.t2nfB ; no5.t2ifB];
    t2fL = [no5.t2vfL ; no5.t2nfL ; no5.t2ifL];

    xax = {'C','F'};
    
    %amp
    figure(3)
    errorbar(1:2,nanmean([t1cB t1fB]),nanste([t1cB t1fB],0,1),'b')
    hold on
    errorbar(1:2,nanmean([t2cB t2fB]),nanste([t2cB t2fB],0,1),'r')
    set(gca,'XTick',1:2)
    set(gca,'XTickLabel',xax)
    legend('T1','T2')
    title('Accuracy x Target, Amplitude')
    
    %lat
    figure(4)
    errorbar(1:2,nanmean([t1cL t1fL]),nanste([t1cL t1fL],0,1),'b')
    hold on
    errorbar(1:2,nanmean([t2cL t2fL]),nanste([t2cL t2fL],0,1),'r')
    set(gca,'XTick',1:2)
    set(gca,'XTickLabel',xax)
    legend('T1','T2')
    title('Accuracy x Target, Latency')
    
    %validity x accuracy
    vcB = [no5.t1vcB ; no5.t2vcB];
    ncB = [no5.t1ncB ; no5.t2ncB];
    icB = [no5.t1icB ; no5.t2icB];
    vfB = [no5.t1vfB ; no5.t2vfB];
    nfB = [no5.t1nfB ; no5.t2nfB];
    ifB = [no5.t1ifB ; no5.t2ifB];
    vcL = [no5.t1vcL ; no5.t2vcL];
    ncL = [no5.t1ncL ; no5.t2ncL];
    icL = [no5.t1icL ; no5.t2icL];
    vfL = [no5.t1vfL ; no5.t2vfL];
    nfL = [no5.t1nfL ; no5.t2nfL];
    ifL = [no5.t1ifL ; no5.t2ifL];
    xax = {'V','N','I'};
    
    %amp
    figure(5)
    errorbar(1:3,nanmean([vcB ncB icB]),nanste([vcB ncB icB],0,1),'b')
    hold on
    errorbar(1:3,nanmean([vfB nfB ifB]),nanste([vfB nfB ifB],0,1),'r')
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',xax)
    legend('C','F')
    title('Validity x Accuracy, Amplitude')
    
    %lat
    figure(6)
    errorbar(1:3,nanmean([vcL ncL icL]),nanste([vcL ncL icL],0,1),'b')
    hold on
    errorbar(1:3,nanmean([vfL nfL ifL]),nanste([vfL nfL ifL],0,1),'r')
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',xax)
    legend('C','F')
    title('Validity x Accuracy, Latency')
    
    %validity
    vB = [no5.t1vcB ; no5.t1vfB  ; no5.t2vcB  ; no5.t2vfB ];
    nB = [no5.t1ncB ; no5.t1nfB  ; no5.t2ncB  ; no5.t2nfB ];
    iB = [no5.t1icB ; no5.t1ifB  ; no5.t2icB  ; no5.t2ifB ];
    vL = [no5.t1vcL ; no5.t1vfL  ; no5.t2vcL  ; no5.t2vfL ];
    nL = [no5.t1ncL ; no5.t1nfL  ; no5.t2ncL  ; no5.t2nfL ];
    iL = [no5.t1icL ; no5.t1ifL  ; no5.t2icL  ; no5.t2ifL ];
    xax = {'V','N','I'};
    
    %amp
    figure(7)
    errorbar(1:3,nanmean([vB nB iB]),nanste([vB nB iB],0,1),'b')
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',xax)
    title('Validity, Amplitude')
    
    %lat
    figure(8)
    errorbar(1:3,nanmean([vL nL iL]),nanste([vL nL iL],0,1),'b')
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',xax)
    title('Validity, Latency')
    
    %accuracy
    cB = [no5.t1vcB ; no5.t1ncB ; no5.t1icB ; no5.t2vcB ; no5.t2ncB ; no5.t2icB];
    fB = [no5.t1vfB ; no5.t1nfB ; no5.t1ifB ; no5.t2vfB ; no5.t2nfB ; no5.t2ifB];
    cL = [no5.t1vcL ; no5.t1ncL ; no5.t1icL ; no5.t2vcL ; no5.t2ncL ; no5.t2icL];
    fL = [no5.t1vfL ; no5.t1nfL ; no5.t1ifL ; no5.t2vfL ; no5.t2nfL ; no5.t2ifL];
    xax = {'C','F'};
    
    %amp
    figure(9)
    errorbar(1:2,nanmean([cB fB]),nanste([cB fB],0,1),'b')
    set(gca,'XTick',1:2)
    set(gca,'XTickLabel',xax)
    title('Accuracy, Amplitude')
    
    %amp
    figure(10)
    errorbar(1:2,nanmean([cL fL]),nanste([cL fL],0,1),'b')
    set(gca,'XTick',1:2)
    set(gca,'XTickLabel',xax)
    title('Accuracy, Latency')
    
    %target
    t1B = [no5.t1vcB ; no5.t1ncB ; no5.t1icB ; no5.t1vfB ; no5.t1nfB ; no5.t1ifB];
    t2B = [no5.t2vcB ; no5.t2ncB ; no5.t2icB ; no5.t2vfB ; no5.t2nfB ; no5.t2ifB];
    t1L = [no5.t1vcL ; no5.t1ncL ; no5.t1icL ; no5.t1vfL ; no5.t1nfL ; no5.t1ifL];
    t2L = [no5.t2vcL ; no5.t2ncL ; no5.t2icL ; no5.t2vfL ; no5.t2nfL ; no5.t2ifL];
    xax = {'T1','T2'};
    
    %amp
    figure(11)
    errorbar(1:2,nanmean([t1B t2B]),nanste([t1B t2B],0,1),'b')
    set(gca,'XTick',1:2)
    set(gca,'XTickLabel',xax)
    title('Target, Amplitude')
    
    %amp
    figure(12)
    errorbar(1:2,nanmean([t1L t2L]),nanste([t1L t2L],0,1),'b')
    set(gca,'XTick',1:2)
    set(gca,'XTickLabel',xax)
    title('Target, Latency')
    
    fig = 1:12;
    fignames = {'ValidityTargetB','ValidityTargetL','AccuracyTargetB','AccuracyTargetL','ValidityAccuracyB','ValidityAccuracyL','ValidityB','ValidityL','AccuracyB','AccuracyL','TargetB','TargetL'};
    figprefix = pa.type;
    filedir = figdir;
    
    rd_saveAllFigs(fig,fignames,figprefix, filedir)
    
    close all
    
elseif strcmp(pa.type,'ta')
    
    %attention
    aB = [no5.t1aB ; no5.t2aB];
    aL = [no5.t1aL ; no5.t2aL];
    nB = [no5.t1nB ; no5.t2nB];
    nL = [no5.t1nL ; no5.t2nL];
    uB = [no5.t1uB ; no5.t2uB];
    uL = [no5.t1uL ; no5.t2uL];
    xax = {'A','N','U'};
    
    %amp
    figure(1)
    errorbar(1:3,nanmean([aB nB uB]),nanste([aB nB uB],0,1),'b')
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',xax)
    title('Attention, Amplitude')
    
    %lat
    figure(2)
    errorbar(1:3,nanmean([aL nL uL]),nanste([aL nL uL],0,1),'b')
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',xax)
    title('Attention, Latency')
    
    %target
    t1B = [no5.t1aB ; no5.t1nB ; no5.t1uB];
    t2B = [no5.t2aB ; no5.t2nB ; no5.t2uB];
    t1L = [no5.t1aL ; no5.t1nL ; no5.t1uL];
    t2L = [no5.t2aL ; no5.t2nL ; no5.t2uL];
    xax = {'T1','T2'};
    
    %amp
    figure(3)
    errorbar(1:2,nanmean([t1B t2B]),nanste([t1B t2B],0,1),'b')
    set(gca,'XTick',1:2)
    set(gca,'XTickLabel',xax)
    title('Target, Amplitude')
    
    %amp
    figure(4)
    errorbar(1:2,nanmean([t1L t2L]),nanste([t1L t2L],0,1),'b')
    set(gca,'XTick',1:2)
    set(gca,'XTickLabel',xax)
    title('Target, Latency')
    
    fig = 1:4;
    fignames = {'AttentionB','AttentionL','TargetB','TargetL'};
    figprefix = pa.type;
    filedir = figdir;
    
    rd_saveAllFigs(fig,fignames,figprefix, filedir)
    
    close all
    
end
            