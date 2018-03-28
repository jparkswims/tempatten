function pa_make_optim_plots(pa,m)

close all
imdatadir = ['/Users/jakeparker/Google Drive/TA_Pupil/Figures/optimplots/' pa.type '/t1L_eq_t2L/'];

for ff = 1:length(pa.fields)
    
    for ss = 1:length(pa.subjects)
        
        if abs(pa.(pa.fields{ff}).models(1).locations(ss,2)-pa.(pa.fields{ff}).models(1).locations(ss,3)) <= 50
            [~, ~, ~, optimplot] = quick_glm_grid(pa.(pa.fields{ff}).smeans(ss,:),pa,ss,2,m);
            save([imdatadir pa.subjects{ss} '_' pa.fields{ff} '_M' num2str(m) '.mat'],'optimplot')
        end
        
    end
    
end