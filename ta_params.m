function pa = ta_params(study,type)
%study = E0, E3, or E5
%type = cue, ta, or tvc

    function thestruct = structinit(conditions,fact,subjects,window,locs,filedir,trials,runs,study)
        
        f = fullfact(fact);
        
        fields = cell(prod(f(end,:)),1);
        
        for i = 1:size(f,2)
            
            for j = 1:size(f,1)
                
                fields{j} = [fields{j} conditions{i,f(j,i)}];
                
            end
            
        end
        
        for i = 1:length(fields);
            
            for j = 1:length(subjects)
                thestruct.(fields{i}).(subjects{j}) = [];
            end
            
        end
        
        thestruct.fields = fields;
        thestruct.subjects = subjects;
        thestruct.window = window;
        thestruct.duration = window(2) - window(1) + 1;
        thestruct.locs = locs;
        thestruct.filedir = filedir;
        thestruct.runs = runs;
        thestruct.trials = trials;
        thestruct.trialmat = nan(trials,thestruct.duration,length(subjects));
        thestruct.study = study;
            
    end

if strcmp(study,'E0')
    subjects = {'ma' 'ad' 'bl' 'ec' 'ty' 'zw' 'hl' 'rd' 'jp'};
    window = [-400 3000];
    locs = [0 1000 1250 1750];
    filedir = ['/Users/jakeparker/Documents/tempatten/E0_cb/' type];
    trials = 640;
    t = 2;
    runs = [2 2 2 2 2 2 4 4 4];
elseif strcmp(study,'E3')
    subjects = {'bl' 'ca' 'ec' 'en' 'ew' 'id' 'jl' 'jx' 'ld' 'ml' 'rd' 'sj'};
    window = [-400 3000];
    locs = [0 1000 1250 1750];
    filedir = ['/Users/jakeparker/Documents/tempatten/E3_adjust/' type];
    trials = 640;
    t = 2;
    runs = [4 4 4 4 4 4 4 4 4 4 4 4];
elseif strcmp(study,'E5')
    subjects = {'ds' 'gb' 'gb2' 'ht' 'ik' 'jg' 'jp' 'rd' 'xw' 'yz'};
    window = [-400 3500];
    locs = [0 1000 1250 1500 2000];
    filedir = ['/Users/jakeparker/Documents/tempatten/E5/' type];
    trials = 960;
    t = 3;
    runs = [3 3 3 3 3 3 3 3 3 3];
else
    error('Not a valid study')
end

if t == 2
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

pa = structinit(conditions,fact,subjects,window,locs,filedir,trials,runs,study);

end
                
                