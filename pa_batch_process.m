function sjs = pa_batch_process(sjs,model,options)
% pa_batch_process
% sjs = pa_batch_process(sjs,models)
% sjs = pa_batch_process(sjs,models,options)
% 
% Performs the estimation procedure and/or the bootstrapping procedure to
% estimate model parameters for the data for each sj structure in sjs.
% 
%   Inputs:
%
%       sjs = structure in which each field is an sj structure output by
%       pa_preprocess.
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
%       options = options structure for pa_batch_process. Default options can be
%       returned by calling this function with no arguments, or see
%       pa_default_options.
%
%   Output
%
%       sjs = same structure that was input, but with the following fields
%       appended to each sj structure (the fields of sjs):
%           *if estimation done*
%           optim = a Nx1 structure, where N is the number of models input
%           in "model". Each element of this structure is an optim
%           structure for a single model. See pa_optim or pa_estimate for
%           more information about this structure.
%           *if bootstrapping done*
%           boots = a Nx1 structure, where N is the number of models input
%           in "model". Each element of this structure is an boots
%           structure for a single model. See pa_bootstrap for more
%           information about this structure.
%
%   Options
% 
%       estflag (true/false) = do estimation procedure on the data in each
%       sj structure? Implemented by pa_estimate_sj.
% 
%       bootflag (true/false) = do bootstrapping procedure on the data in each
%       sj structure? Implemented by pa_boostrap_sj.
% 
%       nboots = if doing bootstrapping procedure, how many bootstrap
%       iterations to do.
% 
%       wnum = if doing bootstrapping procedure, how many matlab workers to
%       use while doing the bootstrapping procedure.
%
%       pa_estimate_sj_options = options structure for pa_estimate_sj, 
%       which pa_batch_process uses to perform parameter estimation for the
%       data in each sj structure.
% 
%       pa_bootstrap_sj_options = options structure for pa_bootstrap_sj, 
%       which pa_batch_process uses to perform the bootstrapping procedure for the
%       data in each sj structure.
%
%   Jacob Parker 2018

if nargin < 3
    opts = pa_default_options();
    options = opts.pa_batch_process;
    clear opts
    if nargin < 1
        sjs = options;
        return
    end
end

%OPTIONS
estflag = options.estflag;
bootflag = options.bootflag;
nboots = options.nboots;
wnum = options.wnum;
pa_estimate_sj_options = options.pa_estimate_sj;
pa_bootstrap_sj_options = options.pa_bootstrap_sj;

%check model
pa_check_model(model)

% for arg = 1:length(varargin)
%     switch varargin{arg}
%         case 'estimate'
%             estflag = true;
%         case 'bootstrap'
%             bootflag = true;
%     end
% end

for s = 1:length(sjs)
    if estflag
        sjs(s) = pa_estimate_sj(sjs(s),model,pa_estimate_sj_options);
    end
    if bootflag
        sjs(s) = pa_bootstrap_sj(sjs(s),model,nboots,wnum,pa_bootstrap_sj_options);
    end
end
    