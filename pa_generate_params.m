function params = pa_generate_params(num,parammode,model,options)
% pa_generate_params
% params = pa_generate_params(num, parammode, model)
% params = pa_generate_params(num, parammode, model,options)
% 
% Generates random parameters using the specifications of a given model.
% 
%   Inputs:
%   
%       num = number of sets of parameters to be generated.
%           *IMPORTANT - if 'uniform' used, this number must be divisible
%           by options.nbins such that the resulting number is a whole
%           number!
% 
%       parammode ('uniform', 'normal', or 'space_optimal') = mode used to
%       generate parameters.
%           'uniform' - parameters are sampled in a roughly uniform manner
%           from the range of their respective bounds. For each parameter,
%           a uniform distribution is created using rand, then points are
%           sampled from 50 bins along this distribution spanning its
%           entire range. To change the number of bins, see options.nbins.
%           'normal' - parameters are drawn from a normal distrubtion
%           centered around the values provided in the input model
%           structure. The standard deviation is set by options.sigma.
%           'space_optimal' - finds the "num" number of points that
%           optimally cover the parameter space as defined by the
%           parameter bounds. Uses fmincon, so parameters need to be scaled
%           using options.ampfact, options.latfact, options.tmaxfact, and
%           options.yintfact.
% 
%       model = model structure created by pa_model and filled in by user.
%           *IMPORTANT - parameter values in model.ampvals,
%           model.boxampvals, model.latvals, model.tmaxval, and
%           model.yintval must be provided if 'normal' parammode is used!
% 
%       options = options structure for pa_generate_params. Default options 
%       can be returned by calling this function with no arguments, or see
%       pa_default_options.
% 
%   Outputs:
% 
%      params = an output structure containing all sets of parameters
%      generated. Contains the following fields:
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
%       nbins (50) = if 'uniform' parammode is used, specifies the number of
%       bins that are sampled from across the range of each parameter.
% 
%       sigma (0.05) = if 'normal' parammode is used, specifies the standard
%       deviation of the normal distribution each parameter is drawn from.
% 
%       ampfact (1/10), latfact (1/1000), tmaxfact (1/1000), and yintfact
%       (10) = if 'space_optimal' parammode is used, these options specify
%       the scaling factors for amplitude, latency, tmax, and y-intercept
%       parameters respectively. This is necessary because fmincon is used
%       to determine the optimal sets of parameters.
%
%   Jacob Parker 2018

if nargin < 4
    opts = pa_default_options();
    options = opts.pa_generate_params;
    clear opts
    if nargin < 1
        params = options;
        return
    end
end

%OPTIONS
nbins = options.nbins;
sigma = options.sigma;
ampfact = options.ampfact;
latfact = options.latfact;
tmaxfact = options.tmaxfact;
yintfact = options.yintfact;

%check inputs
pa_model_check(model)

rng(0)

params = struct('blank',[]);

params.ampvals = nan(num,length(model.eventtimes));
params.latvals = nan(num,length(model.eventtimes));
params.tmaxvals = nan(num,1);
params.yintvals = nan(num,1);
params.boxampvals = nan(num,length(model.boxtimes));

params = rmfield(params,'blank');

