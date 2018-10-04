function cost = quick_glm_cost(X,Ymeas)

window = [-500 3500];
%changed for glm_grid_test on 8/21/2018
%Ymeas(1:-window(1)) = [];

Ycalc = quick_glm_calc(X,0);
%Ycalc = quick_glm_calc(inX,0);

cost = sum((Ymeas-Ycalc).^2);


