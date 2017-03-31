function pa_model_figs(pa,modelnum)

im = modelnum;

s = length(pa.subjects);
f = length(pa.fields);
b = length(pa.models(im).Blabels);

tmax = nan(s,f);
yint = nan(s,f);

for j = 1:f
    
    tmax(:,j) = pa.(pa.fields{j}).models(im).tmax;
    yint(:,j) = pa.(pa.fields{j}).models(im).yint;
    
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

for j = 1:f
    
    betas = reshape(pa.(pa.fields{j}).models(im).betas,s*b,1);
    
    figure(3)
    title('B weight vs Condition')
    scatter(ones(s*b,1)*j,betas)
    hold on
    scatter(j,mean(betas),'fill')
    xlim([0 f+1])
    xlabel('field')
    ylabel('beta')
    
    figure(4)
    title('tmax vs Condition')
    scatter(ones(s,1)*j,tmax(:,j))
    hold on
    scatter(j,mean(tmax(:,j)),'fill')
    xlabel('field')
    ylabel('tmax')
    
    B(1,j) = mean(betas);
    
end

figure(5)
title(['Avg Beta vs Avg tmax (r=' num2str(corr2(mean(tmax),B)) ')'])
hold on
scatter(mean(tmax),B)
xlabel('avg tmax (field) (ms)')
ylabel('avg beta (field)')

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

fig = [1 2 3 4];
fignames = {'subject_tmax' 'subject_yint' 'condition_beta' 'condition_tmax'};
figprefix = ['m' num2str(im)];

rd_saveAllFigs(fig,fignames,figprefix, pa.filedir)