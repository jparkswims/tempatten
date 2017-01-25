function pa = pa_best_model(pa)

close all

filedir = pa.filedir;

modelstruct

tm0 = 930;
b0 = ones(1,length(pa.locs)+1);

%%%%%%%%%
% if strcmp(pa.study,'E3')
%     subs = [1:3 5:12];
% else
%     subs = [1:length(pa.subjects)];
% end
%%%%%%%%%

subs = [1:length(pa.subjects)];

%%%%%%%%%

pa.models = models;
pa.globalbic = zeros(length(pa.models),1);

for f = 1:length(pa.fields)
    
    pa.(pa.fields{f}).betas = nan(length(pa.subjects),length(pa.locs)+1,length(pa.models));
    pa.(pa.fields{f}).tmax = nan(length(pa.subjects),1,length(pa.models));
    pa.(pa.fields{f}).bic = nan(length(pa.subjects),1,length(pa.models));
    
    for s = subs
        
        for m = 1:length(pa.models)
            
            [pa.(pa.fields{f}).tmax(s,1,m), pa.(pa.fields{f}).betas(s,1:end,m), cost, X] ...
                = glm_optim(pa.(pa.fields{f}).smeans(s,:),pa.window,pa.locs,round(pa.dectime(s)*1000),pa.models(m).dec,pa.models(m).tmax,pa.models(m).beta,tm0,b0);
            
            if strcmp(pa.models(m).tmax,'tmax_param')
                k = length(pa.locs)+2;
            else
                k = length(pa.locs)+1;
            end
            
            pa.(pa.fields{f}).bic(s,1,m) = bic(length(X),cost,k);
            
        end
        
    end
    
    pa.(pa.fields{f}).totalbic = squeeze(nanmean(pa.(pa.fields{f}).bic,1));
    pa.(pa.fields{f}).bestmodel = find(pa.(pa.fields{f}).totalbic == min(pa.(pa.fields{f}).totalbic));
    
    pa.globalbic = pa.globalbic + pa.(pa.fields{f}).totalbic;
    
    figure
    bar([1:length(pa.subjects)],squeeze(pa.(pa.fields{f}).bic))
    xlabel('subject')
    ylabel('BIC')
    set(gca,'XTickLabel',pa.subjects)
    title('BIC vs model and subject')
    xlim([0 length(pa.subjects)+1])
    
    figure
    bar([1:length(pa.models)],squeeze(nanmean(pa.(pa.fields{f}).betas,1))')
    xlabel('model')
    ylabel('average beta value')
    set(gca,'XTickLabel',{'m1' 'm2' 'm3' 'm4' 'm5' 'm6' 'm7' 'm8' 'm9' 'm10' 'm11' 'm12'})
    title('Average Beta Values vs Model')
    xlim([0 length(pa.models)+1])
    
    figure
    bar(pa.(pa.fields{f}).totalbic)
    xlabel('model')
    ylabel('total BIC')
    set(gca,'XTickLabel',{'m1' 'm2' 'm3' 'm4' 'm5' 'm6' 'm7' 'm8' 'm9' 'm10' 'm11' 'm12'})
    title('total BIC vs model')
    
    figdir = [filedir '/models/' pa.fields{f}];
    fig = [1 2 3];
    fignames = {'model_BICs' 'avg_betas' 'total_BICs'};
    figprefix = 'ta';
    
    rd_saveAllFigs(fig,fignames,figprefix, figdir)
    
    close all
    
end

pa.bestmodel = find(pa.globalbic == min(pa.globalbic));

figure
bar(pa.globalbic)
xlabel('model')
ylabel('global BIC')         
set(gca,'XTickLabel',{'m1' 'm2' 'm3' 'm4' 'm5' 'm6' 'm7' 'm8' 'm9' 'm10' 'm11' 'm12'})
title('global BIC vs model')

figdir = [filedir '/models'];
fig = 1;
fignames = {'global_BICs'};

rd_saveAllFigs(fig,fignames,figprefix, figdir)

close all




