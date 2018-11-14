function pa_plot_model(model)
% pa_plot_model(model)

sfact = model.samplerate/1000;
time = model.window(1):1/sfact:model.window(2);

%check inputs
pa_model_check(model)

[Ycalc, X] = pa_calc(model);

X = X + model.yintval;

hold on
plot(time,Ycalc,'--','color',[0.6 0.6 0.6],'LineWidth',1.5)
ax = gca;
ax.ColorOrderIndex = 1;
plot(time,X,'LineWidth',1.5)
plot([model.window(1) model.window(2)],[model.yintval model.yintval],'k','LineWidth',1);
xlim(model.window)
yl = ylim;
ax.ColorOrderIndex = 1;
plot(repmat(model.eventtimes + model.latvals,2,1),repmat([yl(1) ; yl(2)],1,length(model.eventtimes)),'--','LineWidth',1)
