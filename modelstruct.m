%models struct

dec = {'ramp' 'box'};
tmax = {'tmax_param' 'tmax_fixed'};
beta = {'positive' 'unbounded'};
loc = {'all' 'targets'};

ff = fullfact([length(dec) length(tmax) length(beta) length(loc)]);

for i = length(ff):-1:1 %go backwards to preallocate entire structure
    
    models(i) = struct('dec',dec{ff(i,1)},'tmax',tmax{ff(i,2)},'beta',beta{ff(i,3)},'loc',loc{ff(i,4)});
    
end

