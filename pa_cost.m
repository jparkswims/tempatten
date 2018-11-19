function cost = pa_cost(data,samplerate,trialwindow,model,options)
% pa_cost
% cost = pa_cost(data,samplerate,trialwindow,model)
% cost = pa_cost(data,samplerate,trialwindow,model,options)
% 
% Calculates the sum of the square errors between some input pupil size
% time series "data" and a time series created from the specifications and
% parameters in "model".
% 
%   Inputs:
%   
%       data = a single pupil size time series as a row vector.
% 
%       samplerate = sampling rate of data in Hz.
% 
%       trialwindow = a 2 element vector containing the starting and ending
%       times (in ms) of the trial epoch.
% 
%       model = model structure created by pa_model and filled in by user.
%       Parameter values in model.ampvals, model.boxampvals, model.latvals,
%       model.tmaxval, and model.yintval must be provided.
%           *Note - an optim structure from pa_estimate, pa_bootstrap, or
%           pa_optim can be input in the place of model*
% 
%       options = options structure for pa_cost. Default options can be
%       returned by calling this function with no arguments.
% 
%   Outputs:
% 
%       cost = sum of the square errors between "data" and time series
%       created using "model"
% 
%   Options
%
%       pa_calc_options = options structure for pa_calc, which pa_cost uses
%       to produce the time series from "model".
%
%   Jacob Parker 2018

if nargin < 5
    opts = pa_default_options();
    options = opts.pa_cost;
    clear opts
    if nargin < 1
        cost = options;
        return
    end
end

%OPTIONS
pa_calc_options = options.pa_calc;

sfact = samplerate/1000;
time = trialwindow(1):1/sfact:trialwindow(2);

%check inputs
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

%crop data to match model.window
datalb = find(model.window(1) == time);
dataub = find(model.window(2) == time);
data = data(datalb:dataub);

Ycalc = pa_calc(model,pa_calc_options);
cost = sum((data-Ycalc).^2);