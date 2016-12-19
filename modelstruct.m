%models struct

dec = {'ramp' 'box' 'line' 'ramp' 'box' 'line' 'ramp' 'box' 'line' 'ramp' 'box' 'line'};
tmax = {'tmax_param' 'tmax_param' 'tmax_param' 'tmax_fixed' 'tmax_fixed' 'tmax_fixed'...
    'tmax_param' 'tmax_param' 'tmax_param' 'tmax_fixed' 'tmax_fixed' 'tmax_fixed'};
beta = {'positive' 'positive' 'positive' 'positive' 'positive' 'positive'...
    'unbounded' 'unbounded' 'unbounded' 'unbounded' 'unbounded' 'unbounded'};

for i = length(dec):-1:1
    
    models(i) = struct('dec',dec{i},'tmax',tmax{i},'beta',beta{i});
    
end

