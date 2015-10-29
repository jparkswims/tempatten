function [output, datapoints, etimepoints, ind] = eventtimeseries(edf,data,eventmessage,window,samplerate,plotfig)

%Function: eventtimeseries(edf,'data','eventmessage',window,plotfig)
%Inputs 
%   edf: edf file already read into the variable edf
%   data: string of desired data type from FSAMPLE struct
%   eventmessage: string of exact message of the event in FEVENT.message
%   window: two element row vector of bounds where 0 is the start time of the event
%   plotfig: 0 for no plot, 1 for plot of average of each trial
%
%Outputs
%   output: matrix where each row is a seperate trial and columns are the data
%   points at each time point before, during, and after the event
%   
%   datapoints: row vector of every data point of the chosen data type
%
%   etimepoints: row vector of all of the etimepoints at which the given
%   event begins
%
%   ind: row vector of the index numbers indicating the data points
%   corresponding to the start times of the event
%
%   example: eventtimesseries(edf,'pa','EVENT_BLACK',[-1000 5000],1)

if nargin < 6
    plotfig = 0;
end

x = 1;



for i = 1:length(edf.FEVENT)
    if length(edf.FEVENT(i).message) == length(eventmessage) % strcmp
        if all(edf.FEVENT(i).message == eventmessage)
            etimepoints(x) = edf.FEVENT(i).sttime;
            x = x+1;
        end
    end
end

timepoints = double(edf.FSAMPLE.time);

if edf.RECORDINGS(1).sample_rate < samplerate
    sf = round(samplerate/(edf.RECORDINGS(1).sample_rate));  
    timepoints = round(interp(timepoints,sf));   %interp1
end

ind = zeros(1,length(etimepoints));

for i = 1:length(etimepoints)
    ind0 = find(timepoints == etimepoints(i));
    if isempty(ind0)
        fprintf('Sample Rate %d , advanced 1 ms at %d\n',edf.RECORDINGS(1).sample_rate,etimepoints(i))
        ind0 = find(timepoints == etimepoints(i)+1);
    end
    ind(i) = ind0;
%     ind(i) = find(edf.FSAMPLE.time == etimepoints(i));
end

output = nan(length(etimepoints),diff(window)+1);

datapoints = eval(sprintf('edf.FSAMPLE.%s',data)); % edf.FSAMPLE.(data)

if datapoints(1,1) < 0
    datapoints = [datapoints(end,:) nan(1,window(2)+1)];
else
    datapoints = [datapoints(1,:) nan(1,window(2)+1)];
end

if edf.RECORDINGS(1).sample_rate < samplerate
    datapoints = round(interp(datapoints,sf));
end

for i = 1:length(etimepoints)
    output(i,1:diff(window)+1) = ...
        [datapoints(ind(i)+window(1):ind(i)+window(2))];
end

if plotfig == 1
    plot(window(1):window(2),avg)
    hold on
    plot([0 0],[0 max(datapoints)],'k')
    xlabel('Time (ms)')
    ylabel(sprintf('%s',data))
    title(sprintf('%s vs time',data))
    
    figure(2)
    plot(edf.FSAMPLE.time,edf.FSAMPLE.(data)(end,:))
    hold on
    for i = 1:length(etimepoints)
        plot([etimepoints(i) etimepoints(i)],[0 max(datapoints)],'k')
        hold on
    end
end
        