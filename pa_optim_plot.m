function pa_optim_plot(X,Ymeas,decloc,dispval)
% x ordered as [betas, locations, yint, tmax]
window = [-500 3500];
bf = 10;
lf = 1000;
tf = 1000;
yf = 0.1;

if length(X) == 11
    B = X(1:5).*bf;
    Blocs = X(6:9).*lf;
    yint = X(10).*yf;
    tmax = X(11).*tf;
    cvec = [0 0 1; 1 0 0; 0 1 0; 1 0 1; 0 0 0];
elseif length(X) == 9
    B = X(1:4);
    Blocs = X(5:7);
    yint = X(8);
    tmax = X(9);
    cvec = [0 0 1; 1 0 0; 1 0 1; 0 0 0];
end

Xcalc = [B Blocs decloc tmax yint];
[Ycalc,reg] = quick_glm_calc(Xcalc,0);
reg = reg + yint;
hold on
set(gca,'ColorOrder',cvec)
plot([0 window(2)],[yint yint],'--c')
plot(0:window(2),reg,'--')
plot(0:window(2),Ycalc,'color',[0.5 0.5 0.5])
plot(0:window(2),Ymeas,'k')
ylim([(min(Ymeas)-0.02) (max(Ymeas)+0.02)])
yl = ylim;
xlim([-500 3500])
plot(repmat(Blocs,2,1),repmat([yl(1) ; yl(2)],1,length(Blocs)),'--')
text(0,yl(2)*.9,num2str(dispval),'HorizontalAlignment','center','BackgroundColor',[0.7 0.7 0.7]);
    
