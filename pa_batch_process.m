function sjs = pa_batch_process(sjs,model,varargin)
% pa_batch_process
% sjs = pa_batch_process(sjs,models)

%OPTIONS
%a global options input?
nboots = 10;
wnum = 2;

%check model
pa_check_model(model)

for arg = 1:length(varargin)
    switch varargin{arg}
        case 'estimate'
            estflag = true;
        case 'bootstrap'
            bootflag = true;
    end
end

for s = 1:length(sjs)
    if estflag
        sjs(s) = pa_estimate_sj(sjs(s),model);
    end
    if bootflag
        sjs(s) = pa_bootstrap_sj(sjs(s),model,nboots,wnum);
    end
end
    