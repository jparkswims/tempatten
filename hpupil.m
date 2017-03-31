% http://www.pnas.org/content/suppl/2012/05/11/1201858109.DCSupplemental/sd02.txt

function output = hpupil(t,n,tmax,loc)

% n+1 = number of laters (10.1)
% tmax = response maximum (930)
% function is normalized to a max of 1, in case tmax varies

output = ((t-loc).^n).*exp(-n.*(t-loc)./tmax);
output = output/(max(output));
output((t-loc)<=0) = 0;
%output(1) = 0;
