function cost = quick_glm_cost_1T(X,Ymeas)

window = [-500 3500];
Ymeas(1:-window(1)) = [];

Ycalc = quick_glm_calc_1T(X,0);
%Ycalc = quick_glm_calc(inX,0);

cost = sum((Ymeas-Ycalc).^2);