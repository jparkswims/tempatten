function pa = pa_beta_analysis(pa,dec_type,tmax_type,B_type,loc_type)

close all

im = [];

s = length(pa.subjects);
f = length(pa.fields);

mtag = [dec_type(1) tmax_type(6) B_type(1) loc_type(1)];

for j = 1:length(pa.models)
    
    if strcmp(pa.models(j).dec,dec_type) && ...
            strcmp(pa.models(j).tmax,tmax_type) && ...
            strcmp(pa.models(j).beta,B_type) && ...
            strcmp(pa.models(j).loc,loc_type)
        
        im = j;
        
    end
    
end

% type = inputname(1);
% type = type(4:end);
% 
% pa.type = type;

t = str2double(pa.fields{end}(2));

if t == 2
    
    if strcmp(type,'ta')
        
        factors = {'t1' 't2' []; 'a' 'n' 'u'};
        numf = [2 3];
        
    elseif strcmp(type,'tvc')
        
        factors = {'t1' 't2' [];'v' 'n' 'i';'c' 'f' []};
        numf = [2 3 2];
        
    end
    
elseif t == 3
    
    if strcmp(type,'ta')
        
        factors = {'t1' 't2' 't3'; 'a' 'n' 'u'};
        numf = [3 3];
        
    elseif strcmp(type,'tvc')
        
        factors = {'t1' 't2' 't3';'v' 'n' 'i';'c' 'f' []};
        numf = [3 3 2];
        
    end
    
end

x = size(factors,1);

pa.bdf = nan(s*f,x+2);

ff = fullfact([s numf]);

pa.bdf(:,1:end-1) = ff;

conditions = reshape(pa.fields,t,length(pa.fields)/t)';
conditions = reshape(conditions,3,length(pa.fields)/3);

for j = 1:length(pa.bdf)
    
    subject = pa.bdf(j,1);
    target = pa.bdf(j,2);
    field = [];
    
    for k = 1:x
        
        field = [field factors{k,pa.bdf(j,k+1)}];
        
    end
    
    pa.bdf(j,end) = pa.(field).betas(subject,target+1,im);
    
end

if strcmp(pa.type,'tvc')
    c = 2;
else
    c = 1;
end

figure(length(pa.subjects)+1)

for j = 1:size(conditions,2)
    
    target = str2double(conditions{1,j}(2));
    
    pa.(conditions{1,j}).gbetameans = mean(pa.(conditions{1,j}).betas,1);
    pa.(conditions{2,j}).gbetameans = mean(pa.(conditions{2,j}).betas,1);
    pa.(conditions{3,j}).gbetameans = mean(pa.(conditions{3,j}).betas,1);
    
    pa.(conditions{1,j}).betase = ste(pa.(conditions{1,j}).betas,0,1);
    pa.(conditions{2,j}).betase = ste(pa.(conditions{2,j}).betas,0,1);
    pa.(conditions{3,j}).betase = ste(pa.(conditions{3,j}).betas,0,1);
    
    if strcmp(pa.type,'ta')
        gtitle = conditions{1,j}(1:end-1);
    elseif strcmp(pa.type,'tvc')
        gtitle = conditions{1,j};
        gtitle(3) = [];
    end
    
    for k = 1:length(pa.subjects)
        
        figure(k)
        hold on
        
        subplot(c,size(conditions,2)/c,j)
        bar([1 2],[pa.(conditions{1,j}).betas(k,target+1,im)...
            pa.(conditions{2,j}).betas(k,target+1,im)...
            pa.(conditions{3,j}).betas(k,target+1,im); 0 0 0])
        xlim([0.5 1.5])
        title(gtitle)
        set(gca,'XTickLabel',{[conditions{1,j} '     ' conditions{2,j} '     ' conditions{3,j}] '0'})
        
        figure(length(pa.subjects)+1)
        hold on
        
        subplot(sbpl,sbpl,k)
        title([pa.subjects{k} gtitle])
        bar([1 2],[pa.(conditions{1,j}).betas(k,target+1,im)...
            pa.(conditions{2,j}).betas(k,target+1,im)...
            pa.(conditions{3,j}).betas(k,target+1,im); 0 0 0])
        xlim([0.5 1.5])
        title(gtitle)
        set(gca,'XTickLabel',{[conditions{1,j} '     ' conditions{2,j} '     ' conditions{3,j}] '0'})
        
        %construct figure with all subjects on one
        
    end
    
    fig = k+1;
    fignames = {[gtitle '_all_subjects_' mtag]};
    figprefix = 'ta';
    filedir = [pa.filedir '/' gtitle];
    
    rd_saveAllFigs(fig,fignames,figprefix, filedir)
    
    figure(k+2)
    hold on
    
    subplot(c,size(conditions,2)/c,j)
    barwitherr([pa.(conditions{1,j}).betase(1,target+1,im) ...
        pa.(conditions{2,j}).betase(1,target+1,im) ...
        pa.(conditions{3,j}).betase(1,target+1,im); 0 0 0], ...
        [1 2],[pa.(conditions{1,j}).gbetameans(1,target+1,im) ...
        pa.(conditions{2,j}).gbetameans(1,target+1,im) ...
        pa.(conditions{3,j}).gbetameans(1,target+1,im); 0 0 0])
    xlim([0.5 1.5])
    title(gtitle)
    set(gca,'XTickLabel',{[conditions{1,j} '     ' conditions{2,j} '     ' conditions{3,j}] '0'})
    
end

for j = 1:length(pa.subjects)
    
    fig = j;
    fignames = {[pa.subjects{j} '_beta_weights_' mtag]};
    figprefix = 'ta';
    filedir = [pa.filedir '/' pa.subjects{j}];
    
    rd_saveAllFigs(fig,fignames,figprefix, filedir)
    
end

fig = [j+2];
fignames = {['group_mean_beta_weights' mtag]};
figprefix = 'ta';

rd_saveAllFigs(fig,fignames,figprefix, pa.filedir)



        
        
    


