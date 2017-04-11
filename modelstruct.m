function pa = modelstruct(pa)

pa.models = [];
beta = {'beta'};
loc = {'locations'};
yint = {'yint'};
tmax = {'tmax'};
betabound = {'positive'};
bbounds = {repmat([0 100],5,1) repmat([-100 100],5,1)};
dec = {'box'};
locbound = {'250' '500'};
blocboundval = [250 500];
normalization = {'max' 'area'};
% bloclb = (pa.locs-blocboundval)';
% blocub = (pa.locs+blocboundval)';

ff = fullfact([length(beta) length(loc) length(yint) length(tmax) length(betabound) length(dec) length(locbound) length(normalization)]);

for i = size(ff,1):-1:1 %go backwards to preallocate entire structure
    
    pa.models(i).params = {beta{ff(i,1)} loc{ff(i,2)} yint{ff(i,3)} tmax{ff(i,4)} betabound{ff(i,5)} dec{ff(i,6)} locbound{ff(i,7)} normalization{ff(i,8)}};
    pa.models(i).B = ones(1,length(pa.locs)+1);
    pa.models(i).Blocs = num2cell(pa.locs);
    pa.models(i).Bbounds = bbounds{ff(i,5)};
    pa.models(i).Btypes = [repmat({'stick'},1,length(pa.locs)) dec{ff(i,6)}];
    pa.models(i).Blocbounds = [(pa.locs-blocboundval(ff(i,7)))' (pa.locs+blocboundval(ff(i,7)))'];
    pa.models(i).Blabels = [pa.loclabels 'decision'];
    pa.models(i).yint = 0;
    pa.models(i).tmax = 930;
    pa.models(i).tmaxbounds = [0 2000];
    pa.models(i).normalization = normalization{ff(i,8)};
    
end

for i = 1:length(pa.fields)
    
    pa.(pa.fields{i}).models = [];
    
    for j = 1:length(pa.models)
        
        pa.(pa.fields{i}).models(j).betas = nan(length(pa.subjects),length(pa.locs)+1);
        pa.(pa.fields{i}).models(j).locations = nan(length(pa.subjects),length(pa.locs));
        pa.(pa.fields{i}).models(j).yint = nan(length(pa.subjects),1);
        pa.(pa.fields{i}).models(j).tmax = nan(length(pa.subjects),1);
        
        for k = 1:length(pa.models(j).Blabels)
            
            pa.(pa.fields{i}).models(j).(pa.models(j).Blabels{k}) = nan(length(pa.subjects),1);
        
        end
        
    end
    
end
        
        
        
        
        
        
