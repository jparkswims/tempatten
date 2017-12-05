function [Y,reg] = quick_glm_calc(X,pflag)

%glm_calc(window,B,Blocs,Btypes,tmax,yint,norm)

window = [-500 3500];
B = X(1:5);
Blocs = mat2cell(X(6:11),1,[1 1 1 1 2]);
Btypes = {'stick' 'stick' 'stick' 'stick' 'box'};
tmax = X(12);
yint = X(13);
norm = 'max';

[Y,reg] = glm_calc(window,B,Blocs,Btypes,tmax,yint,norm);
lat = round(X(6:9));

if pflag == 1
    %figure
    plot(0:3500,reg)
    hold on
    plot(0:3500,Y,'--k')
    yl = ylim;
    xlabel('time (ms)')
    ylabel('proportion change from baseline')
    plot([lat(1) lat(1)],[yl(1) yl(2)],'--b')
    plot([lat(2) lat(2)],[yl(1) yl(2)],'--r')
    plot([lat(3) lat(3)],[yl(1) yl(2)],'--g')
    plot([lat(4) lat(4)],[yl(1) yl(2)],'--k')
    ylim(yl);
end
    