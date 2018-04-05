function pa_make_optim_plots(pa,m)

close all
% imdatadir = ['/Users/jakeparker/Google Drive/TA_Pupil/Figures/optimplots/' pa.type '/t1L_500/'];

t1_500 = [];
t1_not500 = [];
% figure(m)
% xlim([pa.window(1) pa.window(2)])
% hold on

for ff = 1:length(pa.fields)
    
    for ss = 1:length(pa.subjects)
        
%         figure(ss)
%         title(pa.subjects{ss})
%         xlim([pa.window(1) pa.window(2)])
%         ylim([-0.2 1.1])
%         hold on
        
        if pa.(pa.fields{ff}).models(1).locations(ss,2) < 510
            t1_500 = [t1_500 ; pa.(pa.fields{ff}).smeans(ss,:)./(max(pa.(pa.fields{ff}).smeans(ss,:)))];
%             plot(pa.window(1):pa.window(2),pa.(pa.fields{ff}).smeans(ss,:)./(max(pa.(pa.fields{ff}).smeans(ss,:))),'color',[0.8 0.5 0.5])
        else
            t1_not500 = [t1_not500 ; pa.(pa.fields{ff}).smeans(ss,:)./(max(pa.(pa.fields{ff}).smeans(ss,:)))];
%             plot(pa.window(1):pa.window(2),pa.(pa.fields{ff}).smeans(ss,:)./(max(pa.(pa.fields{ff}).smeans(ss,:))),'color',[0.5 0.5 0.8])
%             [~, ~, ~, optimplot] = quick_glm_grid(pa.(pa.fields{ff}).smeans(ss,:),pa,ss,2,m);
%             save([imdatadir pa.subjects{ss} '_' pa.fields{ff} '_M' num2str(m) '.mat'],'optimplot')
        end
        
    end
    
end

mean_all = nanmean([t1_500 ; t1_not500],1);
figure(m)
xlim([pa.window(1) pa.window(2)])
hold on

for ff = 1:length(pa.fields)
    
    for ss = 1:length(pa.subjects)
        
        if pa.(pa.fields{ff}).models(1).locations(ss,2) < 510
%             t1_500 = [t1_500 ; pa.(pa.fields{ff}).smeans(ss,:)./(max(pa.(pa.fields{ff}).smeans(ss,:)))];
            plot(pa.window(1):pa.window(2),(pa.(pa.fields{ff}).smeans(ss,:)./(max(pa.(pa.fields{ff}).smeans(ss,:))))-mean_all,'color',[0.8 0.5 0.5])
        else
%             t1_not500 = [t1_not500 ; pa.(pa.fields{ff}).smeans(ss,:)./(max(pa.(pa.fields{ff}).smeans(ss,:)))];
            plot(pa.window(1):pa.window(2),(pa.(pa.fields{ff}).smeans(ss,:)./(max(pa.(pa.fields{ff}).smeans(ss,:))))-mean_all,'color',[0.5 0.5 0.8])
%             [~, ~, ~, optimplot] = quick_glm_grid(pa.(pa.fields{ff}).smeans(ss,:),pa,ss,2,m);
%             save([imdatadir pa.subjects{ss} '_' pa.fields{ff} '_M' num2str(m) '.mat'],'optimplot')
        end
        
    end
end

% rd_saveAllFigs(1:ss,pa.subjects,pa.type,'/Users/jakeparker/Google Drive/TA_Pupil/Figures/t1L_500')

figure(m)
plot(pa.window(1):pa.window(2),nanmean(t1_500,1)-mean_all,'r','LineWidth',2)
plot(pa.window(1):pa.window(2),nanmean(t1_not500,1)-mean_all,'b','LineWidth',2)
ylim([-0.2 1.1])

rd_saveAllFigs(m,{[pa.type '_t1_500_VS_t1_not500']},'','/Users/jakeparker/Google Drive/TA_Pupil/Figures/t1L_500_det')