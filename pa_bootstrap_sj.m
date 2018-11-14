function sj = pa_bootstrap_sj(sj,model,nboots,wnum)
% pa_bootstrap_sj
% sj = pa_bootstrap_sj(sj,model,nboots,wnum)
% *multiple models can be entered as a Nx1 structure*

%OPTIONS
%options for pa_bootstrap should be input into function

%check model
for mm = 1:length(model)
    try
        pa_model_check(model(mm))
    catch
        fprintf('\nError in model %d\n',mm)
    end
end

sj.boots = [];

for mm = 1:length(model)
    for cc = 1:length(sj.conditions)
        sj.boots(mm).(sj.conditions{cc}) = pa_bootstrap(sj.(sj.conditions{cc}),sj.samplerate,sj.trialwindow,model(mm),nboots,wnum);
    end
end