function sj = pa_bootstrap_sj(sj,model,nboots,wnum,options)
% pa_bootstrap_sj
% sj = pa_bootstrap_sj(sj,model,nboots,wnum)
% sj = pa_bootstrap_sj(sj,model,nboots,wnum,options)
% 
% Performs the bootstrapping procedure for estimating model parameters on
% each set of data that has been preprocessed/organized into a sj structure
% by pa_preprocess.
% 
%   Inputs:
%
%       sj = structure output by pa_preprocess containing data in a format
%       that pa_estimate_sj uses.
% 
%       model = model structure created by pa_model and filled in by user.
%       Parameter values in model.ampvals, model.boxampvals, model.latvals,
%       model.tmaxval, and model.yintval do NOT need to be provided (unless
%       any of those parameters are not being estimated).
%           *NOTE - if you want to fit multiple models, you can input an
%           Nx1 structure with the same fields as "model", where N is the
%           number of models and each element is a separate model
%           structure*
% 
%       options = options structure for pa_bootstrap_sj. Default options can be
%       returned by calling this function with no arguments, or see
%       pa_default_options.
%
%   Output
%
%       sj = same structure that was input, but with the additional field
%       appended:
%           boots = a Nx1 structure, where N is the number of models input
%           in "model". Each element of this structure is an boots
%           structure for a single model. See pa_bootstrap for more
%           information about this structure.
%
%   Options
%
%       pa_bootstrap_options = options structure for pa_bootstrap, 
%       which pa_bootstrap_sj uses to perform parameter estimation for each
%       set of data in sj.
%
%   Jacob Parker 2018

if nargin < 5
    opts = pa_default_options();
    options = opts.pa_bootstrap_sj;
    clear opts
    if nargin < 1
        sj = options;
        return
    end
end

%OPTIONS
pa_bootstrap_options = options.pa_bootstrap;

%check model
for mm = 1:length(model)
    try
        pa_model_check(model(mm))
    catch
        error('\nError in model %d\n',mm)
    end
end

sj.boots = [];

for mm = 1:length(model)
    for cc = 1:length(sj.conditions)
        sj.boots(mm).(sj.conditions{cc}) = pa_bootstrap(sj.(sj.conditions{cc}),sj.samplerate,sj.trialwindow,model(mm),nboots,wnum,pa_bootstrap_options);
    end
end