if strcmp(parammode,'uniform')

    %nbins vs num
    if rem(num,nbins) ~= 0
        error('"num" must be divisible by nbins such that num/nbins is an integer')
    end
    
    %amplitude
    if model.ampflag
        for cc = 1:length(model.eventtimes)
            params.ampvals(:,cc) = model.ampbounds(1,cc) + unidist((model.ampbounds(2,cc)-model.ampbounds(1,cc)).*rand(num*10,1),nbins,num/nbins);
        end
    else
        params.ampvals = repmat(model.ampvals,num,1);
    end
    
    %latency
    if model.latflag
        for cc = 1:length(model.eventtimes)
            params.latvals(:,cc) = model.latbounds(1,cc) + unidist((model.latbounds(2,cc)-model.latbounds(1,cc)).*rand(num*10,1),nbins,num/nbins);
        end
    else
        params.latvals = repmat(model.latvals,num,1);
    end
    
    %tmax
    if model.tmaxflag
        params.tmaxvals = model.tmaxbounds(1) + unidist((model.tmaxbounds(2)-model.tmaxbounds(1)).*rand(num*10,1),nbins,num/nbins);
    else
        params.tmaxvals = repmat(model.tmaxval,num,1);
    end
    
    %y-intercept
    if model.yintflag
        params.yintvals = model.yintbounds(1) + unidist((model.yintbounds(2)-model.yintbounds(1)).*rand(num*10,1),nbins,num/nbins);
    else
        params.yintvals = repmat(model.yintval,num,1);
    end
    
    %box amplitude
    if model.ampflag
        for cc = 1:length(model.boxtimes)
            params.boxampvals(:,cc) = model.boxampbounds(1,cc) + unidist((model.boxampbounds(2,cc)-model.boxampbounds(1,cc)).*rand(num*10,1),nbins,num/nbins);
        end
    else
        params.boxampvals = repmat(model.boxampvals,num,1);
    end
elseif strcmp(parammode,'normal')

    if model.ampflag
        ampvals = model.ampvals .* ampfact;
        for cc = 1:length(model.eventtimes)
            params.ampvals(:,cc) = (ampvals(cc) + randn(num,1) .* sigma) .* 1/ampfact;
        end
        params.ampvals(params.ampvals < model.ampbounds(1,cc)) = model.ampbounds(1,cc);
        params.ampvals(params.ampvals > model.ampbounds(2,cc)) = model.ampbounds(2,cc);
     else
        params.ampvals = repmat(model.ampvals,num,1);
     end
     
     if model.latflag
        latvals = model.ampvals .* latfact;
        for cc = 1:length(model.eventtimes)
            params.latvals(:,cc) = (latvals(cc) + randn(num,1) .* sigma) .* 1/latfact;
        end
        params.latvals(params.latvals < model.latbounds(1,cc)) = model.latbounds(1,cc);
        params.latvals(params.latvals > model.latbounds(2,cc)) = model.latbounds(2,cc);
     else
        params.latvals = repmat(model.latvals,num,1);
     end
     
     if model.tmaxflag
        tmaxval = model.tmaxval .* tmaxfact;
        params.tmaxvals = (tmaxval + randn(num,1) .* sigma) .* 1/tmaxfact;
        params.tmaxvals(params.tmaxvals < model.tmaxbounds(1)) = model.tmaxbounds(1);
        params.tmaxvals(params.tmaxvals > model.tmaxbounds(2)) = model.tmaxbounds(2);
     else
        params.tmaxvals = repmat(model.tmaxval,num,1);
     end
     
     if model.yintflag
        yintval = model.yintval .* yintfact;
        params.yintvals = (yintval + randn(num,1) .* sigma) .* 1/yintfact;
        params.yintvals(params.yintvals < model.yintbounds(1)) = model.yintbounds(1);
        params.yintvals(params.yintvals > model.yintbounds(2)) = model.yintbounds(2);
     else
        params.yintvals = repmat(model.yintval,num,1);
     end

     if model.ampflag
        boxampvals = model.boxampvals .* ampfact;
        for cc = 1:length(model.boxtimes)
            params.boxampvals(:,cc) = (boxampvals(cc) + randn(num,1) .* sigma) .* 1/ampfact;
        end
        params.boxampvals(params.boxampvals < model.boxampbounds(1,cc)) = model.boxampbounds(1,cc);
        params.boxampvals(params.boxampvals > model.boxampbounds(2,cc)) = model.boxampbounds(2,cc);
     else
        params.boxampvals = repmat(model.boxampvals,num,1);
     end
     
