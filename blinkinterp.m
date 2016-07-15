function output = blinkinterp(trial,th1,th2,bwindow,betblink)

%Jake Parker 2016
%
%blinkinterp detects blink regions in a pupil size timeseries, removes the
%regions, then interpolates through those regions using the surrounding
%data
%
%inputs:
%   trial = time series of pupil sizes
%   th = velocity threshold of pupil size change (to detect blink)
%   bwindow = number of data points away from zero region program looks for
%   blink initiation, offset
%
%output:
%   output = trial with blink regions removed and interpolated

if all(trial) == 0  %check to see if blink regions (zeros) exist in trial
    
    duration = length(trial);
    
    trial = [(trial(1)*ones(1,10)) trial];  %add cushion for convultion
    trial = [trial (trial(end)*ones(1,10))];
    
    h = hanning(11); %function convolved with raw trial
    htrial = conv(trial,h/sum(h),'same'); %generate smoothed trial (easier to read velocity profile
    
    trial(1:10) = []; %remove cushions from trial
    trial(duration+1:end) = [];
    
    htrial(1:10) = []; %remove cushions from smoothed trial
    htrial(duration+1:end) = [];
    
    logtrial = trial ~= 0; %turn trial into a logical vector
    zstarts = find(diff(logtrial) == -1 ) + 1; %find the positions of the first zero for each region
    zends = find(diff(logtrial) == 1); %find the positions of the last zero for each region
    
    if logtrial(1) == 0 %check if trial starts with zero
        zstarts = [1 zstarts]; %if so, adds that position to zstarts
    end
    
    if logtrial(end) == 0 %check if trial ends with zero
        zends = [zends length(trial)]; %if so, adds that position to zends
    end
    
    for k = length(zends)-1:-1:1 %go backward through zends and zstarts
        if zstarts(k+1)-zends(k) < betblink %check to see if interblink regions of data are long enough
            zstarts(k+1) = []; %if not long enough, change zero location data to include that in blink
            zends(k) = [];
        end
    end
    
    for l = 1:length(zends) %this loop fills in determined zero regions with zeros
        trial(zstarts(l):zends(l)) = 0; %this eliminates interblink regions that are too short
        htrial(zstarts(l):zends(l)) = 0; %otherwise problems arise latter in program
    end
    
    t2 = zeros(1,length(zends)); %preload t2 variable
    t3 = zeros(1,length(zends)); %preload t3 variable
    
    for j = 1:length(zends) %this loop determines t2 and t3 points
        
        z1 = zstarts(j); %load small segment of htrial before first zero into wtrial
        if z1 <= bwindow
            wtrial = htrial(1:z1); %for if the first zero is too close to the beginning of htrial
        else
            wtrial = htrial(z1-bwindow:z1);
        end
        
        wt2 = find(diff(wtrial) <= -th1,1,'first'); %find location of first point below velocity threshold
        if isempty(wt2) %find t2
            t2(j) = z1; %t2 when wtrial is all zeros or point can't be found (missing data, not blink)
        else
            t2(j) = z1 - (length(wtrial)-wt2); %t2 when a point can be found
        end
        
        z2 = zends(j); %load a small segment of htrial after last zero into wtrial
        if z2 > length(htrial) - bwindow
            wtrial = htrial(z2:end); %for if last zero is too close to end of htrial
        else
            wtrial = htrial(z2:z2+bwindow);
        end
        
        wt3 = find(diff(wtrial) >= th2,1,'last'); %find location of last point above velocity threshold 
        if isempty(wt3)
            t3(j) = z2; %t3 when wtrial is all zeros or point can't be found (missing data, not blink)
        else
            t3(j) = z2 + wt3; %t3 when a point can be found
        end
        
        trial(t2(j)+1:t3(j)-1) = 0; %put zeros between blink onset and offset
        %cleans data so blink affected points arent chosen as t1 and t4
    end
    
    for j = 1:length(t2) %this loop does interpolations with defined t2 and t3 points
        
        if t2(j) < 5 || t3(j) > length(trial)-5 %if blink is too close to trial boundaries, just put nans into it
            trial(t2(j):t3(j)) = nan;
        else
        
            t1 = t2(j) - (t3(j)-t2(j)); %find t1 
            if t2(j)-t1 > betblink %set limit on how far away t1 can be from t2
                t1 = t2(j) - betblink;
            end
            if t1 < 1 %prevent program from choosing points out of trial bounds
                t1 = 1;
            end
            x = t2(j)-t1; %counter variable
            while trial(t1) == 0 || isnan(trial(t1)) %this loop ensures trial ~= 0 at chosen t1 point
                x = x-1;
                t1 = t2(j) - x; %distance between t1 and t2 shortened until nonzero point found
            end

            t4 = t3(j) + (t3(j) - t2(j)); %find t4
            if t4-t3(j) > betblink %set limit
                t4 = t3(j) + betblink;
            end
            if t4 > length(trial) %prevent program from choosing points out of trial bounds
                t4 = length(trial);
            end
            x = t4-t3(j); %counter variable
            while trial(t4) == 0 || isnan(trial(t4))  %ensures t4 ~= 0
                x = x-1;
                t4 = t3(j) + x; %distance between t3 and t4 shortened until nonzero found
            end
            
            if t1 ~= t2(j) && t3(j) ~= t4 %interp if all points are distinct
                trial(t2(j):t3(j)) = spline([t1 t2(j) t3(j) t4],[trial(t1) trial(t2(j)) trial(t3(j)) trial(t4)],t2(j):t3(j));
            elseif t1 == t2(j) && t3(j) ~= t4 %interp if t1 = t2
                trial(t2(j):t3(j)) = spline([t2(j) t3(j) t4],[trial(t2(j)) trial(t3(j)) trial(t4)],t2(j):t3(j));
            elseif t1 ~= t2(j) && t3(j) == t4 %interp if t3 = t4
                trial(t2(j):t3(j)) = spline([t1 t2(j) t3(j)],[trial(t1) trial(t2(j)) trial(t3(j))],t2(j):t3(j));
            elseif t1 == t2(j) && t3(j) == t4 %interp if t1=t2 and t3=t4
                trial(t2(j):t3(j)) = spline([t2(j) t3(j)],[trial(t2(j)) trial(t3(j))],t2(j):t3(j));
            end
            
        end
        
    end
    
end

output = trial; %trial with blinks interpolated outputed