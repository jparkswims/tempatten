function pa_model_check(model)
% pa_model_check
% checkflag = pa_model_check(model)

sfact = model.samplerate/1000;
time = model.window(1):1/sfact:model.window(2);
if ~(any(model.window(1) == time)) || ~(any(model.window(2) == time))
    error('"model.window" not compatible with "model.samplerate"')
end

if model.ampflag
    if length(model.eventtimes) ~= length(model.ampbounds)
        error('Number of event amplitude bounds in model not equal to number of events')
    end
    if length(model.eventtimes) ~= length(model.ampvals)
        warning('\nNumber of default event amplitude values does not match number of events\nDisregard if you do not plan on using functions that explicitly require amplitude values\n')
    end
else
    if length(model.eventtimes) ~= length(model.ampvals)
        error('Number of defualt event amplitudes not equal to number of events')
    end
end

if model.ampflag
    if length(model.boxtimes) ~= length(model.boxampbounds)
        error('Number of box amplitude bounds in model not equal to number of boxes')
    end
    if length(model.boxtimes) ~= length(model.boxamps)
        warning('\nNumber of default box amplitude values does not match number of boxes\nDisregard if you do not plan on using functions that explicitly require amplitude values\n')
    end
else
    if length(model.boxtimes) ~= length(model.boxamps)
        error('Number of defualt box amplitudes not equal to number of boxes')
    end
end

if model.latflag
    if length(model.eventtimes) ~= length(model.latbounds)
        error('Number of event latency bounds in model not equal to number of events')
    end
    if length(model.eventtimes) ~= length(model.latvals)
        warning('\nNumber of default event latency values does not match number of events\nDisregard if you do not plan on using functions that explicitly require latency values\n')
    end
else
    if length(model.eventtimes) ~= length(model.latvals)
        error('Number of defualt event latency not equal to number of events')
    end
end

if model.tmaxflag
    if length(model.tmaxbounds) ~= 2
        error('Invalid input for "model.tmaxbounds"')
    end
    if length(model.tmaxval) ~= 1
        warning('\nNumber of default tmax values not equal to 1\nDisregard if you do not plan on using functions that explicitly require tmax value\n')
    end
else
    if length(model.tmaxval) ~= 1
        error('Number of default tmax values not equal to 1')
    end
end

if model.yintflag
    if length(model.yintbounds) ~= 2
        error('Invalid input for "model.yintbounds"')
    end
    if length(model.yintval) ~= 1
        warning('\nNumber of default y-intercept values not equal to 1\nDisregard if you do not plan on using functions that explicitly require y-intercept value\n')
    end
else
    if length(model.yintval) ~= 1
        error('Number of default y-intercept values not equal to 1')
    end
end