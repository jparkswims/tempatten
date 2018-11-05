function pa_plot_model(model)
% pa_plot_model(model)

sfact = model.samplerate/1000;
time = model.window(1):1/sfact:model.window(2);

%check inputs
pa_model_check(model)

[Ycalc, X] = pa_calc(model);

X = X + model.yintval;

hold on
plot(time,Ycalc,'--','color',[0.5 0.5 0.5])
plot([model.window(1) model.window(2)],[model.yintval model.yintval]);
plot(time,X)
xlim(model.window)
yl = ylim;
plot(repmat(model.timevals + model.latvals,2,1),repmat([yl(1) ; yl(2)],1,length(model.timevals)),'--')
