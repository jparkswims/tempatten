function pa_model_figs(pa,modelnum)

im = modelnum;

s = length(pa.subjects);
f = length(pa.fields);
b = length(pa.models(im).Blabels);

tmax = nan(s,f);
yint = nan(s,f);
loc = nan(s,b-1,f);

for j = 1:f
    
    tmax(:,j) = pa.(pa.fields{j}).models(im).tmax;
    yint(:,j) = pa.(pa.fields{j}).models(im).yint;
    loc(:,:,j) = pa.(pa.fields{j}).models(im).locations;
    
end

for j = 1:s
    
    figure(1)
    title('tmax vs subject scatter')
    scatter(ones(f,1)*j,tmax(j,:))
    hold on
    scatter(j,mean(tmax(j,:)),'fill')
    xlim([0 s+1])
    xlabel('subject')
    ylabel('tmax')
    
    figure(2)
    title('yint vs subject scatter')
    scatter(ones(f,1)*j,yint(j,:))
    hold on
    scatter(j,mean(yint(j,:)),'fill')
    xlim([0 s+1])
    xlabel('subject')
    ylabel('yint')

end

locpre = squeeze(loc(:,1,:));
loct1 = squeeze(loc(:,2,:));
loct2 = squeeze(loc(:,3,:));
locpost = squeeze(loc(:,4,:));

tprecorr = nan(s,2);
tt1corr = nan(s,2);
tt2corr = nan(s,2);
tpostcorr = nan(s,2);

yprecorr = nan(s,2);
yt1corr = nan(s,2);
yt2corr = nan(s,2);
ypostcorr = nan(s,2);

for j = 1:s
    
    tprecorr(j,:) = regress(tmax(j,:)',[locpre(j,:)' ones(f,1)]);
    tt1corr(j,:) = regress(tmax(j,:)',[loct1(j,:)' ones(f,1)]);
    tt2corr(j,:) = regress(tmax(j,:)',[loct2(j,:)' ones(f,1)]);
    tpostcorr(j,:) = regress(tmax(j,:)',[locpost(j,:)' ones(f,1)]);
    
    yprecorr(j,:) = regress(yint(j,:)',[locpre(j,:)' ones(f,1)]);
    yt1corr(j,:) = regress(yint(j,:)',[loct1(j,:)' ones(f,1)]);
    yt2corr(j,:) = regress(yint(j,:)',[loct2(j,:)' ones(f,1)]);
    ypostcorr(j,:) = regress(yint(j,:)',[locpost(j,:)' ones(f,1)]);
    
end
    
figure(3)
title('tmax vs precue latency')
hold on
plot(squeeze(loc(:,1,:)),tmax,'o','LineWidth',1.5)
xlabel('latency')
ylabel('tmax')

figure(4)
title('tmax vs t1 latency')
hold on
plot(squeeze(loc(:,2,:)),tmax,'o','LineWidth',1.5)
xlabel('latency')
ylabel('tmax')

figure(5)
title('tmax vs t2 latency')
hold on
plot(squeeze(loc(:,3,:)),tmax,'o','LineWidth',1.5)
xlabel('latency')
ylabel('tmax')

figure(6)
title('tmax vs postcue latency')
hold on
plot(squeeze(loc(:,4,:)),tmax,'o','LineWidth',1.5)
xlabel('latency')
ylabel('tmax')

figure(7)
title('yint vs precue latency')
hold on
plot(squeeze(loc(:,1,:)),yint,'o','LineWidth',1.5)
xlabel('latency')
ylabel('yint')

figure(8)
title('yint vs t1 latency')
hold on
plot(squeeze(loc(:,2,:)),yint,'o','LineWidth',1.5)
xlabel('latency')
ylabel('yint')

figure(9)
title('yint vs t2 latency')
hold on
plot(squeeze(loc(:,3,:)),yint,'o','LineWidth',1.5)
xlabel('latency')
ylabel('yint')

