function options = pret_default_options()
% pret_default_options
% options = pret_default_options
% 
% Returns the structure "options", which contains the default options for
% every function inluded in this package in fields titled as the function
% name. The fields of this output structure can be input as the last
% argument into many functions to specify options. For example,
% "options.pret_estimate" can be entered as the last argument into the
% pret_estimate function. You can also obtain function specific option
% structures by calling the function with no input arguments.
% 
% Default options for most functions can be changed by modifying this 
% function directly.

options = struct('pret_calc',[],'pret_cost',[],'pret_optim',[],'pret_estimate',[],'pret_bootstrap',[],...
    'pret_generate_params',[],'pret_fake_data',[],'pret_preprocess',[],'pret_estimate_sj',[],...
    'pret_bootstrap_sj',[],'pret_batch_process',[]);

%% pret_calc
options.pret_calc.n = 10.1;

%% pret_cost
options.pret_cost.pret_calc = options.pret_calc;

%% pret_optim
options.pret_optim.optimplotflag = true;
options.pret_optim.ampfact = 1/10;
options.pret_optim.boxampfact = 1/10;
options.pret_optim.latfact = 1/1000;
options.pret_optim.tmaxfact = 1/1000;
options.pret_optim.yintfact = 10;
options.pret_optim.pret_cost = options.pret_cost;

%input values/options for fmincon
options.pret_optim.A = [];
options.pret_optim.B = [];
options.pret_optim.Aeq = [];
options.pret_optim.Beq = [];
options.pret_optim.NONLCON = [];
options.pret_optim.fmincon_options = fmincon('defaults');
options.pret_optim.fmincon_options.Display = 'off';

%% pret_generate_params
options.pret_generate_params.nbins = 50;
options.pret_generate_params.sigma = 0.05;
options.pret_generate_params.ampfact = 1/10;
options.pret_generate_params.boxampfact = 1/10;
options.pret_generate_params.latfact = 1/1000;
options.pret_generate_params.tmaxfact = 1/1000;
options.pret_generate_params.yintfact = 10;


%% pret_estimate
options.pret_estimate.searchnum = 2000;
options.pret_estimate.optimnum = 3;
options.pret_estimate.parammode = 'uniform';
options.pret_estimate.pret_generate_params = options.pret_generate_params;
options.pret_estimate.pret_cost = options.pret_cost;
options.pret_estimate.pret_optim = options.pret_optim;

%% pret_bootstrap
options.pret_bootstrap.bootplotflag = true;
options.pret_bootstrap.pret_estimate = options.pret_estimate;

%% pret_plot_model
options.pret_plot_model.pret_calc = options.pret_calc;

%% pret_fake_data
options.pret_fake_data.pret_generate_params = options.pret_generate_params;

%% pret_preprocess
options.pret_preprocess.normflag = true;
options.pret_preprocess.blinkflag = true;

%blinkinterp arguments
options.pret_preprocess.th1 = 5;
options.pret_preprocess.th2 = 3;
options.pret_preprocess.bwindow = 50;
options.pret_preprocess.betblink = 75;

%% pret_estimate_sj
options.pret_estimate_sj.pret_estimate = options.pret_estimate;

%% pret_bootstrap_sj
options.pret_bootstrap_sj.pret_bootstrap = options.pret_bootstrap;

%% pret_batch_process
options.pret_batch_process.estflag = true;
options.pret_batch_process.pret_estimate_sj = options.pret_estimate_sj;
options.pret_batch_process.bootflag = true;
options.pret_batch_process.pret_bootstrap_sj = options.pret_bootstrap_sj;