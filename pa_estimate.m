function optim = pa_estimate(data,samplerate,trialwindow,model)
% pa_estimate
% optim = pa_estimate(data,samplerate,trialwindow,model)
% optim = pa_estimate(data,samplerate,trialwindow,model,options)

%OPTIONS
%return output optimization parameters from each starting point?
%pa_generate_params
%pa_optim
%pa_cost
searchnum = 2000;
optimnum = 40;
parammode = 'uniform';

sfact = samplerate/1000;
time = trialwindow(1):1/sfact:trialwindow(2);

%check inputs
%simple check of input model structure
pa_model_check(model)

%samplerate, trialwindow vs data
if length(time) ~= length(data)
    error('The number of time points does not equal the number of data points')
end

%sample rate vs model sample rate
if samplerate ~= model.samplerate
    error('The input sample rate and the sample rate in model do not match')
end

%model time window vs time points
if ~(any(model.window(1) == time)) || ~(any(model.window(2) == time ))
    error('Model time window does not fall on time points according to sample rate and trial window')
end

%generate starting parameters for coarse search in parameter space
params = pa_generate_params(searchnum,parammode,model);

%ADD PARAM PRESORTING/MORE EVEN SAMPLING?
%OPTIMAL PARAMETER SPACE SAMPLING (KEEP IN MIND)

%structure to store temporary param values
modelstate = model;
modelstate.search = struct('ampvals',params.ampvals,'latvals',params.latvals,'tmaxval',params.tmaxvals,'yintval',params.yintvals,'boxampvals',params.boxampvals);

%crop data to match model.window
datalb = find(model.window(1) == time);
dataub = find(model.window(2) == time);
data = data(datalb:dataub);

%evaluate cost function with parameter sets spread out across the parameter
%space to determine which points to perform (time consuming and 
%computationally intensive) constrained optimization on
fprintf('\nDetermining best %d out of %d starting points for optimization algorithm\n',optimnum,searchnum)
modelstate = search_param_space(data,searchnum,optimnum,modelstate);
fprintf('Best %d starting points found\n',optimnum)

%perform constrained optimization on the best points from the coarse
%parameter space search
fprintf('\nBeginning optimization of best starting points\nOptims completed: ')
searchoptims = struct('eventimes',model.eventtimes,'boxtimes',model.boxtimes,'ampvals',[],'boxampvals',[],'latvals',[],'tmaxval',[],'yintval',[],'cost',[],'R2',[]);
tempcosts = [];
for op = 1:optimnum
    modelstate.ampvals = modelstate.search.ampvals(modelstate.search.optimindex(op),:);
    modelstate.boxampvals = modelstate.search.boxampvals(modelstate.search.optimindex(op),:);
    modelstate.latvals = modelstate.search.latvals(modelstate.search.optimindex(op),:);
    modelstate.tmaxval = modelstate.search.tmaxval(modelstate.search.optimindex(op),:);
    modelstate.yintval = modelstate.search.yintval(modelstate.search.optimindex(op),:);
    
    searchoptims(op) = pa_optim(data,model.samplerate,model.window,modelstate);
    tempcosts = [tempcosts searchoptims(op).cost];
    fprintf('%d ',op)
end

fprintf('\nOptimizations completed!\n')
[~,minind] = min(tempcosts);
optim = searchoptims(minind);

    function modelstate = search_param_space(data,searchnum,optimnum,modelstate)
        
        costs = nan(searchnum,1);
        for ss = 1:searchnum
            modelstate.ampvals = modelstate.search.ampvals(ss,:);
            modelstate.latvals = modelstate.search.latvals(ss,:);
            modelstate.tmaxval = modelstate.search.tmaxval(ss);
            modelstate.yintval = modelstate.search.yintval(ss);
            modelstate.boxampvals = modelstate.search.boxampvals(ss,:);
            costs(ss) = pa_cost(data,modelstate.samplerate,modelstate.window,modelstate);
        end
        
        [~,sortind] = sort(costs);
        [~,rank] = sort(sortind);
        optimindex = find(rank <= optimnum);
        
        modelstate.search.optimindex = optimindex;
        modelstate.search.costs = costs;
        
    end

end
