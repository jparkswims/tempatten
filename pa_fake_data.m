function [data, outparams] = pa_fake_data(numtseries,parammode,samplerate,trialwindow,model)
% pa_fake_data
% data = pa_fake_data(trialwindow,samplerate,model)

%check inputs
pa_model_check(model)

sfact = samplerate/1000;
time = trialwindow(1):1/sfact:trialwindow(2);

%model time window vs time points
if ~(any(model.window(1) == time)) || ~(any(model.window(2) == time ))
error('Model time window does not fall on time points according to sample rate and trial window')
end

data = nan(numtseries,trialwindow(2)-trialwindow(1)+1);
modelstate = model;
modelstate.window = trialwindow;


%generate parameters to create time series with
params = pa_generate_params(numtseries,parammode,model);

%generate time series from parameters
for ts = 1:numtseries
    modelstate.ampvals = params.ampvals(ts,:);
    modelstate.boxampvals = params.boxampvals(ts,:);
    modelstate.latvals = params.latvals(ts,:);
    modelstate.tmaxval = params.tmaxvals(ts);
    modelstate.yintval = params.yintvals(ts);
    data(ts,:) = pa_calc(modelstate);
end

outparams = struct('eventimes',model.eventtimes,'boxtimes',model.boxtimes,'ampvals',params.ampvals,'boxampvals',params.boxampvals,'latvals',params.latvals,'tmaxvals',params.tmaxvals,'yintvals',params.yintvals);

