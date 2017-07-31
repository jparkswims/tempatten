function pa = pa_best_model(pa)

close all

filedir = pa.filedir;

file = fopen(['GLMreport_' pa.study pa.type '.txt'],'w');

% modelstruct

% tm0 = 930;
% b0 = ones(1,length(pa.locs)+1);

% type = inputname(1);
% type = type(4:end);
% 
% pa.type = type;

%%%%%%%%%
% if strcmp(pa.study,'E3')
%     subs = [1:3 5:12];
% else
%     subs = [1:length(pa.subjects)];
% end
%%%%%%%%%

subs = 1:length(pa.subjects);

%%%%%%%%%

pa = modelstruct(pa);
fileformat = repmat('%s ',1,length(pa.models(1).params));
pa.globalbic = zeros(length(pa.models),1);
costs = zeros(subs(end),length(pa.models),length(pa.fields));
ks = zeros(subs(end),length(pa.models),length(pa.fields));

for f = 1:length(pa.fields)
    
%     pa.(pa.fields{f}).betas = nan(length(pa.subjects),length(pa.models(1).B),length(pa.models));
%     pa.(pa.fields{f}).tmax = nan(length(pa.subjects),1,length(pa.models));
     pa.(pa.fields{f}).bic = nan(length(pa.subjects),1,length(pa.models));
    
%     for ii = length(models):-1:1
%         
%         pa.(pa.fields{f}).models(ii).precue = nan(1,length(pa.subjects));
%         pa.(pa.fields{f}).models(ii).t1 = nan(1,length(pa.subjects));
%         pa.(pa.fields{f}).models(ii).t2 = nan(1,length(pa.subjects));
%         if strcmp(pa.study,'E5')
%             pa.(pa.fields{f}).models(ii).t3 = nan(1,length(pa.subjects));
%         end
%         pa.(pa.fields{f}).models(ii).postcue = nan(1,length(pa.subjects));
%         pa.(pa.fields{f}).models(ii).decision = nan(1,length(pa.subjects));
%         pa.(pa.fields{f}).models(ii).tmax = nan(1,length(pa.subjects));
%         
%     end
    
%     modelfields = pa.(pa.fields{f}).models;
    
    for s = subs
        
        fprintf('%s\n',pa.subjects{s})
        
        for m = 1:length(pa.models)
            
            fprintf('model %d\n',m)
            for fi = 1:length(pa.models(m).params)
                fprintf('%s ',pa.models(m).params{fi})
            end
            
            Y = pa.(pa.fields{f}).smeans(s,:);
            
            [B, Blocs, tmax, yint, costs(s,m,f) , Ycalc, Blabels, ks(s,m,f)] = ...
                glm_optim2(Y,...
                pa.window,...
                pa.models(m).B,...
                [pa.models(m).Blocs [0 round(pa.dectime(s))]],...
                pa.models(m).Blocbounds,...
                pa.models(m).Btypes,...
                pa.models(m).Blabels,...
                pa.models(m).Bbounds,...
                pa.models(m).tmax,...
                pa.models(m).tmaxbounds,...
                pa.models(m).yint,...
                pa.models(m).params,...
                pa.models(m).normalization);
            
            pa.(pa.fields{f}).models(m).betas(s,:) = B;
            pa.(pa.fields{f}).models(m).locations(s,:) = cell2mat(Blocs(~strcmp(Blabels,'decision')));
            pa.(pa.fields{f}).models(m).yint(s,:) = yint;
            pa.(pa.fields{f}).models(m).tmax(s,:) = tmax;
            
            for bl = 1:length(Blabels)
                pa.(pa.fields{f}).models(m).(Blabels{bl})(s) = B(bl);
            end
            
%             [pa.(pa.fields{f}).tmax(s,1,m), pa.(pa.fields{f}).betas(s,1:end,m), costs(s,m,f), Ycalc] ...
%                 = glm_optim(Y,pa.window,pa.locs,round(pa.dectime(s)*1000),pa.models(m).dec,pa.models(m).tmax,pa.models(m).beta,tm0,b0,pa.models(m).loc);
            
%             for jj = 1:length(modelfields)-1
%                 
%                 pa.(pa.fields{f}).models(m).(modelfields{jj})(1,s) = pa.(pa.fields{f}).betas(s,jj,m);
%                 
%             end
            
%             pa.(pa.fields{f}).models(m).tmax(1,s) = pa.(pa.fields{f}).tmax(s,1,m);
            
