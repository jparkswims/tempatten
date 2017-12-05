function pa = pa_beta_analysis(pa,modelnum,Btype)

set(0,'DefaultFigureColormap',jet)

close all

im = modelnum;

s = length(pa.subjects);
f = length(pa.fields);

% mtag = [dec_type(1) tmax_type(6) B_type(1) loc_type(1)];
% 
% for j = 1:length(pa.models)
%     
%     if any(strcmp(modelparams,'beta')) && ...
%             strcmp(pa.models(j).tmax,tmax_type) && ...
%             strcmp(pa.models(j).beta,B_type) && ...
%             strcmp(pa.models(j).loc,loc_type)
%         
%         im = j;
%         
%     end
%     
% end

% type = inputname(1);
% type = type(4:end);
% 
% pa.type = type;

t = pa.targets;

if t == 2
    
    if strcmp(pa.type,'ta')
        
        factors = {'t1' 't2' []; 'a' 'n' 'u'};
        numf = [2 3];
        
    elseif strcmp(pa.type,'tvc')
        
        factors = {'t1' 't2' [];'v' 'n' 'i';'c' 'f' []};
        numf = [2 3 2];
        
    end
    
elseif t == 3
    
    if strcmp(pa.type,'ta')
        
        factors = {'t1' 't2' 't3'; 'a' 'n' 'u'};
        numf = [3 3];
        
    elseif strcmp(pa.type,'tvc')
        
        factors = {'t1' 't2' 't3';'v' 'n' 'i';'c' 'f' []};
        numf = [3 3 2];
        
    end
    
end

x = size(factors,1);

pa.current_model = im;

pa.bdf = nan(s*f,x+2);
pa.ldf = nan(s*f,x+2);

ff = fullfact([s numf]);

pa.bdf(:,1:end-1) = ff;
pa.ldf(:,1:end-1) = ff;

conditions = reshape(pa.fields,t,length(pa.fields)/t)';
conditions = reshape(conditions,3,length(pa.fields)/3);

for j = 1:length(pa.bdf)
    
    subject = pa.bdf(j,1);
    
    if strcmp(Btype,'target')
        type = ['t' num2str(pa.bdf(j,2))];
    else
        type = Btype;
    end
    
    locind = find(strcmp(pa.models(im).Blabels,type));
    
    field = [];
    
    for k = 1:x
        
        field = [field factors{k,pa.bdf(j,k+1)}];
        
    end
    
%     pa.bdf(j,end) = pa.(field).betas(subject,target+1,im);
    pa.bdf(j,end) = pa.(field).models(im).(type)(subject);
    try
        pa.ldf(j,end) = pa.(field).models(im).locations(subject,locind);
    catch
        pa.ldf(j,end) = 0;
    end
    
end

if strcmp(pa.type,'tvc')
    c = 2;
else
    c = 1;
end

figure(length(pa.subjects)+1)

sbpl = ceil(sqrt(length(pa.subjects)));

for j = 1:size(conditions,2)
    
    if strcmp(Btype,'target')
        type = conditions{1,j}(1:2);
        locind = find(strcmp(pa.models(im).Blabels,type));
    end
    
