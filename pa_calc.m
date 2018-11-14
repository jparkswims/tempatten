function [Ycalc, X] = pa_calc(model,options)
% pa_calc
% [Ycalc, X] = pa_calc(modelstate)

if nargin < 2
    opts = pa_default_options();
    options = opts.pa_calc;
    clear opts
    if nargin < 1
        Ycalc = options;
        return
    end
end

%OPTIONS
n = 10.1;
boxscale = 1/500;

%check input
pa_model_check(model)

X1 = nan(length(model.eventtimes),model.window(2)-model.window(1)+1);
X2 = nan(length(model.boxtimes),model.window(2)-model.window(1)+1);

sfact = model.samplerate/1000;
time = model.window(1):1/sfact:model.window(2);

for xx = 1:size(X1,1)
    
    h = pupilrf(time,n,model.tmaxval,model.eventtimes(xx)+model.latvals(xx));
    temp = conv(h,model.ampvals(xx));
    X1(xx,:) = temp;
    
end

for bx = 1:size(X2,1)
    
    h = pupilrf(time,n,model.tmaxval,model.boxtimes{bx}(1));
    temp = conv(h,(ones(1,model.boxtimes{bx}(2)-model.boxtimes{bx}(1)+1)).*model.boxampvals(bx).*boxscale);
    X2(bx,:) = temp(1:model.window(2)-model.window(1)+1);
    
end

X = [X1 ; X2];
Ycalc = sum(X,1) + model.yintval;

