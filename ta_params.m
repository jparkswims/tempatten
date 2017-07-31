function pa = ta_params(study,type)
%study = E0, E3, E5, or E0E5
%type = cue, ta, or tvc

    function thestruct = structinit(conditions,fact,subjects,window,locs,filedir,trials,runs,study,baseline,t,type,loclabels)
        
        f = fullfact(fact);
        
        fields = cell(prod(f(end,:)),1);
        
        for i = 1:size(f,2)
            
            for j = 1:size(f,1)
                
                fields{j} = [fields{j} conditions{i,f(j,i)}];
                
            end
            
        end
        
        for i = 1:length(fields);
            
            for j = 1:length(subjects)
                if strcmp(study,'E0E3')
                    if j <= 9
                        thestruct.(fields{i}).([subjects{j} 'E0']) = [];
                        thestruct.(fields{i}).dectime.([subjects{j} 'E0']) = [];
                    else
                        thestruct.(fields{i}).([subjects{j} 'E3']) = [];
                        thestruct.(fields{i}).dectime.([subjects{j} 'E3']) = [];
                    end
                else
                    thestruct.(fields{i}).(subjects{j}) = [];
                    thestruct.(fields{i}).dectime.(subjects{j}) = [];
                end
            end
            
        end
        
        thestruct.fields = fields;
        thestruct.subjects = subjects;
        thestruct.window = window;
        thestruct.duration = window(2) - window(1) + 1;
        thestruct.locs = locs;
        thestruct.loclabels = loclabels;
        thestruct.filedir = filedir;
        thestruct.runs = runs;
        thestruct.trials = trials;
        thestruct.trialmat = nan(trials,thestruct.duration,length(subjects));
        thestruct.study = study;
        thestruct.type = type;
        thestruct.baseline = baseline;
        thestruct.dectime = zeros(length(subjects),1);
        thestruct.targets = t;
            
    end

if strcmp(study,'E0')
    subjects = {'ma' 'ad' 'bl' 'ec' 'ty' 'zw' 'hl' 'rd' 'jp'};
    window = [-500 3500];
    locs = [0 1000 1250 1750];
    filedir = ['/Users/jakeparker/Documents/tempatten/E0/' type];
    trials = 640;
    t = 2;
    runs = [2 2 2 2 2 2 4 4 4];
    baseline = 200;
elseif strcmp(study,'E3')
    subjects = {'bl' 'ca' 'ec' 'en' 'ew' 'id' 'jl' 'jx' 'ld' 'ml' 'rd' 'sj'};
    window = [-500 3500];
    locs = [0 1000 1250 1750];
    filedir = ['/Users/jakeparker/Documents/tempatten/E3/' type];
    trials = 640;
    t = 2;
    runs = [4 4 4 4 4 4 4 4 4 4 4 4];
    baseline = 200;
elseif strcmp(study,'E5')
    subjects = {'ds' 'gb' 'gb2' 'ht' 'ik' 'jg' 'jp' 'rd' 'xw' 'yz'};
    window = [-500 4000];
    locs = [0 1000 1250 1500 2000];
    filedir = ['/Users/jakeparker/Documents/tempatten/E5/' type];
    trials = 960;
    t = 3;
    runs = [1 1 1 1 1 1 1 1 1 1];
    baseline = 200;
elseif strcmp(study,'E0E3')
    subjects = {'ma' 'ad' 'bl' 'ec' 'ty' 'zw' 'hl' 'rd' 'jp' 'bl' 'ca' 'ec' 'en' 'ew' 'id' 'jl' 'jx' 'ld' 'ml' 'rd' 'sj'};
    window = [-500 3500];
    locs = [0 1000 1250 1750];
    filedir = ['/Users/jakeparker/Documents/tempatten/E0E3/' type];
    trials = 640;
    t = 2;
    runs = [2 2 2 2 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4];
    baseline = 200;
else
    error('Not a valid study')
end

if t == 2
    loclabels = {'precue' 't1' 't2' 'postcue'};
    if strcmp(type,'cue')
        conditions = {'t1' 't2' 'n'};
        fact = 3;
    elseif strcmp(type,'ta')
        conditions = {'t1' 't2' []; 'a' 'n' 'u'};
        fact = [2 3];
    elseif strcmp(type,'tvc')
        conditions = {'t1' 't2' [];'v' 'n' 'i';'c' 'f' []};
        fact = [2 3 2];
    else
        error('Not a valid type')
    end
elseif t == 3
    loclabels = {'precue' 't1' 't2' 't3' 'postcue'};
    if strcmp(type,'cue')
        conditions = {'t1' 't2' 't3' 'n'};
        fact = 4;
    elseif strcmp(type,'ta')
        conditions = {'t1' 't2' 't3'; 'a' 'n' 'u'};
        fact = [3 3];
    elseif strcmp(type,'tvc')
        conditions = {'t1' 't2' 't3';'v' 'n' 'i';'c' 'f' []};
        fact = [3 3 2];
    else
        error('Not a valid type')
    end
end

pa = structinit(conditions,fact,subjects,window,locs,filedir,trials,runs,study,baseline,t,type,loclabels);

end
                
                