function pa_model_fitTS(pa,modelnum)

close all

colors = {...
    [0 0.2 1] [0 0 0.6];...
    [0 1 0] [0 0.5 0];...
    [1 0 0] [0.5 0 0];...
    };

conditions = reshape(pa.fields,pa.targets,length(pa.fields)/pa.targets)';
conditions = reshape(conditions,3,length(pa.fields)/3);
conditions = reshape(conditions,3,size(conditions,2)/pa.targets,pa.targets);

for s = 1:length(pa.subjects)

    for i = 1:size(conditions,3)
        
        for j = 1:size(conditions,1)
            
            for k = 1:size(conditions,2)
                
                
                Y = glm_calc(pa.window,...
                    pa.(conditions{j,k,i}).models(modelnum).betas(s,:),...
                    [num2cell(pa.(conditions{j,k,i}).models(modelnum).locations(s,:)) [0 round(pa.dectime(s))]],...
                    pa.models(modelnum).Btypes,...
                    pa.(conditions{j,k,i}).models(modelnum).tmax(s),...
                    pa.(conditions{j,k,i}).models(modelnum).yint(s),...
                    pa.models(modelnum).normalization);
                    
                
                figure(s)
                subplot(1,size(conditions,3),i)
                hold on
                plot(pa.window(1):pa.window(2),pa.(conditions{j,k,i}).smeans(s,:),'color',colors{j,k})
                plot(0:pa.window(2),Y,'color',[0.5 0.5 0.5],'LineStyle',':')
                xlabel('Time (ms')
                ylabel('Pupil Area (normalized)')
                title([pa.subjects{s} ' T' num2str(i)])
                xlim(pa.window)
                
            end
        end
    end
end

fig = 1:s;
figdir = [pa.filedir '/models'];
fignames = fields(pa.(conditions{j,k,i}));
fignames = fignames(1:s);
figprefix = ['m' num2str(modelnum)];

rd_saveAllFigs(fig,fignames,figprefix, figdir)




