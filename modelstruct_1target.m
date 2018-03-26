function pa = modelstruct_1target(pa)

rng(0);
snum = 40;
gnum = 2000;
uB0 = unidist(10.*rand(gnum*10,1),gnum/snum,snum);
uBlocs0 = unidist(1000.*rand(gnum*10,1)-500,gnum/snum,snum);

pa.models(2) = pa.models;
pa.models(2).B = [randsample(uB0,gnum) randsample(uB0,gnum) randsample(uB0,gnum) randsample(uB0,gnum)];
pa.models(2).Blocs = num2cell([(0+randsample(uBlocs0,gnum)) (1125+randsample(uBlocs0,gnum).*1.25) (1750+randsample(uBlocs0,gnum))]);
pa.models(2).Bbounds(end,:) = [];
pa.models(2).Blocbounds(2,2) = pa.models(2).Blocbounds(3,2);
pa.models(2).Blocbounds(3,:) = [];
pa.models(2).Btypes(1) = [];
pa.models(2).Blabels{2} = 'target';
pa.models(2).Blabels(3) = [];

for i = 1:length(pa.fields)
    
    pa.(pa.fields{i}).models(2) = pa.(pa.fields{i}).models;
    pa.(pa.fields{i}).models(2) = [];
    
    pa.(pa.fields{i}).models(2).betas = nan(length(pa.subjects),size(pa.models(2).B,2));
    pa.(pa.fields{i}).models(2).locations = nan(length(pa.subjects),length(pa.locs)-1);
    pa.(pa.fields{i}).models(2).yint = nan(length(pa.subjects),1);
    pa.(pa.fields{i}).models(2).tmax = nan(length(pa.subjects),1);
    
    for k = 1:length(pa.models(2).Blabels)
        
        pa.(pa.fields{i}).models(2).(pa.models(2).Blabels{k}) = nan(length(pa.subjects),1);
        
    end
    
end


