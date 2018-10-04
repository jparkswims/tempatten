%gbs subject median figs
close all
type = 'ta';
datadir = '/Users/jakeparker/Google Drive/TA_Pupil/HPC/';
basedir = '/Users/jakeparker/Documents/MATLAB';
eind = [1:9 12 13];

cd(basedir)
load(['E0E3' type '_noL.mat'])
eval(['pa = pa_' type ';'])
cd([datadir type '_noL/fit'])
load(['gbs_E0E3' type '_ALL'])

conditions = reshape(gbsall.fields,2,length(gbsall.fields)/2)';
conditions = reshape(conditions,3,length(gbsall.fields)/3);

for ss = 1:length(gbsall.subjects)
    for ff = 1:length(gbsall.fields)
        gbsall.(gbsall.subjects{ss}).(gbsall.fields{ff}).glm_medians = nanmedian(gbsall.(gbsall.subjects{ss}).(gbsall.fields{ff}).glmparams,1);
    end
end

gbsall.medians = [];
for ff = 1:length(gbsall.fields)
    gbsall.medians.(gbsall.fields{ff}) = nan(21,11);
    for ss = 1:length(gbsall.subjects)
        gbsall.medians.(gbsall.fields{ff})(ss,:) = gbsall.(gbsall.subjects{ss}).(gbsall.fields{ff}).glm_medians(eind);
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
set(gcf,'Position',[100 100 (420*size(conditions,2)) (315)])
figure(4)
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (420*size(conditions,2)) (315)])

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
    plot(1:3,[gbsall.medians.(conditions{1,cc})(:,pind(1)) gbsall.medians.(conditions{2,cc})(:,pind(1)) gbsall.medians.(conditions{3,cc})(:,pind(1))],'o')
    hold on
    plot(1:3,mean([gbsall.medians.(conditions{1,cc})(:,pind(1)) gbsall.medians.(conditions{2,cc})(:,pind(1)) gbsall.medians.(conditions{3,cc})(:,pind(1))],1),'k+')
    xlim([0 4])
    set(gca,'XTick',[1 2 3])
    set(gca,'XTickLabel',{conditions{1,cc} conditions{2,cc} conditions{3,cc}})
    title(['Subject ' gtitle ' Amplitude Medians'])
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 (840) (315*size(conditions,2)/2)])
    
    figure(2)
    subplot(size(conditions,2)/2,2,cc)
    plot(1:3,[gbsall.medians.(conditions{1,cc})(:,pind(2)) gbsall.medians.(conditions{2,cc})(:,pind(2)) gbsall.medians.(conditions{3,cc})(:,pind(2))],'o')
    hold on
    plot(1:3,mean([gbsall.medians.(conditions{1,cc})(:,pind(2)) gbsall.medians.(conditions{2,cc})(:,pind(2)) gbsall.medians.(conditions{3,cc})(:,pind(2))],1),'k+')
    xlim([0 4])
    set(gca,'XTick',[1 2 3])
    set(gca,'XTickLabel',{conditions{1,cc} conditions{2,cc} conditions{3,cc}})
    title(['Subject ' gtitle ' Latency Medians'])
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 (840) (315*size(conditions,2)/2)])
    
    figure(3)
    subplot(1,size(conditions,2),cc)
    errorbar(1:3,mean([gbsall.medians.(conditions{1,cc})(:,pind(1)) gbsall.medians.(conditions{2,cc})(:,pind(1)) gbsall.medians.(conditions{3,cc})(:,pind(1))],1),ste([gbsall.medians.(conditions{1,cc})(:,pind(1)) gbsall.medians.(conditions{2,cc})(:,pind(1)) gbsall.medians.(conditions{3,cc})(:,pind(1))],0,1),'ko','MarkerFaceColor','black')
    set(gca,'XTick',[1 2 3])
    set(gca,'XTickLabel',{conditions{1,cc} conditions{2,cc} conditions{3,cc}})
    title(['Subject ' gtitle ' Amplitude Medians'])
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 (420*size(conditions,2)) (315)])
    
    figure(4)
    subplot(1,size(conditions,2),cc)
    errorbar(1:3,mean([gbsall.medians.(conditions{1,cc})(:,pind(2)) gbsall.medians.(conditions{2,cc})(:,pind(2)) gbsall.medians.(conditions{3,cc})(:,pind(2))],1),ste([gbsall.medians.(conditions{1,cc})(:,pind(2)) gbsall.medians.(conditions{2,cc})(:,pind(2)) gbsall.medians.(conditions{3,cc})(:,pind(2))],0,1),'ko','MarkerFaceColor','black')
    set(gca,'XTick',[1 2 3])
    set(gca,'XTickLabel',{conditions{1,cc} conditions{2,cc} conditions{3,cc}})
    title(['Subject ' gtitle ' Latency Medians'])
    set(gcf,'Color',[1 1 1])
    set(gcf,'Position',[100 100 (420*size(conditions,2)) (315)])
    
