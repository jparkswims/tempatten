function pa_model_compare(pa,m1,m2)

close all
figdir = ['/Users/jakeparker/Google Drive/TA_Pupil/Figures/1Tvs2T/' pa.type '/'];
% t1500 = nan(length(pa.fields),length(pa.subjects));
% bestmodel = nan(length(pa.fields),length(pa.subjects));

for ff = 1:length(pa.fields)
    
    savedir = [figdir pa.fields{ff}];
    
    for ss = 1:length(pa.subjects)
        
        figure
        subplot(2,1,1)
        title(['Subject ' pa.subjects{ss} ', Condition ' pa.fields{ff} ', M' num2str(m1) ' vs M' num2str(m2)])
        pa_regressor_plot(pa,ff,m1,ss)
        subplot(2,1,2)
        pa_regressor_plot(pa,ff,m2,ss)
        
%         if pa.(pa.fields{ff}).models(1).locations(ss,2) <= 550
%             t1500(ff,ss) = 1;
%             rd_saveAllFigs(1,pa.subjects(ss),['M' num2str(m1) 'vsM' num2str(m2) '_' pa.fields{ff} '_'],[figdir 'ALL_t1_500'])
%         else
%             t1500(ff,ss) = 0;
%         end
%         
%         if pa.(pa.fields{ff}).bic(ss,1,m1) < pa.(pa.fields{ff}).bic(ss,1,m2)
%             bestmodel(ff,ss) = m1;
%         else
%             bestmodel(ff,ss) = m2;
%             rd_saveAllFigs(1,pa.subjects(ss),['M' num2str(m1) 'vsM' num2str(m2) '_' pa.fields{ff} '_'],[figdir 'ALL_1T_better'])
%         end
%         
%         if abs(pa.(pa.fields{ff}).models(1).locations(ss,2)-pa.(pa.fields{ff}).models(1).locations(ss,3)) <= 50
%             rd_saveAllFigs(1,pa.subjects(ss),['M' num2str(m1) 'vsM' num2str(m2) '_' pa.fields{ff} '_'],[figdir 'ALL_t1L_eq_t2L'])
%         end
        
%         clf
        
    end
    
    fig = 1:ss;
    fignames = pa.subjects;
    figprefix = ['M' num2str(m1) 'vsM' num2str(m2) '_' pa.fields{ff} '_'];
    
    rd_saveAllFigs(fig,fignames,figprefix, savedir)
    
    close all
    
end

% csvwrite([figdir 't1500.csv'],t1500,1,1)
% csvwrite([figdir 'bestmodel.csv'],bestmodel,1,1)
    
    
    