figure(10)
title('yint vs postcue latency')
hold on
plot(squeeze(loc(:,4,:)),yint,'o','LineWidth',1.5)
xlabel('latency')
ylabel('yint')

colors = distinguishable_colors(21);

for j = 1:s
    
    figure(3)
    hold on
    plot(-500:500,(-500:500).*tprecorr(j,1)+tprecorr(j,2),'Color',colors(j,:))
    
    figure(4)
    hold on
    plot(500:1500,(500:1500).*tt1corr(j,1)+tt1corr(j,2),'Color',colors(j,:))
    
    figure(5)
    hold on
    plot(750:1750,(750:1750).*tt2corr(j,1)+tt2corr(j,2),'Color',colors(j,:))
    
    figure(6)
    hold on
    plot(1250:2250,(1250:2250).*tpostcorr(j,1)+tpostcorr(j,2),'Color',colors(j,:))
    
    figure(7)
    hold on
    plot(-500:500,(-500:500).*yprecorr(j,1)+yprecorr(j,2),'Color',colors(j,:))
    
    figure(8)
    hold on
    plot(500:1500,(500:1500).*yt1corr(j,1)+yt1corr(j,2),'Color',colors(j,:))
    
    figure(9)
    hold on
    plot(750:1750,(750:1750).*yt2corr(j,1)+yt2corr(j,2),'Color',colors(j,:))
    
    figure(10)
    hold on
    plot(1250:2250,(1250:2250).*ypostcorr(j,1)+ypostcorr(j,2),'Color',colors(j,:))
    
end

    
% figure(3)
% hold on
% plot(locpre,tmaxcorr(:,1,1)'*locpre+tmaxcorr(:,1,2))

%disp(tmaxcorr)

% for j = 1:f
%     
%     betas = reshape(pa.(pa.fields{j}).models(im).betas,s*b,1);
%     
%     figure(3)
%     title('B weight vs Condition')
%     scatter(ones(s*b,1)*j,betas)
%     hold on
%     scatter(j,mean(betas),'fill')
%     xlim([0 f+1])
%     xlabel('field')
%     ylabel('beta')
%     
%     figure(4)
%     title('tmax vs Condition')
%     scatter(ones(s,1)*j,tmax(:,j))
%     hold on
%     scatter(j,mean(tmax(:,j)),'fill')
%     xlabel('field')
%     ylabel('tmax')
%     
%     B(1,j) = mean(betas);
%     
% end
% 
% figure(5)
% title(['Avg Beta vs Avg tmax (r=' num2str(corr2(mean(tmax),B)) ')'])
% hold on
% scatter(mean(tmax),B)
% xlabel('avg tmax (field) (ms)')
% ylabel('avg beta (field)')

% sbpl(1) = size(conditions,1);
% sbpl(2) = size(conditions,2);
% sbpl = sort(sbpl);
% 
% for j = 1:f
%     
%     figure(3)
%     
%     subplot(sbpl(1),sbpl(2),j)
%     bar(mean(pa.(pa.fields{j}).models(im).betas,1))
% %     set(gca,'XTickLabel',pa.models(im).Blabels)
%     title(pa.fields{j})
%     ylabel('B value')
%     
%     figure(4)
%     
%     subplot(sbpl(1),sbpl(2),j)
%     bar(mean(pa.(pa.fields{j}).models(im).locations,1))
% %     set(gca,'XTickLabel',pa.loclabels)
%     title(pa.fields{j})
%     ylabel('Time from Precue (ms)')
%     
% end

fig = [1 2 3 4 5 6 7 8 9 10];
fignames = {'subject_tmax' 'subject_yint' 'precuelatency_tmax' 't1latency_tmax' 't2latency_tmax' 'postcuelatency_tmax' 'precuelatency_yint' 't1latency_yint' 't2latency_yint' 'postcuelatency_yint'};
figprefix = ['m' num2str(im)];
filedir = [pa.filedir '/models'];

rd_saveAllFigs(fig,fignames,figprefix, filedir)

close all