end

if strcmp(type,'tvc')
    
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
fignames = {'gbs_subject_medians_beta_scatter','gbs_subject_medians_latency_scatter','gbs_group_mean_beta','gbs_group_mean_latency'};
figprefix = '';
filedir = [datadir type '_noL/plots'];

rd_saveAllFigs(fig,fignames,figprefix, filedir)

close all

cd([datadir type '_noL/fit'])
save(['gbs_E0E3' type '_ALL'],'gbsall')

if strcmp(type,'tvc')
    
    t1ind = [2 7];
    t2ind = [3 8];
    
    %validity x target
    t1v = [gbsall.medians.t1vc ; gbsall.medians.t1vf];
    t1n = [gbsall.medians.t1nc ; gbsall.medians.t1nf];
    t1i = [gbsall.medians.t1ic ; gbsall.medians.t1if];
    t2v = [gbsall.medians.t2vc ; gbsall.medians.t2vf];
    t2n = [gbsall.medians.t2nc ; gbsall.medians.t2nf];
    t2i = [gbsall.medians.t2ic ; gbsall.medians.t2if];
    xax = {'V','N','I'};
    
    %amp
    figure(1)
    errorbar(1:3,mean([t1v(:,t1ind(1)) t1n(:,t1ind(1)) t1i(:,t1ind(1))]),ste([t1v(:,t1ind(1)) t1n(:,t1ind(1)) t1i(:,t1ind(1))],0,1),'b')
    hold on
    errorbar(1:3,mean([t2v(:,t2ind(1)) t2n(:,t2ind(1)) t2i(:,t2ind(1))]),ste([t2v(:,t2ind(1)) t2n(:,t2ind(1)) t2i(:,t2ind(1))],0,1),'r')
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',xax)
    legend('T1','T2')
    title('Validity x Target, Amplitude')
    
    %lat
    figure(2)
    errorbar(1:3,mean([t1v(:,t1ind(2)) t1n(:,t1ind(2)) t1i(:,t1ind(2))]),ste([t1v(:,t1ind(2)) t1n(:,t1ind(2)) t1i(:,t1ind(2))],0,1),'b')
    hold on
    errorbar(1:3,mean([t2v(:,t2ind(2)) t2n(:,t2ind(2)) t2i(:,t2ind(2))]),ste([t2v(:,t2ind(2)) t2n(:,t2ind(2)) t2i(:,t2ind(2))],0,1),'r')
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',xax)
    legend('T1','T2')
    title('Validity x Target, Latency')
    
    %accuracy x target
    t1c = [gbsall.medians.t1vc ; gbsall.medians.t1nc ; gbsall.medians.t1ic];
    t1f = [gbsall.medians.t1vf ; gbsall.medians.t1nf ; gbsall.medians.t1if];
    t2c = [gbsall.medians.t2vc ; gbsall.medians.t2nc ; gbsall.medians.t2ic];
    t2f = [gbsall.medians.t2vf ; gbsall.medians.t2nf ; gbsall.medians.t2if];
    xax = {'C','F'};
    
    %amp
    figure(3)
    errorbar(1:2,mean([t1c(:,t1ind(1)) t1f(:,t1ind(1))]),ste([t1c(:,t1ind(1)) t1f(:,t1ind(1))],0,1),'b')
    hold on
    errorbar(1:2,mean([t2c(:,t2ind(1)) t2f(:,t2ind(1))]),ste([t2c(:,t2ind(1)) t2f(:,t2ind(1))],0,1),'r')
    set(gca,'XTick',1:2)
    set(gca,'XTickLabel',xax)
    legend('T1','T2')
    title('Accuracy x Target, Amplitude')
    
    %lat
    figure(4)
    errorbar(1:2,mean([t1c(:,t1ind(2)) t1f(:,t1ind(2))]),ste([t1c(:,t1ind(2)) t1f(:,t1ind(2))],0,1),'b')
    hold on
    errorbar(1:2,mean([t2c(:,t2ind(2)) t2f(:,t2ind(2))]),ste([t2c(:,t2ind(2)) t2f(:,t2ind(2))],0,1),'r')
    set(gca,'XTick',1:2)
    set(gca,'XTickLabel',xax)
    legend('T1','T2')
    title('Accuracy x Target, Latency')
    
    %validity x accuracy
    vcB = [gbsall.medians.t1vc(:,t1ind(1)) ; gbsall.medians.t2vc(:,t2ind(1))];
    ncB = [gbsall.medians.t1nc(:,t1ind(1)) ; gbsall.medians.t2nc(:,t2ind(1))];
    icB = [gbsall.medians.t1ic(:,t1ind(1)) ; gbsall.medians.t2ic(:,t2ind(1))];
    vfB = [gbsall.medians.t1vf(:,t1ind(1)) ; gbsall.medians.t2vf(:,t2ind(1))];
    nfB = [gbsall.medians.t1nf(:,t1ind(1)) ; gbsall.medians.t2nf(:,t2ind(1))];
    ifB = [gbsall.medians.t1if(:,t1ind(1)) ; gbsall.medians.t2if(:,t2ind(1))];
    vcL = [gbsall.medians.t1vc(:,t1ind(2)) ; gbsall.medians.t2vc(:,t2ind(2))];
    ncL = [gbsall.medians.t1nc(:,t1ind(2)) ; gbsall.medians.t2nc(:,t2ind(2))];
    icL = [gbsall.medians.t1ic(:,t1ind(2)) ; gbsall.medians.t2ic(:,t2ind(2))];
    vfL = [gbsall.medians.t1vf(:,t1ind(2)) ; gbsall.medians.t2vf(:,t2ind(2))];
    nfL = [gbsall.medians.t1nf(:,t1ind(2)) ; gbsall.medians.t2nf(:,t2ind(2))];
    ifL = [gbsall.medians.t1if(:,t1ind(2)) ; gbsall.medians.t2if(:,t2ind(2))];
    xax = {'V','N','I'};
    
    %amp
    figure(5)
    errorbar(1:3,mean([vcB ncB icB]),ste([vcB ncB icB],0,1),'b')
    hold on
    errorbar(1:3,mean([vfB nfB ifB]),ste([vfB nfB ifB],0,1),'r')
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',xax)
    legend('C','F')
    title('Validity x Accuracy, Amplitude')
    
    %lat
    figure(6)
    errorbar(1:3,mean([vcL ncL icL]),ste([vcL ncL icL],0,1),'b')
    hold on
    errorbar(1:3,mean([vfL nfL ifL]),ste([vfL nfL ifL],0,1),'r')
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',xax)
    legend('C','F')
    title('Validity x Accuracy, Latency')
    
    %validity
    vB = [gbsall.medians.t1vc(:,t1ind(1)) ; gbsall.medians.t1vf(:,t1ind(1)) ; gbsall.medians.t2vc(:,t2ind(1)) ; gbsall.medians.t2vf(:,t2ind(1))];
    nB = [gbsall.medians.t1nc(:,t1ind(1)) ; gbsall.medians.t1nf(:,t1ind(1)) ; gbsall.medians.t2nc(:,t2ind(1)) ; gbsall.medians.t2nf(:,t2ind(1))];
    iB = [gbsall.medians.t1ic(:,t1ind(1)) ; gbsall.medians.t1if(:,t1ind(1)) ; gbsall.medians.t2ic(:,t2ind(1)) ; gbsall.medians.t2if(:,t2ind(1))];
    vL = [gbsall.medians.t1vc(:,t1ind(2)) ; gbsall.medians.t1vf(:,t1ind(2)) ; gbsall.medians.t2vc(:,t2ind(2)) ; gbsall.medians.t2vf(:,t2ind(2))];
    nL = [gbsall.medians.t1nc(:,t1ind(2)) ; gbsall.medians.t1nf(:,t1ind(2)) ; gbsall.medians.t2nc(:,t2ind(2)) ; gbsall.medians.t2nf(:,t2ind(2))];
    iL = [gbsall.medians.t1ic(:,t1ind(2)) ; gbsall.medians.t1if(:,t1ind(2)) ; gbsall.medians.t2ic(:,t2ind(2)) ; gbsall.medians.t2if(:,t2ind(2))];
    xax = {'V','N','I'};
    
    %amp
    figure(7)
    errorbar(1:3,mean([vB nB iB]),ste([vB nB iB],0,1),'b')
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',xax)
    title('Validity, Amplitude')
    
    %lat
    figure(8)
    errorbar(1:3,mean([vL nL iL]),ste([vL nL iL],0,1),'b')
    set(gca,'XTick',1:3)
    set(gca,'XTickLabel',xax)
    title('Validity, Latency')
    
    %accuracy
    cB = [gbsall.medians.t1vc(:,t1ind(1)) ; gbsall.medians.t1nc(:,t1ind(1)) ; gbsall.medians.t1ic(:,t1ind(1)) ; gbsall.medians.t2vc(:,t2ind(1)) ; gbsall.medians.t2nc(:,t2ind(1)) ; gbsall.medians.t2ic(:,t2ind(1))];
    fB = [gbsall.medians.t1vf(:,t1ind(1)) ; gbsall.medians.t1nf(:,t1ind(1)) ; gbsall.medians.t1if(:,t1ind(1)) ; gbsall.medians.t2vf(:,t2ind(1)) ; gbsall.medians.t2nf(:,t2ind(1)) ; gbsall.medians.t2if(:,t2ind(1))];
    cL = [gbsall.medians.t1vc(:,t1ind(2)) ; gbsall.medians.t1nc(:,t1ind(2)) ; gbsall.medians.t1ic(:,t1ind(2)) ; gbsall.medians.t2vc(:,t2ind(2)) ; gbsall.medians.t2nc(:,t2ind(2)) ; gbsall.medians.t2ic(:,t2ind(2))];
    fL = [gbsall.medians.t1vf(:,t1ind(2)) ; gbsall.medians.t1nf(:,t1ind(2)) ; gbsall.medians.t1if(:,t1ind(2)) ; gbsall.medians.t2vf(:,t2ind(2)) ; gbsall.medians.t2nf(:,t2ind(2)) ; gbsall.medians.t2if(:,t2ind(2))];
    xax = {'C','F'};
    
    %amp
    figure(9)
    errorbar(1:2,mean([cB fB]),ste([cB fB],0,1),'b')
    set(gca,'XTick',1:2)
    set(gca,'XTickLabel',xax)
    title('Accuracy, Amplitude')
    
    %amp
    figure(10)
    errorbar(1:2,mean([cL fL]),ste([cL fL],0,1),'b')
    set(gca,'XTick',1:2)
    set(gca,'XTickLabel',xax)
    title('Accuracy, Latency')
    
    %target
    t1 = [gbsall.medians.t1vc ; gbsall.medians.t1nc ; gbsall.medians.t1ic ; gbsall.medians.t1vf ; gbsall.medians.t1nf ; gbsall.medians.t1if];
    t2 = [gbsall.medians.t2vc ; gbsall.medians.t2nc ; gbsall.medians.t2ic ; gbsall.medians.t2vf ; gbsall.medians.t2nf ; gbsall.medians.t2if];
    xax = {'T1','T2'};
    
    %amp
    figure(11)
    errorbar(1:2,mean([t1(:,t1ind(1)) t2(:,t2ind(1))]),ste([t1(:,t1ind(1)) t2(:,t2ind(1))],0,1),'b')
    set(gca,'XTick',1:2)
    set(gca,'XTickLabel',xax)
    title('Target, Amplitude')
    
    %amp
    figure(12)
    errorbar(1:2,mean([t1(:,t1ind(2)) t2(:,t2ind(2))]),ste([t1(:,t1ind(2)) t2(:,t2ind(2))],0,1),'b')
    set(gca,'XTick',1:2)
    set(gca,'XTickLabel',xax)
    title('Target, Latency')
    
    fig = 1:12;
    fignames = {'ValidityTargetB','ValidityTargetL','AccuracyTargetB','AccuracyTargetL','ValidityAccuracyB','ValidityAccuracyL','ValidityB','ValidityL','AccuracyB','AccuracyL','TargetB','TargetL'};
    figprefix = '';
    filedir = [datadir type '_noL/plots'];
    
    rd_saveAllFigs(fig,fignames,figprefix, filedir)
    
    close all
    
