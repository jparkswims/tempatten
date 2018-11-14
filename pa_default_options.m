function options = pa_default_options()
% pa_default_options
% options = pa_default_options
% 
% Returns the structure "options", which contains the default options for
% every function inluded in this package in fields titled as the function
% name. The fields of this output structure can be input as the last
% argument into many functions to specify options. For example,
% "options.pa_estimate" can be entered as the last argument into the
% pa_estimate function. You can also obtain function specific option
% structures by calling the function with no input arguments.
% 
% Default options for most functions can be changed by modifying this 
% function directly.

options = struct('pa_calc',[],'pa_cost',[],'pa_optim',[],'pa_estimate',[],'pa_bootstrap',[],...
    'pa_generate_params',[],'pa_fake_data',[],'pa_preprocess',[],'pa_estimate_sj',[],...
    'pa_bootstrap_sj',[],'pa_batch_process',[]);

%% pa_calc
options.pa_calc.n = 10.1;
options.pa_calc.boxscale = 1/500;

%% pa_cost
options.pa_cost.pa_calc = options.pa_calc;

%% pa_optim
options.pa_optim.optimplotflag = true;
options.pa_optim.ampfact = 1/10;
options.pa_optim.latfact = 1/1000;
options.pa_optim.tmaxfact = 1/1000;
options.pa_optim.yintfact = 10;
options.pa_optim.pa_cost = options.pa_cost;

%input values/options for fmincon
options.pa_optim.A = [];
options.pa_optim.B = [];
options.pa_optim.Aeq = [];
options.pa_optim.Beq = [];
options.pa_optim.NONLCON = [];
options.pa_optim.fmincon_options = fmincon('defaults');
options.pa_optim.fmincon_options.Display = 'off';

%% pa_generate_params
options.pa_generate_params.nbins = 50;
options.pa_generate_params.sigma = 0.05;
options.pa_generate_params.ampfact = 1/10;
options.pa_generate_params.latfact = 1/1000;
options.pa_generate_params.tmaxfact = 1/1000;
options.pa_generate_params.yintfact = 10;


%% pa_estimate
options.pa_estimate.searchnum = 2000;
options.pa_estimate.optimnum = 40;
options.pa_estimate.parammode = 'uniform';
options.pa_estimate.pa_generate_params = options.pa_generate_params;
options.pa_estimate.pa_cost = options.pa_cost;
options.pa_estimate.pa_optim = options.pa_optim;

%% pa_bootstrap
options.pa_bootstrap.pa_esimate = options.pa_estimate;

%% pa_fake_data
options.pa_fake_data.pa_generate_params = options.pa_generate_params;

%% pa_preprocess
options.pa_preprocess.normflag = true;
options.pa_preprocess.blinkflag = true;

%blinkinterp arguments
options.pa_preprocess.th1 = 5;
options.pa_preprocess.th2 = 3;
options.pa_preprocess.bwindow = 50;
options.pa_preprocess.betblink = 75;

%% pa_estimate_sj
options.pa_estimate_sj.pa_estimate = options.pa_estimate;

%% pa_bootstrap_sj
options.pa_bootstrap_sj.pa_bootstrap = options.pa_bootstrap;

%% pa_batch_process
options.pa_batch_process.pa_estimate_sj = options.pa_estimate_sj;
options.pa_batch_process.pa_bootstrap_sj = options.pa_bootstrap_sj;
