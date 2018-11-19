function [optim, searchoptims] = pa_estimate(data,samplerate,trialwindow,model,options)
% pa_estimate
% optim = pa_estimate(data,samplerate,trialwindow,model)
% optim = pa_estimate(data,samplerate,trialwindow,model,options)
% 
% Optimization algorithm for estimating the model parameters that result in
% the best fit with the data. First, the cost function is evaluated for a
% large number (default 2000) of points sampled from across 
% parameter space. Then, the subset (default 40) that evaluate to the lowest value
% of the cost function are used as starting points for fmincon. The output
% set of parameters that result in the lowest cost is taken as the best
% estimate.
% 
%   Inputs:
%   
%       data = a single pupil size time series as a row vector.
% 
%       samplerate = sampling rate of data in Hz.
% 
%       trialwindow = a 2 element vector containing the starting and ending
%       times (in ms) of the trial epoch. Will NOT be the window the model
%       is estimated on (that is in model.window).
% 
%       model = model structure created by pa_model and filled in by user.
%       Parameter values in model.ampvals, model.boxampvals, model.latvals,
%       model.tmaxval, and model.yintval do not need to be provided (unless
%       any of those parameters are not being estimated).
% 
%       options = options structure for pa_estimate. Default options can be
%       returned by calling this function with no arguments, or see
%       pa_default_options.
% 
%   Outputs:
% 
%       optim = a structure containing the parameters estimated by fmincon
%       with the following fileds:
%           eventtimes = a copy of eventtimes from "model".
%           boxtimes = a copy of boxtimes from "model".
%           samplerate = a copy of samplerate from "model".
%           window a copy of window from "model".
%           ampvals = the estimated event amplitude values.
%           boxampvals = the estimated box regressor amplitude values.
%           latvals = the estimated event latency values.
%           tmaxval = the estimated tmax value.
%           yintval = the estimated y-intercept value.
%           cost = the sum of square errors between the optimized
%           parameters and the actual data.
%           R2 = the R^2 goodness of fit value.
%       *Note - can be input into pa_plot_model, pa_calc, or pa_cost in the 
%       place of the "model" input*
% 
%       searchoptims = an optional output structure containing the
%       parameters estimated by fmincon for all optimization runs.
%       It has the same fields as optim, but has a length equal to
%       options.optimnum.
% 
%   Options
%
%       options.searchnum (2000) = the number of points sampled from parameter
%       space where the cost function is evaluated.
% 
%       options.optimnum (40) = the number of optimizations to be run, using the
%       optimnum number of parameter points with the lowest costs.
% 
%       options.parammode ('uniform') = the mode used to generate the
%       parameters for the search of parameter space. See
%       pa_generate_params for more information.
% 
%       pa_generate_params_options = options structure for pa_generate_params, 
%       which pa_estimate uses to generate the parameters for the search of
%       parameter space.
% 
%       pa_optim_options = options structure for pa_optim, 
%       which pa_estimate uses to perform each individual optimization.
% 
%       pa_cost_options = options structure for pa_cost, which pa_estimate 
%       uses to evaluate the cost function at each point sampled from
%       parameter space.
%
%   Jacob Parker 2018

if nargin < 5
    opts = pa_default_options();
    options = opts.pa_estimate;
    clear opts
    if nargin < 1
        optim = options;
        return
    end
end

%OPTIONS
%return output optimization parameters from each starting point?
pa_generate_params_options = options.pa_generate_params;
pa_optim_options = options.pa_optim;
pa_cost_options = options.pa_cost;
searchnum = options.searchnum;
optimnum = options.optimnum;
parammode = options.parammode;

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
params = pa_generate_params(searchnum,parammode,model,pa_generate_params_options);

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
searchoptims = struct('eventimes',model.eventtimes,'boxtimes',model.boxtimes,'samplerate',model.samplerate,'window',model.window,'ampvals',[],'boxampvals',[],'latvals',[],'tmaxval',[],'yintval',[],'cost',[],'R2',[]);
tempcosts = [];
for op = 1:optimnum
    modelstate.ampvals = modelstate.search.ampvals(modelstate.search.optimindex(op),:);
    modelstate.boxampvals = modelstate.search.boxampvals(modelstate.search.optimindex(op),:);
    modelstate.latvals = modelstate.search.latvals(modelstate.search.optimindex(op),:);
    modelstate.tmaxval = modelstate.search.tmaxval(modelstate.search.optimindex(op),:);
    modelstate.yintval = modelstate.search.yintval(modelstate.search.optimindex(op),:);
    
    searchoptims(op) = pa_optim(data,model.samplerate,model.window,modelstate,pa_optim_options);
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
            costs(ss) = pa_cost(data,modelstate.samplerate,modelstate.window,modelstate,pa_cost_options);
        end
        
        [~,sortind] = sort(costs);
        [~,rank] = sort(sortind);
        optimindex = find(rank <= optimnum);
        
        modelstate.search.optimindex = optimindex;
        modelstate.search.costs = costs;
        
    end

end
