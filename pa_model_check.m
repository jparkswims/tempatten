function pa_model_check(model)
% pa_model_check
% pa_model_check(model)
% 
% Checks if the specifications in "model" are valid. If a model is not
% valid, will throw an error. Otherwise, if a model is valid, no error will
% be thrown.

if ~isfield(model,'ampflag')
    warning('Input "model" does not appear to be a model structure, assuming it is an optim structure')
    return
end

sfact = model.samplerate/1000;
time = model.window(1):1/sfact:model.window(2);
if ~(any(model.window(1) == time)) || ~(any(model.window(2) == time))
    error('"model.window" not compatible with "model.samplerate"')
end

if model.ampflag
    for ii = 1:length(model.eventtimes)
        if (model.ampvals(ii) < model.ampbounds(1,ii)) || (model.ampvals(ii) > model.ampbounds(2,ii))
            error('At least one given amplitude value in model.ampvals is outside of its\nbounds according to the info in model.ampbounds')
        end
    end
    if length(model.eventtimes) ~= size(model.ampbounds,2)
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
    for ii = 1:length(model.boxtimes)
        if (model.boxampvals(ii) < model.boxampbounds(1,ii)) || (model.boxampvals(ii) > model.boxampbounds(2,ii))
            error('At least one given box amplitude value in model.boxampvals is outside of its\nbounds according to the info in model.boxampbounds')
        end
    end
    if length(model.boxtimes) ~= size(model.boxampbounds,2)
        error('Number of box amplitude bounds in model not equal to number of boxes')
    end
    if length(model.boxtimes) ~= length(model.boxampvals)
        warning('\nNumber of default box amplitude values does not match number of boxes\nDisregard if you do not plan on using functions that explicitly require amplitude values\n')
    end
else
    if length(model.boxtimes) ~= length(model.boxampvals)
        error('Number of defualt box amplitudes not equal to number of boxes')
    end
end

if model.latflag
    for ii = 1:length(model.eventtimes)
        if (model.latvals(ii) < model.latbounds(1,ii)) || (model.latvals(ii) > model.latbounds(2,ii))
            error('At least one given latency value in model.latvals is outside of its\nbounds according to the info in model.latbounds')
        end
    end
    if length(model.eventtimes) ~= size(model.latbounds,2)
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
    if (model.tmaxval < model.tmaxbounds(1)) || (model.tmaxval > model.tmaxbounds(2))
        error('Given tmax value in model.tmaxval is outside of its\nbounds according to the info in model.tmaxbounds')
    end
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
    if (model.yintval < model.yintbounds(1)) || (model.yintval > model.yintbounds(2))
        error('Given yint value in model.yintval is outside of its\nbounds according to the info in model.yintbounds')
    end
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
