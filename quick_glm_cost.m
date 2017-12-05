function cost = quick_glm_cost(X,Ymeas)

Ycalc = quick_glm_calc(X,0);
%Ycalc = quick_glm_calc(inX,0);

cost = sum((Ymeas-Ycalc).^2);


