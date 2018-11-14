function output = pupilrf(t,n,tmax,t0)
% pupilrf
% output = pupilrf(t,n,tmax,t0)
% 
% INPUTS
% t = time vector (in ms)
% n+1 = number of laters (canonical value of n = 10.1)
% tmax = response maximum (canonical value of tmax = 930)
% function is normalized to a max of 0.01 (tmax affects amplitude of pupil
% response function)
% t0 = the time of the event
% 
% OUTPUT
% output = time series of pupil response function resulting from the input
% parameters, at the time points specified in t

output = ((t-t0).^n).*exp(-n.*(t-t0)./tmax);
output((t-t0)<=0) = 0;
output = (output/(max(output))) .* 0.01;
