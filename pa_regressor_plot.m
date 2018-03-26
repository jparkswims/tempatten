function pa_regressor_plot(pa,f,m,s)

[Ycalc, X] = glm_calc(pa.window,pa.(pa.fields{f}).models(m).betas(s,:),[num2cell(pa.(pa.fields{f}).models(m).locations(s,:)) [0 round(pa.dectime(s))]],pa.models(m).Btypes,pa.(pa.fields{f}).models(m).tmax(s),pa.(pa.fields{f}).models(m).yint(s),pa.models(m).normalization);

X = X + pa.(pa.fields{f}).models(m).yint(s);
if m == 1
    cvec = [0 0 1; 1 0 0; 0 1 0; 1 0 1; 0 0 0];
elseif m == 2
    cvec = [0 0 1; 1 0 0; 1 0 1; 0 0 0];
end

hold on
set(gca,'ColorOrder',cvec)
plot([pa.window(1) pa.window(2)],[pa.(pa.fields{f}).models(m).yint(s) pa.(pa.fields{f}).models(m).yint(s)],'--c')
plot(0:pa.window(2),X,'--')
plot(0:pa.window(2),Ycalc,'color',[0.5 0.5 0.5])
plot(pa.window(1):pa.window(2),pa.(pa.fields{f}).smeans(s,:),'k')
yl = ylim;
xl = xlim;
plot(repmat(pa.(pa.fields{f}).models(m).locations(s,:),2,1),repmat([yl(1) ; yl(2)],1,length(pa.(pa.fields{f}).models(m).locations(s,:))),'--')
text(xl(2)*.02,yl(2)*.9,['BIC = ' num2str(pa.(pa.fields{f}).bic(s,1,m))],'HorizontalAlignment','center','BackgroundColor',[0.7 0.7 0.7]);
