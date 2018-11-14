function sj = pa_estimate_sj(sj,model)
% pa_estimate_sj
% sj = pa_estimate_sj(sj,models)
% *multiple models can be entered as a Nx1 structure*

%OPTIONS
%options for pa_estimate should be input into function

%check model
for mm = 1:length(model)
    try
        pa_model_check(model(mm))
    catch
        fprintf('\nError in model %d\n',mm)
    end
end

sj.optims = [];

for mm = 1:length(model)
    for cc = 1:length(sj.conditions)
        sj.optims(mm).(sj.conditions{cc}) = pa_estimate(sj.means.(sj.conditions{cc}),sj.samplerate,sj.trialwindow,model(mm));
    end
end