%             if strcmp(pa.models(m).tmax,'tmax_param')
%                 ks(s,m,f) = length(pa.locs)+2;
%             else
%                 ks(s,m,f) = length(pa.locs)+1;
%             end

%             pa.(pa.fields{f}).betas(s,1:end,m) = B;
            pa.(pa.fields{f}).bic(s,1,m) = bic(length(Ycalc),costs(s,m,f),ks(s,m,f));
            
            if strcmp(pa.type,'cue')
                
                Y(1:-pa.window(1)+1) = [];
                
%                 figure(1)
%                 plot(Y,'b')
%                 hold on
%                 plot(Ycalc,'r')
%                 title('Measured vs Predicted')
%                 xlabel('time (ms)')
%                 ylabel('pupil area (normalized)')
%                 hold off
%                 
%                 figdir = [filedir '/models/' pa.fields{f}];
%                 fig = 1;
%                 fignames = {['meas_vs_pred_' pa.subjects{s} '_m' num2str(m)]};
%                 figprefix = 'ta';
%                 
%                 rd_saveAllFigs(fig,fignames,figprefix, figdir)
                
%                 close all
                
            end
                
        end
        
    end
    
    pa.(pa.fields{f}).totalbic = squeeze(nanmean(pa.(pa.fields{f}).bic,1));
    pa.(pa.fields{f}).bestmodel = find(pa.(pa.fields{f}).totalbic == min(pa.(pa.fields{f}).totalbic));
    
    %pa.globalbic = pa.globalbic + pa.(pa.fields{f}).totalbic;
    
%     figure(1)
%     hold off
%     bar([1:length(pa.subjects)],squeeze(pa.(pa.fields{f}).bic))
%     xlabel('subject')
%     ylabel('BIC')
%     set(gca,'XTickLabel',pa.subjects)
%     title('BIC vs model and subject')
%     xlim([0 length(pa.subjects)+1])
    
%     figure(2)
%     hold off
%     bar([1:length(pa.models)],squeeze(nanmean(pa.(pa.fields{f}).betas,1))')
%     xlabel('model')
%     ylabel('average beta value')
%     set(gca,'XTickLabel',{'m1' 'm2' 'm3' 'm4' 'm5' 'm6' 'm7' 'm8' 'm9' 'm10' 'm11' 'm12' 'm13' 'm14' 'm15' 'm16'})
%     title('Average Beta Values vs Model')
%     xlim([0 length(pa.models)+1])
    
%     figure(3)
%     hold off
%     bar(pa.(pa.fields{f}).totalbic)
%     xlabel('model')
%     ylabel('total BIC')
%     set(gca,'XTickLabel',{'m1' 'm2' 'm3' 'm4' 'm5' 'm6' 'm7' 'm8' 'm9' 'm10' 'm11' 'm12' 'm13' 'm14' 'm15' 'm16'})
%     title('total BIC vs model')
    
%     figdir = [filedir '/models/' pa.fields{f}];
%     fig = [1 2 3];
%     fignames = {'model_BICs' 'avg_betas' 'total_BICs'};
%     figprefix = 'ta';
%     
%     rd_saveAllFigs(fig,fignames,figprefix, figdir)
    
%     close all
    
end

fclose(file);

pa.combbic = zeros(length(pa.models),length(pa.subjects));

for s = subs
    
    for m = 1:length(pa.models)
        
        pa.combbic(m,s) = bic(length(Ycalc)*length(pa.fields),sum(costs(s,m,:),3),sum(ks(s,m,:),3));
        
    end
    
end

pa.globalbic = sum(pa.combbic,2);

pa.bestmodel = find(pa.globalbic == min(pa.globalbic));

% figure(1)
% hold off
% bar(pa.globalbic)
% xlabel('model')
% ylabel('global BIC')         
% set(gca,'XTickLabel',{'m1' 'm2' 'm3' 'm4' 'm5' 'm6' 'm7' 'm8' 'm9' 'm10' 'm11' 'm12'})
% title('global BIC vs model')
% 
% figure(2)
% hold off
% bar([1:length(pa.subjects)],pa.combbic')
% xlabel('subject')
% ylabel('BIC')
% set(gca,'XTickLabel',pa.subjects)
% title('BIC vs model and subject')
% xlim([0 length(pa.subjects)+1])
% 
% figdir = [filedir '/models'];
% fig = [1 2];
% fignames = {'global_BICs' 'Combined_BICs'};
% 
% rd_saveAllFigs(fig,fignames,figprefix, figdir)

close all




