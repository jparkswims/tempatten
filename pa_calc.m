function [Ycalc, X] = pa_calc(model)
% pa_calc
% [Ycalc, X] = pa_calc(modelstate)

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
    
    h = hpupil(time,n,model.tmaxval,model.eventtimes(xx)+model.latvals(xx));
    temp = conv(h,model.ampvals(xx));
    X1(xx,:) = temp;
    
end

for bx = 1:size(X2,1)
    
    h = hpupil(time,n,model.tmaxval,model.boxtimes{bx}(1));
    temp = conv(h,(ones(model.boxtimes{bx}(1)-model.boxtimes{bx}(2)+1))*boxscale);
    X2(xx,:) = temp;
    
end

X = [X1 ; X2];
Ycalc = sum(X,1) + model.yintval;

%MAKE SEPARATE FUNCTION?

    function output = hpupil(t,n,tmax,t0)
        
        % n+1 = number of laters (10.1)
        % tmax = response maximum (930)
        % function is normalized to a max of 0.01, in case tmax varies
        % t0 is the time of the event
        
        output = ((t-t0).^n).*exp(-n.*(t-t0)./tmax);
        %output((t-t0)<=window(1)) = [];
        output = (output/(max(output))) .* 0.01;
        
    end

end