elseif strcmp(type,'ta')
    
    t1ind = [2 7];
    t2ind = [3 8];
    
    %attention
    aB = [gbsall.medians.t1a(:,t1ind(1)) ; gbsall.medians.t2a(:,t2ind(1))];
    aL = [gbsall.medians.t1a(:,t1ind(2)) ; gbsall.medians.t2a(:,t2ind(2))];
    nB = [gbsall.medians.t1n(:,t1ind(1)) ; gbsall.medians.t2n(:,t2ind(1))];
    nL = [gbsall.medians.t1n(:,t1ind(2)) ; gbsall.medians.t2n(:,t2ind(2))];
    uB = [gbsall.medians.t1u(:,t1ind(1)) ; gbsall.medians.t2u(:,t2ind(1))];
    uL = [gbsall.medians.t1u(:,t1ind(2)) ; gbsall.medians.t2u(:,t2ind(2))];
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
    t1B = [gbsall.medians.t1a(:,t1ind(1)) ; gbsall.medians.t1n(:,t1ind(1)) ; gbsall.medians.t1u(:,t1ind(1))];
    t2B = [gbsall.medians.t2a(:,t2ind(1)) ; gbsall.medians.t2n(:,t2ind(1)) ; gbsall.medians.t2u(:,t2ind(1))];
    t1L = [gbsall.medians.t1a(:,t1ind(2)) ; gbsall.medians.t1n(:,t1ind(2)) ; gbsall.medians.t1u(:,t1ind(2))];
    t2L = [gbsall.medians.t2a(:,t2ind(2)) ; gbsall.medians.t2n(:,t2ind(2)) ; gbsall.medians.t2u(:,t2ind(2))];
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
    figprefix = '';
    filedir = [datadir type '_noL/plots'];
    
    rd_saveAllFigs(fig,fignames,figprefix, filedir)
    
    close all
    
end
    
    
    
    


        