elseif strcmp(parammode,'space_optimal')
    
    X=[]; lb=[]; ub=[];
    numevents = length(model.eventtimes);
    numboxes = length(model.boxtimes);
    
    amp = nan(num,numevents);
    boxamp = nan(num,numboxes);
    lat = nan(num,numevents);
    
    for ee = 1:numevents
        amp(:,ee) = model.ampbounds(1,ee) + rand(num,numevents) .* (model.ampbounds(2,ee) - model.ampbounds(1,ee));
        lat(:,ee) = model.latbounds(1,ee) + rand(num,numevents) .* (model.latbounds(2,ee) - model.latbounds(1,ee));
    end
    for bx = 1:numboxes
        boxamp(:,bx) = model.boxampbounds(1,bx) + rand(num,numboxes) .* (model.boxampbounds(2,bx) - model.boxampbounds(1,bx));
    end
    tmax = model.tmaxbounds(1) + rand(num,1) .* (model.tmaxbounds(2) - model.tmaxbounds(1));
    yint = model.yintbounds(1) + rand(num,1) .* (model.yintbounds(2) - model.yintbounds(1));
    
    if model.ampflag
        X = amp .* ampfact;
        lb = model.ampbounds(1,:) .* ampfact;
        ub = model.ampbounds(2,:) .* ampfact;
        
        X = [X boxamp] .* ampfact;
        lb = [lb model.boxampbounds(1,:)] .* ampfact;
        ub = [ub model.boxampbounds(2,:)] .* ampfact;
    end
    
    if model.latflag
        X = [X lat] .* latfact;
        lb = [lb model.latbounds(1,:)] .* latfact;
        ub = [ub model.latbounds(2,:)] .* latfact;
    end
    
    if model.tmaxflag
        X = [X tmax] .* tmaxfact;
        lb = [lb model.tmaxbounds(1,:)] .* tmaxfact;
        ub = [ub model.tmaxbounds(2,:)] .* tmaxfact;
    end
    
    if model.yintflag
        X = [X yint] .* yintfact;
        lb = [lb model.yintbounds(1,:)] .* yintfact;
        ub = [ub model.yintbounds(2,:)] .* yintfact;
    end
    
    X = optimize_param_space(X,lb,ub);
    
    if model.ampflag
        numA = numevents + numboxes;
        params.ampvals = X(1:numevents) .* (1/ampfact);
        params.boxampvals = X(numevents+1:numA) .* (1/ampfact);
    else
        numA = 0;
    end
    if model.latflag
        numL = numevents;
        params.latvals = X(numA+1:numA+numL) .* (1/latfact);
    else
        numL = 0;
    end
    if model.tmaxflag
        numt = 1;
        params.tmaxvals = X(numA+numL+1) .* (1/tmaxfact);
    else
        numt = 0;
    end
    if model.yintflag
        params.yintvals = X(numA+numL+numt+1) .* (1/yintfact);
    end
    
end

function output = unidist(x,nbins,spb)
        
        [~,index] = makedist(x,nbins);
        uindex = [];
        
        for bb = 1:nbins
            if sum(index{bb}) >= spb
                uindex = [uindex ; randsample(index{bb},spb)];
            end
        end
        
        output = x(uindex);
        
    end

    function [dist,index,bins,hdist,hbins] = makedist(x,nbins)
        
        xbins = linspace(min(x),max(x),nbins+1);
        dist = nan(nbins,1);
        index = cell(nbins,1);
        
        for nn = 1:nbins
            if nn == nbins
                xlog = (x >= xbins(nn)) & (x <= xbins(nn+1));
            else
                xlog = (x >= xbins(nn)) & (x < xbins(nn+1));
            end
            dist(nn) = sum(xlog);
            index{nn} = find(xlog);
        end
        
        bins = xbins(1:end-1)+(diff(xbins)./2);
        
        hbins = repmat(xbins,2,1);
        hbins = reshape(hbins,1,2*size(hbins,2));
        
        hdist = repmat(dist',[2,1]);
        hdist = reshape(hdist,1,2*size(hdist,2));
        hdist = [0 hdist 0];
        
    end

end
    