function pa = boxsplit(pa)

m = length(pa.models)+1;
bm = pa.bestmodel;

pa.models(m) = pa.models(bm);

pa.models(m).Blabels = [pa.models(m).Blabels 'decision2'];
pa.models(m).Btypes = [pa.models(m).Btypes 'box'];
pa.models(m).B = [pa.models(m).B 1];
pa.models(m).Bbounds = [pa.models(m).Bbounds ; 0 100];

for f = 1:length(pa.fields)
    
    if isstruct(pa.(pa.fields{f}).dectime)
        dectime = nan(length(pa.subjects),1);
        
        for e = 1:length(pa.subjects)
            if strcmp(pa.study,'E0E3')
                if e <= 9
                    dectime(e) = mean(pa.(pa.fields{f}).dectime.([pa.subjects{e} 'E0']));
                else
                    dectime(e) = mean(pa.(pa.fields{f}).dectime.([pa.subjects{e} 'E3']));
                end
            else
                dectime(e) = mean(pa.(pa.fields{f}).dectime.(pa.subjects{e}));
            end
        end
        
        pa.(pa.fields{f}).dectime = dectime;
    end
    
    %pa.(pa.fields{f}).betas(:,:,m) = nan(length(pa.subjects),length(pa.models(m).B));
    
    pa.(pa.fields{f}).models(m).betas = nan(length(pa.subjects),length(pa.models(m).B));
    pa.(pa.fields{f}).models(m).locations = nan(length(pa.subjects),length(pa.locs));
    pa.(pa.fields{f}).models(m).yint = nan(length(pa.subjects),1);
    pa.(pa.fields{f}).models(m).tmax = nan(length(pa.subjects),1);
    
    for k = 1:length(pa.models(m).Blabels)
        
        pa.(pa.fields{f}).models(m).(pa.models(m).Blabels{k}) = nan(length(pa.subjects),1);
        
    end
    
    for s = 1:length(pa.subjects)
        
        Y = pa.(pa.fields{f}).smeans(s,:);
        
        [B, Blocs, tmax, yint, ~ , ~, Blabels, ~] = ...
            glm_optim2(Y,...
            pa.window,...
            pa.models(m).B,...
            [pa.models(m).Blocs [0 1750] [1750 round(pa.(pa.fields{f}).dectime(s))]],...
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
        pa.(pa.fields{f}).models(m).locations(s,:) = cell2mat(Blocs(cellfun('length',regexp(Blabels,'decision')) ~= 1));
        pa.(pa.fields{f}).models(m).yint(s,:) = yint;
        pa.(pa.fields{f}).models(m).tmax(s,:) = tmax;
        
        for bl = 1:length(Blabels)
            pa.(pa.fields{f}).models(m).(Blabels{bl})(s) = B(bl);
        end
        
        %pa.(pa.fields{f}).betas(s,1:end,m) = B;
        
    end
    
end