function sj = pa_preprocess(data,samplerate,trialwindow,condlabels,baseline,varargin)
% pa_preprocess
% sj = pa_preprocess(data,trialwindow,samplerate,baseline,...)
%
% Prepare pupil area time series data for use with PRF linear model.
%
%   Inputs:
%
%       data = a cell array containing one 2D matrix of epoched pupil size
%       time series data for each separate condition. These matrices are
%       assumed to be in the form (trial number)X(time).
%
%       samplerate = sampling rate of data in Hz.
%
%       trialwindow = a 2 element vector containing the starting and ending
%       times (in ms) of the trial epoch.
%
%       condlabels = a cell array of condition labels for the data. 
%
%       baseline = a 2 element vector containing the starting and ending
%       times (in ms) of the region to be used to baseline normalize each
%       trial (can be empty if normalization turned off).
%
%   Output
%
%       sj = structure containing preprocessed data ready to be estimated
%       with a pupil response function linear model.
%
%   Options
%
%   *Make normalize and blinkinterp pair arguments*
%       'nonormalize': baseline normalization of trials not performed.
%
%       'noblinkinterp': blink interpolation not performed.
%
%       'blinkinterpargs': enter custom values into blink interpolation
%       function. Arguments in the form of [th1 th2 bwindow betblink].
%
%   Jacob Parker 2018

sfact = samplerate/1000;
time = trialwindow(1):1/sfact:trialwindow(2);

%check input arguments
%trialwindow vs samplerate
if ~(any(time == trialwindow(1)) && any(time == trialwindow(2)))
    error('Trial window not compatible with input sampling rate')
end

%trialwindow vs length of trial
for dd =1:length(data)
    if size(data{dd},2) ~= length(time)
        error('Trial length does not match information input about trial duration according to "trialwindow" and "sample rate"')
    end
end

%baseline vs trialwindow
if baseline(1) < trialwindow(1) || baseline(2) > trialwindow(2)
    error('Baseline region falls outside of trial window')
end

%condlabels vs data
if length(condlabels) ~= length(data)
    error('Number of trial matrices in "data" does not match number of labels in "condlabels"')
end

%does baseline actually match up with time points (time vector)?
if ~(any(time == baseline(1)) && any(time == baseline(2)))
    error('Trial window not congruent with input sampling rate')
end

%default options for normalization and blink interpolation
normflag = true;
blinkflag = true;

%default values for blink interpolation function
th1 = 5;
th2 = 3;
bwindow = 50;
betblink = 75;

%check how varargins are parsed in other funcs
for arg = 1:length(varargin)
    switch varargin{arg}
        case 'nonormalize'
            normflag = false;
        case 'noblinkinterp'
            blinkflag = false;
        case 'blinkinterpargs'
            th1 = varargin{arg+1}(1);
            th2 = varargin{arg+1}(2);
            bwindow = varargin{arg+1}(3);
            betblink = varargin{arg+1}(4);
    end
end

%preallocate output structure sj
sj = structure('samplerate',samplerate,'trialwindow',trialwindow,'conditions',condlabels,'baseline',baseline);
datatemp = cell(1,length(data));
for cc = 1:length(condlabels)
    sj.(condlabels{cc}) = nan(size(data{cc},1),size(data{cc},2));
    datatemp{cc} = data{cc};
end

%blink interpolation
if blinkflag
    for dd = 1:length(datatemp)
        for tt = 1:size(datatemp{dd},1)
            datatemp{dd}(tt,:) = blinkinterp(datatemp{dd}(tt,:),samplerate,th1,th2,bwindow,betblink);
        end
    end
end

%normalization
if normflag
    for dd = 1:length(datatemp)
        base = nanmean(datatemp{dd}(:,(-trialwindow(1)*sfact)+(baseline(1)*sfact)+1:(-trialwindow(1)*sfact)+(baseline(2)*sfact)),2);
        for tt = 1:size(datatemp{dd},1)
            datatemp{dd}(tt,:) = (datatemp{dd}(tt,:)-base(tt))/base(tt);
        end
    end
end

%finish filling output structure sj
sj.means = [];
for cc = 1:length(condlabels)
    sj.(condlabels{cc}) = datatemp{cc};
    sj.means.(condlabels{cc}) = nanmean(datatemp{cc},1);
end
