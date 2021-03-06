function sj = pa_estimate_sj(sj,model,options)
% pa_estimate_sj
% sj = pa_estimate_sj(sj,models)
% sj = pa_estimate_sj(sj,models,options)
% 
% Performs the parameter estimation procedure for each set of data that has
% been preprocessed/organized into a sj structure by pa_preprocess.
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
%       options = options structure for pa_estimate_sj. Default options can be
%       returned by calling this function with no arguments, or see
%       pa_default_options.
%
%   Output
%
%       sj = same structure that was input, but with the additional field
%       appended:
%           optim = a structure with fields titled after the condition
%           labels. Each of these fields is an 1xN structure, where N is
%           the number of models in the "model" input. Each element in
%           these structures is an optim structure output by pa_estimate
%           fitting that condition with a single model. For more
%           information about this structure, see pe_estimate.
%
%   Options
%
%       pa_estimate_options = options structure for pa_estimate, 
%       which pa_estimate_sj uses to perform parameter estimation for each
%       set of data in sj.
%
%   Jacob Parker 2018

if nargin < 3
    opts = pa_default_options();
    options = opts.pa_estimate_sj;
    clear opts
    if nargin < 1
        sj = options;
        return
    end
end

%OPTIONS
pa_estimate_options = options.pa_estimate;

%check model
for mm = 1:length(model)
    try
        pa_model_check(model(mm))
    catch
        fprintf('\nError in model %d\n',mm)
        pa_model_check(model(mm))
    end
end

sj.estim = [];

for mm = 1:length(model)
    fprintf('\nModel %d\n',mm)
    for cc = 1:length(sj.conditions)
        fprintf('Condition %s\n',sj.conditions{cc})
        sj.estim.(sj.conditions{cc})(mm) = pa_estimate(sj.means.(sj.conditions{cc}),sj.samplerate,sj.trialwindow,model(mm),pa_estimate_options);
    end
end