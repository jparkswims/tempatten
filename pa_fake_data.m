function [data, outparams] = pa_fake_data(numtseries,parammode,samplerate,trialwindow,model,options)
% pa_fake_data
% data = pa_fake_data(numtseries,parammode,samplerate,trialwindow,model)
% data = pa_fake_data(numtseries,parammode,samplerate,trialwindow,model,options)
% 
% Generates fake pupil size time series using randomly generated parameters for
% a given model.
% 
%   Inputs:
%   
%       numtseries = number of time series to generate
%           *IMPORTANT - if 'uniform' used, this number must be divisible
%           by options.pa_generate_params.nbins such that the resulting number 
%           is a whole number!
% 
%       parammode ('uniform', 'normal', or 'space_optimal') = mode used to
%       generate parameters in the function pa_generate_params.
%           'uniform' - parameters are sampled in a roughly uniform manner
%           from the range of their respective bounds. For each parameter,
%           a uniform distribution is created using rand, then points are
%           sampled from 50 bins along this distribution spanning its
%           entire range. To change the number of bins, see 
%           options.pa_generate_params.nbins.
%           'normal' - parameters are drawn from a normal distrubtion
%           centered around the values provided in the input model
%           structure. The standard deviation is set by options.sigma.
%           'space_optimal' - finds the "num" number of points that
%           optimally cover the parameter space as defined by the
%           parameter bounds. Uses fmincon, so parameters need to be scaled
%           using options.ampfact, options.latfact, options.tmaxfact, and
%           options.yintfact.
% 
%       samplerate = sampling rate of data in Hz. Can be different than the
%       value in the model.samplerate if desired.
% 
%       trialwindow = a 2 element vector containing the starting and ending
%       times (in ms) of the trial epoch. Can be different than
%       model.window if desired.
% 
%       model = model structure created by pa_model and filled in by user.
%           *IMPORTANT - parameter values in model.ampvals,
%           model.boxampvals, model.latvals, model.tmaxval, and
%           model.yintval must be provided if 'normal' parammode is used!
% 
%       options = options structure for pa_fake_data. Default options 
%       can be returned by calling this function with no arguments, or see
%       pa_default_options.
% 
%   Outputs:
% 
%       data = a 2D matrix where each row is a generated pupil size time
%       series.
% 
%      outparams = an output structure containing all sets of parameters
%      generated to create fake data. Contains the following fields:
%           ampvals = 2D matrix of generated event amplitude parameters.
%           Each row is one set of parameters.
%           boxampvals = 2D matrix of generated box amplitude parameters.
%           latvals = 2D matrix of generated event latency parameters.
%           tmaxvals = column vector of generated tmax parameters.
%           yintvals = column vector of generated y-intercept parameters.
%           
% 
%   Options
% 
%       pa_generate_params = options structure for pa_generate_params,
%       which pa_fake_data uses to generate parameter values that the
%       artificial time series are constructed from. Options for the
%       various "parammode" options are in here.
%
%   Jacob Parker 2018

if nargin < 6
    opts = pa_default_options();
    options = opts.pa_fake_data;
    clear opts
    if nargin < 1
        data = options;
        return
    end
end

%OPTIONS
pa_generate_params_options = options.pa_generate_params;

%check inputs
pa_model_check(model)

sfact = samplerate/1000;
time = trialwindow(1):1/sfact:trialwindow(2);

%model time window vs time points
if ~(any(trialwindow(1) == time)) || ~(any(trialwindow(2) == time ))
error('Given trial window does not fall on time points according to sample rate and trial window')
end

data = nan(numtseries,length(time));
modelstate = model;
modelstate.window = trialwindow;
modelstate.samplerate = samplerate;


%generate parameters to create time series with
params = pa_generate_params(numtseries,parammode,model,pa_generate_params_options);

%generate time series from parameters
for ts = 1:numtseries
    modelstate.ampvals = params.ampvals(ts,:);
    modelstate.boxampvals = params.boxampvals(ts,:);
    modelstate.latvals = params.latvals(ts,:);
    modelstate.tmaxval = params.tmaxvals(ts);
    modelstate.yintval = params.yintvals(ts);
    data(ts,:) = pa_calc(modelstate);
end

outparams = struct('eventimes',model.eventtimes,'boxtimes',model.boxtimes,'ampvals',params.ampvals,'boxampvals',params.boxampvals,'latvals',params.latvals,'tmaxvals',params.tmaxvals,'yintvals',params.yintvals);

