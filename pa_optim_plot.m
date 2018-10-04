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
    Xcalc = [B Blocs decloc tmax yint];
    [Ycalc,x] = quick_glm_calc(Xcalc,0);
elseif length(X) == 9
    B = X(1:4).*bf;
    Blocs = X(5:7).*lf;
    yint = X(8).*yf;
    tmax = X(9).*tf;
    cvec = [0 0 1; 1 0 0; 1 0 1; 0 0 0];
    Xcalc = [B Blocs decloc tmax yint];
    [Ycalc,x] = quick_glm_calc_1T(Xcalc,0);
elseif length(X) == 7
    B = X(1:5).*bf;
    Blocs = [0 1000 1250 1750];
    yint = X(10).*yf;
    tmax = X(11).*tf;
    cvec = [0 0 1; 1 0 0; 0 1 0; 1 0 1; 0 0 0];
    Xcalc = [B Blocs decloc tmax yint];
    [Ycalc,x] = quick_glm_calc(Xcalc,0);
end

x = x + yint;
hold on
set(gca,'ColorOrder',cvec)
plot([0 window(2)],[yint yint],'--c')
plot(0:window(2),x,'--')
plot(0:window(2),Ycalc,'color',[0.5 0.5 0.5])
plot(0:window(2),Ymeas,'k')
ylim([(min(Ymeas)-0.02) (max(Ymeas)+0.02)])
yl = ylim;
xlim([-500 3500])
plot(repmat(Blocs,2,1),repmat([yl(1) ; yl(2)],1,length(Blocs)),'--')
text(0,yl(2)*.9,num2str(dispval),'HorizontalAlignment','center','BackgroundColor',[0.7 0.7 0.7]);
    
