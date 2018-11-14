function boots = pa_bootstrap(data,samplerate,trialwindow,model,nboots,wnum)
% pa_bootstrap
% output = pa_bootstrap(data,samplerate,trialwindow,model)

%NOTE: DATA IS A 2D MATRIX (TRIAL VS TIME)

sfact = samplerate/1000;
time = trialwindow(1):1/sfact:trialwindow(2);

%check inputs
%simple check of input model structure
pa_model_check(model)

%samplerate, trialwindow vs data
if length(time) ~= size(data,2)
    error('The number of time points does not equal the number of data points in a trial')
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
data = data(:,datalb:dataub);

%create bootstrap means of trials in data
rng(0)
means = bootstrp(nboots,@nanmean,data);

bootoptims = struct('eventimes',model.eventtimes,'boxtimes',model.boxtimes,'ampvals',[],'boxampvals',[],'latvals',[],'tmaxval',[],'yintval',[],'cost',[],'R2',[]);
modelsamplerate = model.samplerate;
modelwindow = model.window;

%estimate model parameters for each bootstrap mean
fprintf('\nBeginning bootstrapping, %d iterations to be completed\n',nboots)
if wnum == 1
    for nb = 1:nboots
        fprintf('\nStart iteration %d\n',nb)
        bootoptims(nb) = pa_estimate(means(nb,:),modelsamplerate,modelwindow,model);
        fprintf('\nEnd iteration %d\n',nb)
    end
else
    parfor nb = 1:nboots
        fprintf('\nStart iteration %d\n',nb)
        bootoptims(nb) = pa_estimate(means(nb,:),modelsamplerate,modelwindow,model);
        fprintf('\nEnd iteration %d\n',nb)
    end
end

boots = struct('eventimes',model.eventtimes,'boxtimes',model.boxtimes,'ampvals',nan(nboots,length(model.eventtimes)),'boxamps',nan(nboots,length(model.boxtimes)),'latvals',nan(nboots,length(model.eventtimes)),'tmaxvals',nan(nboots,1),'yintvals',nan(nboots,1),'costs',nan(nboots,1),'R2',nan(nboots,1));

for nb = 1:nboots
    boots.ampvals(nb,:) = bootoptims(nb).ampvals;
    boots.boxampvals(nb,:) = bootoptims(nb).boxampvals;
    boots.latvals(nb,:) = bootoptims(nb).latvals;
    boots.tmaxvals(nb,:) = bootoptims(nb).tmaxval;
    boots.yintvals(nb,:) = bootoptims(nb).yintval;
    boots.costs(nb) = bootoptims(nb).cost;
    boots.R2(nb) = bootoptims(nb).R2;
end