%     pa.(conditions{1,j}).gbetameans = mean(pa.(conditions{1,j}).betas,1);
%     pa.(conditions{2,j}).gbetameans = mean(pa.(conditions{2,j}).betas,1);
%     pa.(conditions{3,j}).gbetameans = mean(pa.(conditions{3,j}).betas,1);
%     
%     pa.(conditions{1,j}).betase = ste(pa.(conditions{1,j}).betas,0,1);
%     pa.(conditions{2,j}).betase = ste(pa.(conditions{2,j}).betas,0,1);
%     pa.(conditions{3,j}).betase = ste(pa.(conditions{3,j}).betas,0,1);
    
    if strcmp(pa.type,'ta')
        gtitle = conditions{1,j}(1:end-1);
        gtitle = [gtitle 'anu'];
    elseif strcmp(pa.type,'tvc')
        gtitle = conditions{1,j};
        gtitle(3) = [];
        gtitle = [gtitle 'vni'];
    end
    
    for k = 1:length(pa.subjects)
        
        figure(k)
        hold on
        
        subplot(c,size(conditions,2)/c,j)
        bar([1 2],[pa.(conditions{1,j}).models(im).(type)(k)...
            pa.(conditions{2,j}).models(im).(type)(k)...
            pa.(conditions{3,j}).models(im).(type)(k); 0 0 0])
        xlim([0.5 1.5])
        title(gtitle)
        set(gca,'XTickLabel',{[conditions{1,j} '     ' conditions{2,j} '     ' conditions{3,j}] '0'})
        
        figure(length(pa.subjects)+1)
        subplot(sbpl,sbpl,k)
        title([pa.subjects{k} gtitle])
        bar([1 2],[pa.(conditions{1,j}).models(im).(type)(k)...
            pa.(conditions{2,j}).models(im).(type)(k)...
            pa.(conditions{3,j}).models(im).(type)(k); 0 0 0])
        xlim([0.5 1.5])
        title(pa.subjects{k})
        set(gca,'XTickLabel',{[conditions{1,j} '     ' conditions{2,j} '     ' conditions{3,j}] '0'})
        
        figure(length(pa.subjects)+2)
        hold on
        subplot(c,size(conditions,2)/c,j)
        scatter([1 2 3],[pa.(conditions{1,j}).models(im).(type)(k) ...
            pa.(conditions{2,j}).models(im).(type)(k) ...
            pa.(conditions{3,j}).models(im).(type)(k)])
        xlim([0 4])
        title(gtitle)
        set(gca,'XTick',[1 2 3])
        set(gca,'XTickLabel',{conditions{1,j} conditions{2,j} conditions{3,j}})
        
        figure(length(pa.subjects)+3)
        hold on
        try
            subplot(c,size(conditions,2)/c,j)
            scatter([1 2 3],[pa.(conditions{1,j}).models(im).locations(k,locind) ...
            pa.(conditions{2,j}).models(im).locations(k,locind) ...
            pa.(conditions{3,j}).models(im).locations(k,locind)])
            xlim([0 4])
            title(gtitle)
            set(gca,'XTick',[1 2 3])
            set(gca,'XTickLabel',{conditions{1,j} conditions{2,j} conditions{3,j}})
        catch
            
        end
        %construct figure with all subjects on one
        
    end
    
    fig = k+1;
    fignames = {[gtitle '_all_subjects_m' num2str(im)]};
    figprefix = ['m' num2str(im) '_' Btype];
    filedir = [pa.filedir '/models/' Btype];
    
    rd_saveAllFigs(fig,fignames,figprefix, filedir)
    
    figure(k+2)
    subplot(c,size(conditions,2)/c,j)
    scatter([1 2 3],[mean(pa.(conditions{1,j}).models(im).(type))...
        mean(pa.(conditions{2,j}).models(im).(type))...
        mean(pa.(conditions{3,j}).models(im).(type))],100,'+k')
    xlim([0 4])
    title(gtitle)
    set(gca,'XTick',[1 2 3])
    set(gca,'XTickLabel',{conditions{1,j} conditions{2,j} conditions{3,j}})
    
    figure(k+3)
    hold on
    try
        scatter([1 2 3],[mean(pa.(conditions{1,j}).models(im).locations(:,locind))...
            mean(pa.(conditions{2,j}).models(im).locations(:,locind))...
            mean(pa.(conditions{3,j}).models(im).locations(:,locind))],100,'+k')
        xlim([0 4])
        title(gtitle)
        set(gca,'XTick',[1 2 3])
        set(gca,'XTickLabel',{conditions{1,j} conditions{2,j} conditions{3,j}})
    catch
        
    end
    
    figure(k+4)
    hold on
    
    subplot(c,size(conditions,2)/c,j)
    barwitherr([ste(pa.(conditions{1,j}).models(im).(type),0,1) ...
        ste(pa.(conditions{2,j}).models(im).(type),0,1) ...
        ste(pa.(conditions{3,j}).models(im).(type),0,1); 0 0 0], ...
        [1 2],[mean(pa.(conditions{1,j}).models(im).(type)) ...
        mean(pa.(conditions{2,j}).models(im).(type)) ...
        mean(pa.(conditions{3,j}).models(im).(type)); 0 0 0])
    xlim([0.5 1.5])
    title(gtitle)
    set(gca,'XTickLabel',{[conditions{1,j} '     ' conditions{2,j} '     ' conditions{3,j}] '0'})
    
    figure(k+5)
    hold on
    try
        subplot(c,size(conditions,2)/c,j)
        barwitherr([ste(pa.(conditions{1,j}).models(im).locations(:,locind),0,1) ...
            ste(pa.(conditions{2,j}).models(im).locations(:,locind),0,1) ...
            ste(pa.(conditions{3,j}).models(im).locations(:,locind),0,1); 0 0 0], ...
            [1 2],[mean(pa.(conditions{1,j}).models(im).locations(:,locind)) ...
            mean(pa.(conditions{2,j}).models(im).locations(:,locind)) ...
            mean(pa.(conditions{3,j}).models(im).locations(:,locind)); 0 0 0])
        xlim([0.5 1.5])
        title(gtitle)
        set(gca,'XTickLabel',{[conditions{1,j} '     ' conditions{2,j} '     ' conditions{3,j}] '0'})
    catch
    
    end
  
end

for j = 1:length(pa.subjects)
    
    fig = j;
    fignames = {[pa.subjects{j} '_beta_weights_m' num2str(im)]};
    figprefix = ['m' num2str(im) '_' Btype];
    filedir = [pa.filedir '/' pa.subjects{j}];
    
    rd_saveAllFigs(fig,fignames,figprefix, filedir)
    
end

fig = [j+2 j+3 j+4 j+5];
fignames = {'group_beta_scatter' 'group_location_scatter' 'group_mean_beta_weights' 'group_mean_locations'};
figprefix = ['m' num2str(im) '_' Btype];
filedir = [pa.filedir '/models/' Btype '/start40'];

rd_saveAllFigs(fig,fignames,figprefix, filedir)

close all

% tmax = nan(s,f);
% yint = nan(s,f);
% 
% for j = 1:f
%     
%     tmax(:,j) = pa.(pa.fields{j}).models(im).tmax;
%     yint(:,j) = pa.(pa.fields{j}).models(im).yint;
%     
% end
% 
% for j = 1:s
%     
%     figure(1)
%     title('tmax vs subject scatter')
%     scatter(ones(f,1)*j,tmax(j,:))
%     hold on
%     scatter(j,mean(tmax(j,:)),'fill')
%     xlim([0 s+1])
%     
%     figure(2)
%     title('yint vs subject scatter')
%     scatter(ones(f,1)*j,yint(j,:))
%     hold on
%     scatter(j,mean(yint(j,:)),'fill')
%     xlim([0 s+1])
% 
% end
% 
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
% 
% fig = [1 2 3 4];
% fignames = {'subject_tmax' 'subject_yint' 'all_betas' 'all_locs'};
% figprefix = ['m' num2str(im)];
% 
% rd_saveAllFigs(fig,fignames,figprefix, pa.filedir)

