function optim = pa_optim(data,samplerate,trialwindow,model)
% pa_optim
% modelstate = pa_optim(data,model)

modelstate = model;
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

%recalculate time point vector
time = model.window(1):1/sfact:model.window(2);

%OPTIONS
%optimization options
optimplotflag = true;

%MAKE OPTION/AUTOMATICALLY OPTIMIZE?
%Factors to scale parameters by so that they are of a similar magnitude.
%Improves performance of the constrained optimization algorithm (fmincon)
ampfact = 1/10;
latfact = 1/1000;
tmaxfact = 1/1000;
yintfact = 10;

%construct inputs into fmincon (X, bounds, etc)
%MAKE SURE WORKS WITH CURRENT MODEL STRUCTURE
X=[]; lb=[]; ub=[];

if model.ampflag
    X = model.ampvals .* ampfact;
    lb = model.ampbounds(1,:) .* ampfact;
    ub = model.ampbounds(2,:) .* ampfact;
    
    X = [X model.boxampvals] .* ampfact;
    lb = [lb model.boxampbounds(1,:)] .* ampfact;
    ub = [ub model.boxampbounds(2,:)] .* ampfact;
end

if model.latflag
    X = [X model.vals] .* latfact;
    lb = [lb model.latbounds(1,:)] .* latfact;
    ub = [ub model.latbounds(2,:)] .* latfact;
end
    
if model.tmaxflag
    X = [X model.tmaxval] .* tmaxfact;
    lb = [lb model.tmaxbounds(1,:)] .* tmaxfact;
    ub = [ub model.tmaxbounds(2,:)] .* tmaxfact;
end

if model.yintflag
    X = [X model.yintval] .* yintfact;
    lb = [lb model.yintbounds(1,:)] .* yintfact;
    ub = [ub model.yintbounds(2,:)] .* yintfact;
end

f = @(X)optim_cost(X,data,model,ampfact,latfact,tmaxfact,yintfact);

if optimplotflag
    options = optimoptions('fmincon','Display','off','OutputFcn',@fmincon_outfun);
else
    options = optimoptions('fmincon','Display','off');
end

modelstate = model;

[X, cost] = fmincon(f,X,[],[],[],[],lb,ub,nonlcon,options);

optim = struct('eventimes',model.eventtimes,'boxtimes',model.boxtimes,'ampvals',[],'boxamps',[],'latvals',[],'tmaxval',[],'yintval',[],'cost',cost);
optim = unloadX(X,optim);

    function cost = optim_cost(X,data,modelstate)
        modelstate = unloadX(X,modelstate);
        cost = pa_cost(data,modelstate);  
    end

    function stop = fmincon_outfun(X,optimValues,state)
        stop = false;
        switch state
            case 'iter'
                clf
                modelstate = unloadX(X,modelstate);
                plot(time,data,'k')
                pa_plot_model(modelstate);
                yl = ylim;
                text(0,yl(2)*.9,num2str(optimValues.funccount),'HorizontalAlignment','center','BackgroundColor',[0.7 0.7 0.7]);
                pause(0.04)
            case 'interrupt'
                % No actions here
            case 'init'
                fh = figure(1);
            case 'done'
                try
                    close(fh);
                catch
                end
            otherwise
        end
    end

    function modelstate = unloadX(X,modelstate)
        numevents = length(modelstate.eventtimes);
        numboxes = length(modelstate.boxtimes);
        
        if modelstate.ampflag
            numA = numevents + numboxes;
            modelstate.ampvals = X(1:numevents) .* (1/ampfact);
            modelstate.boxampvals = X(numevents+1:numA) .* (1/ampfact);
        else
            numA = 0;
        end
        if modelstate.latflag
            numL = numevents;
            modelstate.latvals = X(numA+1:numA+numL) .* (1/latfact);
        else
            numL = 0;
        end
        if modelstate.tmaxflag
            numt = 1;
            modelstate.tmaxval = X(numA+numL+1) .* (1/tmaxfact);
        else
            numt = 0;
        end
        if modelstate.yintflag
            modelstate.yintval = X(numA+numL+numt+1) .* (1/yintfact);
        end
    end

end
