function optim = pa_estimate(data,samplerate,trialwindow,model)
% pa_estimate
% optim = pa_estimate(data,samplerate,trialwindow,model)
% optim = pa_estimate(data,samplerate,trialwindow,model,options)

%OPTIONS
%return output optimization parameters from each starting point?
%optimplot?
nbins = 50;
searchnum = 2000;
optimnum = 40;

sfact = samplerate/1000;
time = trialwindow(1):1/sfact:trialwindow(2);

%check inputs
%simple check of input model structure
pa_model_check(model)

%nbins vs searchnum
if ~(isinteger(searchnum/nbins)
    error('searchnum must be divisible by nbins such that searchnum/nbins is an integer')
end

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
rng(0)

%DEPENDENCY OF SEARCHNUM/OPTIMNUM FOR "UNIDIST" FUNCTION?
%LET NUMBER OF BINS BE A PARAMETER, USE CHECK TO MAKE SURE SEARCHNUM/NBINS
%IS A WHOLE NUMBER
%amplitude
if model.ampflag
    searchamp = nan(searchnum,length(model.eventtimes));
    for cc = 1:length(model.eventtimes)
        searchamp(cc,:) = model.ampbounds(1,cc) + unidist(model.ampbounds(2,cc)-model.ampbounds(1,cc).*rand(searchnum*10,1),nbins,searchnum/nbins);
    end
else
    searchamp = repmat(model.ampvals,searchnum,1);
end

%latency
if model.latflag
    searchlat = nan(searchnum,length(model.eventtimes));
    for cc = 1:length(model.eventtimes)
        searchlat(cc,:) = model.latbounds(1,cc) + unidist(model.latbounds(2,cc)-model.latbounds(1,cc).*rand(searchnum*10,1),nbins,searchnum/nbins);
    end
else
    searchlat = repmat(model.latvals,searchnum,1);
end

%tmax
if model.tmaxflag
    searchtmax = model.tmaxbounds(1,cc) + unidist(model.tmaxbounds(2,cc)-model.tmaxbounds(1,cc).*rand(searchnum*10,1),nbins,searchnum/nbins);
else
    searchtmax = repmat(model.tmaxval,searchnum,1);
end

%y-intercept
if model.yintflag
    searchyint = model.yintbounds(1,cc) + unidist(model.yintbounds(2,cc)-model.yintbounds(1,cc).*rand(searchnum*10,1),nbins,searchnum/nbins);
else
    searchyint = repmat(model.yintval,searchnum,1);
end

%box amplitude
if model.ampflag
    searchboxamp = nan(searchnum,length(model.boxtimes));
    for cc = 1:length(model.boxtimes)
        searchboxamp(cc,:) = model.boxampbounds(1,cc) + unidist(model.boxampbounds(2,cc)-model.boxampbounds(1,cc).*rand(searchnum*10,1),nbins,searchnum/nbins);
    end
else
    searchboxamp = repmat(model.boxampvals,searchnum,1);
end

%ADD PARAM PRESORTING/MORE EVEN SAMPLING?
%OPTIMAL PARAMETER SPACE SAMPLING (KEEP IN MIND)

%structure to store temporary param values
modelstate = model;
modelstate.search = struct('ampvals',searchamp,'latvals',searchlat,'tmaxval',searchtmax,'yintval',searchyint,'boxampvals',searchboxamp);

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
searchoptims = struct('eventimes',model.eventtimes,'boxtimes',model.boxtimes,'ampvals',[],'boxamps',[],'latvals',[],'tmaxval',[],'yintval',[],'cost',[]);
tempcosts = [];
for op = 1:optimnum
    modelstate.ampvals = modelstate.search.ampvals(modelstate.search.optimindex(op),:);
    modelstate.boxamps = modelstate.search.boxamps(modelstate.search.optimindex(op),:);
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
